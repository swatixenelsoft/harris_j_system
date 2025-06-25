import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harris_j_system/services/api_service.dart';

final consultantProvider =
    StateNotifierProvider<GetConsultantNotifier, GetConsultantState>((ref) {
  return GetConsultantNotifier(ApiService());
});

class GetConsultantState {
  bool isLoading;
  bool isEditable;
  final String? error;
  final bool hasLoadedOnce;
  final Map<String, dynamic>? consultantTimeSheet;
  final Map<String, dynamic>? consultantClaimSheet;
  final List<dynamic>? consultantLeaveLog;
  final Map<String, dynamic>? consultantWorkLog;
  final List<dynamic>? timesheetOverview;
  final List<dynamic>? extraTimeLog;
  final List<dynamic>? payOffLog;
  final List<dynamic>? compOffLog;
  final List<dynamic>? claimList;
  final List<dynamic>? getCopies;
  final Map<String, dynamic>? consultantTimesheetRemark;
  final Map<dynamic, dynamic>? consultantData;
  final Map<dynamic, dynamic>? workingLogGraphData;
  final List<dynamic>? claimSummaryData;
  final List<Map<String, dynamic>> claimSummaryTableData;
  final Map<dynamic, dynamic>? basicInfo;

  GetConsultantState({
    this.isLoading = false,
    this.isEditable = false,
    this.error,
    this.hasLoadedOnce = false,
    this.consultantTimeSheet,
    this.consultantClaimSheet,
    this.consultantLeaveLog,
    this.consultantWorkLog,
    this.timesheetOverview,
    this.extraTimeLog,
    this.payOffLog,
    this.compOffLog,
    this.claimList,
    this.getCopies,
    this.consultantTimesheetRemark,
    this.consultantData,
    this.workingLogGraphData,
    this.claimSummaryData,
    this.basicInfo,
    this.claimSummaryTableData = const [],
  });

  GetConsultantState copyWith({
    bool? isLoading,
    bool? isEditable,
    String? error,
    bool? hasLoadedOnce,
    Map<String, dynamic>? consultantTimeSheet,
    Map<String, dynamic>? consultantClaimSheet,
    List<dynamic>? consultantLeaveLog,
    Map<String, dynamic>? consultantWorkLog,
    Map<String, dynamic>? basicInfo,
    List<dynamic>? timesheetOverview,
    List<dynamic>? extraTimeLog,
    List<dynamic>? payOffLog,
    List<dynamic>? compOffLog,
    List<dynamic>? claimList,
    List<dynamic>? getCopies,
    Map<String, dynamic>? consultantTimesheetRemark,
    Map<String, dynamic>? consultantData,
    Map<String, dynamic>? workingLogGraphData,
    List<dynamic>? claimSummaryData,
    List<Map<String, dynamic>>? claimSummaryTableData,
  }) {
    return GetConsultantState(
      isLoading: isLoading ?? this.isLoading,
      isEditable: isEditable ?? this.isEditable,
      error: error,
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
      consultantTimeSheet: consultantTimeSheet ?? this.consultantTimeSheet,
      consultantClaimSheet: consultantClaimSheet ?? this.consultantClaimSheet,
      consultantLeaveLog: consultantLeaveLog ?? this.consultantLeaveLog,
      consultantWorkLog: consultantWorkLog ?? this.consultantWorkLog,
      basicInfo: basicInfo ?? this.basicInfo,
      timesheetOverview: timesheetOverview ?? this.timesheetOverview,
      extraTimeLog: extraTimeLog ?? this.extraTimeLog,
      payOffLog: payOffLog ?? this.payOffLog,
      compOffLog: compOffLog ?? this.compOffLog,
      claimList: claimList ?? this.claimList,
      getCopies: getCopies ?? this.getCopies,
      consultantTimesheetRemark:
          consultantTimesheetRemark ?? this.consultantTimesheetRemark,
      consultantData: consultantData ?? this.consultantData,
      workingLogGraphData: workingLogGraphData ?? this.workingLogGraphData,
      claimSummaryData: claimSummaryData ?? this.claimSummaryData,
      claimSummaryTableData:
          claimSummaryTableData ?? this.claimSummaryTableData,
    );
  }
}

class GetConsultantNotifier extends StateNotifier<GetConsultantState> {
  final ApiService apiService;

  GetConsultantNotifier(this.apiService) : super(GetConsultantState());

  Future<Map<String, dynamic>> updateBasicInfo(
    String firstName,
    String middleName,
    String lastName,
    String dob,
    String selectedCitizen,
    String selectedNationality,
    String address,
    String mobileNumber,
    File selectedImage,
    File selectedResume,
    String token,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final basicInfoResponse = await apiService.updateBasicInfo(
          firstName,
          middleName,
          lastName,
          dob,
          selectedCitizen,
          selectedNationality,
          address,
          mobileNumber,
          selectedImage,
          selectedResume,
          '');

      state = state.copyWith(isLoading: false, isEditable: false);
      return basicInfoResponse;
    } catch (error) {
      print("error123 ${error.toString()}");
      state = state.copyWith(
        isLoading: false,
        isEditable: false,
        error: error.toString(),
      );
      return {
        "success": false,
        "message": error.toString()
        // Add other default values as per your model
      };
    }
  }

  Future<Map<String, dynamic>> consultantTimeSheet(
      String token, String month, String year) async {
    final now = DateTime.now();
    final currentMonth =
        now.month.toString().padLeft(2, '0'); // Ensure "05" format
    final currentYear = now.year.toString();

    final isCurrentMonth = (month == currentMonth && year == currentYear);

    // ✅ Only show loader if it's the first time data is being loaded
    if (!state.hasLoadedOnce) {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      print('token $token,$month,$year');
      final consultantTimeSheetResponse =
          await apiService.consultantTimesheet(token, month, year);

      // ✅ Update state with fetched data and mark as loaded
      state = state.copyWith(
        isEditable: false,
        hasLoadedOnce: true,
        consultantTimeSheet: consultantTimeSheetResponse,
      );

      return consultantTimeSheetResponse;
    } catch (error) {
      print("errortimesheetprovider ${error.toString()}");

      state = state.copyWith(
        isLoading: false,
        isEditable: false,
        error: error.toString(),
      );

      return {"success": false, "message": error.toString()};
    }
  }

  Future<Map<String, dynamic>> consultantClaimSheet(String token) async {
    final now = DateTime.now();

    // ✅ Only show loader if it's the first time data is being loaded
    if (!state.hasLoadedOnce) {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      print('token $token');
      final consultantClaimSheetResponse =
          await apiService.consultantClaimSheet(token);

      print('consultantClaimSheetResponse $consultantClaimSheetResponse');
      // ✅ Update state with fetched data and mark as loaded
      state = state.copyWith(
        isLoading: false,
        isEditable: false,
        hasLoadedOnce: true,
        consultantClaimSheet: consultantClaimSheetResponse,
      );
      print('consultantClaimSheet ${state.consultantClaimSheet}');

      return consultantClaimSheetResponse;
    } catch (error) {
      print("errortimesheetprovider ${error.toString()}");

      state = state.copyWith(
        // isLoading: false,
        isEditable: false,
        error: error.toString(),
      );

      return {"success": false, "message": error.toString()};
    }
  }

  Future<Map<String, dynamic>> consultantLeaveWorkLog(
      String token, String month, String year) async {
    try {
      print('token $token,$month,$year');
      final consultantTimeSheetResponse =
          await apiService.consultantLeaveWorkLog(token, month, year);

      state = state.copyWith(
        isLoading: false,
        isEditable: false,
        consultantLeaveLog: consultantTimeSheetResponse['leave_log'],
        consultantWorkLog: consultantTimeSheetResponse['work_log'],
        timesheetOverview: consultantTimeSheetResponse['timesheet_overview'],
        extraTimeLog: consultantTimeSheetResponse['extra_time_log'],
        payOffLog: consultantTimeSheetResponse['pay_off_log'],
        compOffLog: consultantTimeSheetResponse['comp_off_log'],
        getCopies: consultantTimeSheetResponse['get_copies'],
      );

      return consultantTimeSheetResponse;
    } catch (error) {
      print("errortimesheetprovider ${error.toString()}");

      state = state.copyWith(
        isLoading: false,
        isEditable: false,
        error: error.toString(),
      );
      return {"success": false, "message": error.toString()};
    }
  }

  Future<Map<String, dynamic>> consultantClaimAndCopies(
      String token, String month, String year) async {
    try {
      print('token $token,$month,$year');
      final consultantClaimAndCopiesResponse =
          await apiService.consultantClaimAndCopy(token, month, year);
      print(
          'consultantClaimAndCopiesResponse $consultantClaimAndCopiesResponse');
      state = state.copyWith(
        isLoading: false,
        isEditable: false,
        claimList: consultantClaimAndCopiesResponse['data']['claims'],
        getCopies: consultantClaimAndCopiesResponse['data']['getCopies'],
      );
      print('claimList ${state.claimList}');

      return consultantClaimAndCopiesResponse;
    } catch (error) {
      print("errortimesheetprovider ${error.toString()}");

      state = state.copyWith(
        isLoading: false,
        isEditable: false,
        error: error.toString(),
      );
      return {"success": false, "message": error.toString()};
    }
  }

  Future<Map<String, dynamic>> consultantTimesheetRemarks(
      String url, String token, String month, String year) async {
    try {
      print('token $token,$month,$year');
      final consultantTimeSheetRemarkResponse =
          await apiService.consultantTimesheetRemark(url, token, month, year);

      state = state.copyWith(
        isLoading: false,
        isEditable: false,
        consultantTimesheetRemark: consultantTimeSheetRemarkResponse,
      );

      return consultantTimeSheetRemarkResponse;
    } catch (error) {
      print("errortimesheetprovider ${error.toString()}");

      state = state.copyWith(
        isLoading: false,
        isEditable: false,
        error: error.toString(),
      );
      return {"success": false, "message": error.toString()};
    }
  }

  Future<Map<String, dynamic>> addConsultantFeedback(
      String token, String feedback, int userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final feedbackResponse =
          await apiService.addFeedBack(token, userId, feedback);

      state = state.copyWith(
        isLoading: false,
      );
      return feedbackResponse;
    } catch (error) {
      print("errorFeedbackProvider ${error.toString()}");

      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
      return {"success": false, "message": error.toString()};
    }
  }

  Future<void> fetchDashBoardData(String token) async {
    state = state.copyWith(isLoading: true, error: null);
    print('vtoken $token');

    try {
      final response = await apiService.fetchDashboardData(token);
      final bool status = response['status'] ?? false;

      print('response1 $response');

      if (status) {
        final user = response['user'];
        final workingLog = response['working_log'];
        final claimsSummary = response['claims_summary'];

        // Convert claim summary to table data
        final List<Map<String, dynamic>> tableData =
            (claimsSummary as List<dynamic>? ?? [])
                .map<Map<String, dynamic>>((item) {
          print('item $item');
          final claimNo = item['claim_no'] ?? '';

          final rawAmount = item['record']['amount'] ?? '0';
          final amount = double.tryParse(rawAmount.toString()) ?? 0.0;
          final submitDate = item['record']['applyOnCell'] ?? '';
          final status = item['status'] ?? 'Unknown';

          final style = getStatusStyle(status);
// print()
          return {
            'claimForm': '#$claimNo',
            'amount': '\$${amount.toStringAsFixed(2)}',
            'submitDate': formatDate(submitDate),
            'status': status,
            'statusColor': style['color'],
            'statusBackground': style['background'],
          };
        }).toList();

        // Update state
        state = state.copyWith(
          isLoading: false,
          consultantData: user,
          workingLogGraphData: workingLog,
          claimSummaryData: claimsSummary,
          claimSummaryTableData:
              tableData, // You need to add this in your state class
        );

        print('Data loaded successfully');
        print('consultantData: ${state.consultantData}');
        print('workingLogGraphData: ${state.workingLogGraphData}');
        print('claimSummaryData: ${state.claimSummaryData}');
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid response from server',
        );
        print('Error: Invalid response from server');
      }
    } catch (error, stack) {
      print('❌ Error fetching dashboard data: $error');
      print('Stack trace:\n$stack');
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }

  Future<Map<String, dynamic>> addTimesheetData(
    String token,
    String userId,
    String type,
    String clientId,
    String clientName,
    String status,
    List<dynamic> record,
    String corporateEmail,
    String reportingManagerEmail,
    String selectMonth,
    String selectYear,
    dynamic certificate,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final addTimesheetResponse = await apiService.addTimeSheetData(
          token,
          userId,
          type,
          clientId,
          clientName,
          status,
          record,
          corporateEmail,
          reportingManagerEmail,
          selectMonth,
          selectYear,
          certificate);

      print("addTimesheetResponse $addTimesheetResponse");
      state = state.copyWith(isEditable: false);
      return addTimesheetResponse;
    } catch (error) {
      print("error123 ${error.toString()}");
      state = state.copyWith(
        isLoading: false,
        isEditable: false,
        error: error.toString(),
      );
      return {
        "success": false,
        "message": error.toString()
        // Add other default values as per your model
      };
    }
  }

  Future<Map<String, dynamic>> addClaimData(
    String token,
    String userId,
    String type,
    String clientId,
    String clientName,
    String status,
    Map<String, dynamic> record,
    String corporateEmail,
    String reportingManagerEmail,
    String selectMonth,
    String selectYear,
    dynamic certificate,
    String claimId,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final addClaimResponse = await apiService.addClaimData(
        token,
        userId,
        type,
        clientId,
        clientName,
        status,
        record,
        corporateEmail,
        reportingManagerEmail,
        selectMonth,
        selectYear,
        certificate,
        claimId,
      );

      print("addClaimResponse $addClaimResponse");
      state = state.copyWith(isEditable: false, isLoading: false);
      return addClaimResponse;
    } catch (error) {
      print("error123 ${error.toString()}");
      state = state.copyWith(
        isLoading: false,
        isEditable: false,
        error: error.toString(),
      );
      return {
        "success": false,
        "message": error.toString()
        // Add other default values as per your model
      };
    }
  }

  Future<Map<String, dynamic>> deleteClaim(
      int id, String token, String selectedMonth, String selectedYear) async {
    try {
      final response = await apiService.deleteClaims(id, token);
      final bool status = response['status'] ?? false;

      if (status) {
        await consultantClaimAndCopies(
            token, selectedMonth, selectedYear); // Refresh list
        state = state.copyWith(isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response['message'] ?? 'Delete failed',
        );
      }

      return response;
    } catch (e) {
      final errorMsg = e.toString();
      state = state.copyWith(isLoading: false, error: errorMsg);
      return {'status': false, 'message': errorMsg};
    }
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Map<String, dynamic> getStatusStyle(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return {
          'color': const Color(0xff28A745),
          'background': const Color.fromRGBO(0, 186, 52, 0.1),
        };
      case 'submitted':
        return {
          'color': const Color(0xffFFC107),
          'background': const Color.fromRGBO(255, 193, 7, 0.1),
        };
      case 'pending':
      case 'draft':
        return {
          'color': const Color(0xffFF1901),
          'background': const Color.fromRGBO(255, 25, 1, 0.1),
        };
      default:
        return {
          'color': Colors.grey,
          'background': Colors.grey.withOpacity(0.1),
        };
    }
  }

  String formatDate(String dateStr) {
    try {
      // Clean the string and split it
      final parts = dateStr.split('/').map((s) => s.trim()).toList();
      if (parts.length != 3) return dateStr;

      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);

      return '${date.day}${_getDaySuffix(date.day)} ${_monthName(date.month)}, ${date.year}';
    } catch (e) {
      print('⚠️ Failed to parse date: $dateStr');
      return dateStr; // fallback in case of parsing error
    }
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }
}
