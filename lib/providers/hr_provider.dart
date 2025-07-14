import 'dart:developer';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harris_j_system/services/api_service.dart';

final hrProvider =
StateNotifierProvider<GetHrNotifier, GetHrState>((ref) {
  return GetHrNotifier(ApiService());
});

class GetHrState {
  final bool isLoading;
  final String? error;
 final List<dynamic> consultantList;
 final Map<String,dynamic> dashboardData;
  final List<dynamic>? hrConsultantList;
 final Map<String, dynamic> selectedConsultantData;

  GetHrState({
    this.isLoading = false,
    this.error,
    this.consultantList = const [],
    this.dashboardData=const{},
    this.hrConsultantList,
    this.selectedConsultantData=const{},
  });

  GetHrState copyWith({
    bool? isLoading,
    String? error,
    List<dynamic>? consultantList,
    Map<String,dynamic>? dashboardData,
    List<dynamic>? hrConsultantList,
    Map<String,dynamic>? selectedConsultantData,
  }) {
    return GetHrState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      consultantList: consultantList ?? this.consultantList,
      dashboardData: dashboardData??this.dashboardData,
      hrConsultantList: hrConsultantList??this.hrConsultantList,
      selectedConsultantData: selectedConsultantData??this.selectedConsultantData,
    );
  }
}

class GetHrNotifier extends StateNotifier<GetHrState> {
  final ApiService apiService;

  GetHrNotifier(this.apiService) : super(GetHrState());

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<Map<String , dynamic>> clientList(String token) async{
    state = state.copyWith( error: null);
    try {
      print('token $token');
      final clientResponse =
      await apiService.getClientList(token);



      return clientResponse;
    } catch (error) {
      print("errorclientlistprovider ${error.toString()}");

      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
      return {"success": false,"message": error.toString()};
    }
  }


  Future<Map<String, dynamic>> getDashBoardByClient(String clientId,String token) async {
    try {
      final response = await apiService.getDashBoardByClient(clientId,token);
      final bool status = response['status'] ?? false;

      if (status) {
        print('dashboardDataif ${status}');
        state = state.copyWith(dashboardData: response);
        print('dashboardData ${state.dashboardData}');
      } else {
        print('dashboardData ${status}');
        state = state.copyWith(dashboardData: response,error: response['message'] ?? 'Failed to fetch consultant',);
        print('consultantList ${state.consultantList}');
      }

      return response;
    } catch (e) {
      final errorMsg = e.toString();
      print('consultantList ${errorMsg}');
      state = state.copyWith(isLoading: false, error: errorMsg);
      return {'status': false, 'message': errorMsg};
    }
  }

  Future<Map<String, dynamic>> addConsultant(
      String employeeName,
      String employeeCode,
      String gender,
      String fullAddress,
      String showInputAddress,
      String dob,
      String age,
      String countryCode,
      String primaryMobile,
      String primaryEmail,
      String joiningDate,
      String endDate,
      String client,
      String employeeStatus,
      String holidayProfile,
      String residential,
      String contractPeriod,
      String designation,
      String billingAmount,
      String workingHours,
      String adminEmail,
      bool resetPassword,
      int userId,
      File consultantImage,
      String token,
      ) async
  {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final addConsultancyResponse = await apiService.addConsultant(
          employeeName,
          employeeCode,
          gender,
          fullAddress,
          showInputAddress,
        dob,
          age,
          countryCode,
          primaryMobile,
          primaryEmail,
          joiningDate,
          endDate,
          client,
          employeeStatus,
         holidayProfile,
          residential,
         contractPeriod,
       designation,
          billingAmount,
          workingHours,
          adminEmail,
          resetPassword,
          userId,
          consultantImage, token,
      );
      getConsultantByClient(client,token);
      state = state.copyWith(isLoading: false);
      return addConsultancyResponse;
    } catch (error) {
      print("error123 ${error.toString()}");
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
      return {
        "status": false,
        "message": error.toString()
        // Add other default values as per your model
      };
    }
  }

Future<Map<String, dynamic>> getConsultantByClient(String clientId,String token) async {
  try {
    final response = await apiService.getConsultantByClient(clientId,token);
    final bool status = response['status'] ?? false;

    if (status) {
      print('consultantListres ${status}');
      state = state.copyWith(consultantList: response['data'],isLoading: false);
      print('consultantList ${state.consultantList}');
    } else {
      print('consultantListres ${status}');
      state = state.copyWith(consultantList: response['data'],isLoading: false,error: response['message'] ?? 'Failed to fetch consultant',);
      print('consultantList ${state.consultantList}');
    }

    return response;
  } catch (e) {
    final errorMsg = e.toString();
    print('consultantList ${errorMsg}');
    state = state.copyWith(isLoading: false, error: errorMsg);
    return {'status': false, 'message': errorMsg};
  }
}

  Future<Map<String, dynamic>> deleteConsultant(int id,String token,String clientId) async {
    try {
      final response = await apiService.deleteConsultant(id,token);
      final bool status = response['status'] ?? false;

      if (status) {
        getConsultantByClient(clientId,token);
        // await fetchConsultancy(token); // Refresh list
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

  Future<void> getConsultantTimeSheetByClient(
      String clientId,
      String month,
      String year,
      String token, {
        Map<String, dynamic>? previouslySelectedConsultant,
      }) async
  {
    state = state.copyWith(error: null);

    try {
      final response = await apiService.getConsultantTimesheetByClient(clientId, month, year, token);
      final bool status = response['status'] ?? false;

      if (status) {
        final List<dynamic> consultants = response['data'] ?? [];

        final List<Map<String, dynamic>> flattenedConsultantList =
        consultants.map<Map<String, dynamic>>((consultant) {
          final Map<String, dynamic> consultantInfo =
          Map<String, dynamic>.from(consultant['consultant_info'] ?? {});
          consultant.forEach((key, value) {
            if (key != 'consultant_info') {
              consultantInfo[key] = value;
            }
          });
          return consultantInfo;
        }).toList();

        final List<Map<String, dynamic>> fullConsultants =
        consultants.whereType<Map<String, dynamic>>().toList();

        state = state.copyWith(
          consultantList: flattenedConsultantList,
          hrConsultantList: fullConsultants,
          selectedConsultantData: {}, // Reset for safety
        );

        print('previouslySelectedConsultant $previouslySelectedConsultant');
        print('previouslySelectedConsultant33 $month');
        // ✅ Match selected consultant again after refresh
        if (previouslySelectedConsultant != null) {
          final selectedEmpId = previouslySelectedConsultant['consultant_info']?['user_id'];
          print('selectedEmpId $selectedEmpId');
          if (selectedEmpId != null) {

print('fullConsultants $fullConsultants');
            final updatedConsultant = fullConsultants.firstWhere(
                  (e) {
                    print('user_id ${e['consultant_info']?['user_id']},$selectedEmpId');
                    return e['consultant_info']?['user_id'] == selectedEmpId;},
              orElse: () => {},
            );

            print('updatedConsultan11t ${updatedConsultant['']}');


            if (updatedConsultant.isNotEmpty) {
              getSelectedConsultantDetails(updatedConsultant);
            }
          }
        }
      } else {
        state = state.copyWith(
          error: response['message'] ?? 'Failed to fetch consultants',
          consultantList: [],
          hrConsultantList: [],
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }


  Future<void> getConsultantClaimsByClient(
      String clientId,
      String month,
      String year,
      String token, {
        Map<String, dynamic>? previouslySelectedConsultant,
      }) async
  {
    state = state.copyWith(error: null);

    try {
      final response = await apiService.getConsultantClaimsByClient(clientId, month, year, token);
      final bool status = response['status'] ?? false;

      if (status) {
        final List<dynamic> consultants = response['data'] ?? [];

        final List<Map<String, dynamic>> flattenedConsultantClaimsList =
        consultants.map<Map<String, dynamic>>((consultant) {
          final Map<String, dynamic> consultantInfo =
          Map<String, dynamic>.from(consultant['consultant_info'] ?? {});
          consultant.forEach((key, value) {
            if (key != 'consultant_info') {
              consultantInfo[key] = value;
            }
          });
          return consultantInfo;
        }).toList();

        final List<Map<String, dynamic>> fullConsultantsClaim =
        consultants.whereType<Map<String, dynamic>>().toList();

        state = state.copyWith(
          consultantList: flattenedConsultantClaimsList,
          hrConsultantList: fullConsultantsClaim,
          selectedConsultantData: {}, // Reset for safety
        );

        print('previouslySelectedConsultant $previouslySelectedConsultant');
        print('previouslySelectedConsultant33 $month');
        // ✅ Match selected consultant again after refresh
        if (previouslySelectedConsultant != null) {
          final selectedEmpId = previouslySelectedConsultant['consultant_info']?['user_id'];
          print('selectedEmpId $selectedEmpId');
          if (selectedEmpId != null) {

            final updatedConsultant = fullConsultantsClaim.firstWhere(
                  (e) => e['consultant_info']?['user_id'] == selectedEmpId,
              orElse: () => {},
            );

            print('updatedConsultant ${updatedConsultant['timesheet_data']}');


            if (updatedConsultant.isNotEmpty) {
              getSelectedConsultantDetails(updatedConsultant);
            }
          }
        }
      } else {
        state = state.copyWith(
          error: response['message'] ?? 'Failed to fetch consultants',
          consultantList: [],
          hrConsultantList: [],
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }


   getSelectedConsultantDetails(Map<String, dynamic> selectedConsultant) {
    final rawData = selectedConsultant['data'];
    final backdateData = (rawData is List && rawData.isEmpty) ? {} : (rawData ?? {});
    print(' statussss ${selectedConsultant['status']}');
    final status= selectedConsultant['status']??'';
    final remarks = selectedConsultant['remarks'] ?? [];
    final timesheetData = selectedConsultant['timesheet_data'] ?? [];
    final timesheetOverview = selectedConsultant['timesheet_overview'] ?? [];
    final extraTimeLog = selectedConsultant['extra_time_log'] ?? [];
    final payOffLog = selectedConsultant['pay_off_log'] ?? [];
    final compOffLog = selectedConsultant['comp_off_log'] ?? [];
    final getCopies = selectedConsultant['get_copies'] ?? [];

    // ✅ Claims-specific keys
    final claims = selectedConsultant['claims'] ?? [];
    final claimTab = selectedConsultant['claim_tab'] ?? [];


    // Update state
    state = state.copyWith(
      selectedConsultantData: {
        'data': backdateData,
        'status':status,
        'remarks': remarks,
        'timesheet_data': timesheetData,
        'timesheet_overview': timesheetOverview,
        'extra_time_log': extraTimeLog,
        'pay_off_log': payOffLog,
        'comp_off_log': compOffLog,
        'get_copies': getCopies,
        'claim_tab': claimTab,
        'claims':claims,
      },
    );

    print('Selected consultant data updated');
  }


// Future<Map<String, dynamic>> editConsultancy(
  //     int id,
  //     String consultancyName,
  //     String consultancyId,
  //     String uenNumber,
  //     String fullAddress,
  //     String showAddressInput,
  //     String primaryContact,
  //     String primaryMobile,
  //     String primaryEmail,
  //     String secondaryContact,
  //     String secondaryEmail,
  //     String secondaryMobile,
  //     String consultancyType,
  //     String consultancyStatus,
  //     String licenseStartDate,
  //     String licenseEndDate,
  //     String licenseNumber,
  //     String feesStructure,
  //     String lastPaidStatus,
  //     String adminEmail,
  //     String primaryMobileCountryCode,
  //     String secondaryMobileCountryCode,
  //     bool resetPassword,
  //     int userId,
  //     File consultancyImage,
  //     String token,
  //     ) async
  // {
  //   state = state.copyWith(isLoading: true, error: null);
  //   try {
  //     print(
  //         "edit-consultancy$id, $consultancyName,$consultancyId,$uenNumber,$fullAddress,$showAddressInput,$primaryContact,$primaryMobile,$primaryEmail,$secondaryContact,$secondaryEmail,$secondaryMobile,$consultancyType,$consultancyStatus,$licenseStartDate,$licenseEndDate,$licenseNumber,$feesStructure,$lastPaidStatus,$adminEmail,$primaryMobileCountryCode,$secondaryMobileCountryCode,$userId,$resetPassword,$consultancyImage");
  //     final editConsultancyResponse = await apiService.editConsultancy(
  //         id,
  //         consultancyName,
  //         consultancyId,
  //         uenNumber,
  //         fullAddress,
  //         showAddressInput,
  //         primaryContact,
  //         primaryMobile,
  //         primaryEmail,
  //         secondaryContact,
  //         secondaryMobile,
  //         secondaryEmail,
  //         consultancyType,
  //         consultancyStatus,
  //         licenseStartDate,
  //         licenseEndDate,
  //         licenseNumber,
  //         feesStructure,
  //         lastPaidStatus,
  //         adminEmail,
  //         primaryMobileCountryCode,
  //         secondaryMobileCountryCode,
  //         resetPassword,
  //         userId,
  //         consultancyImage,token);
  //
  //     // if (editConsultancyResponse['status']) {
  //     await fetchConsultancy(token); // Refresh list
  //     state = state.copyWith(isLoading: false);
  //     return editConsultancyResponse;
  //     // }
  //
  //
  //   } catch (error) {
  //     print("error123 ${error.toString()}");
  //     state = state.copyWith(
  //       isLoading: false,
  //       error: error.toString(),
  //     );
  //     return {
  //       "success": false,
  //       "message": error.toString()
  //       // Add other default values as per your model
  //     };
  //   }
  // }

  // Future<Map<String, dynamic>> deleteConsultancy(int id,String token) async {
  //   try {
  //     final response = await apiService.deleteConsultancy(id,token);
  //     final bool status = response['status'] ?? false;
  //
  //     if (status) {
  //       await fetchConsultancy(token); // Refresh list
  //       state = state.copyWith(isLoading: false);
  //     } else {
  //       state = state.copyWith(
  //         isLoading: false,
  //         error: response['message'] ?? 'Delete failed',
  //       );
  //     }
  //
  //     return response;
  //   } catch (e) {
  //     final errorMsg = e.toString();
  //     state = state.copyWith(isLoading: false, error: errorMsg);
  //     return {'status': false, 'message': errorMsg};
  //   }
  // }


}
