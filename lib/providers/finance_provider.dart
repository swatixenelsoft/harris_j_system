import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harris_j_system/services/api_service.dart';

import '../screens/finance/finance_invoice_screen.dart';

final financeProvider =
StateNotifierProvider<GetFinanceNotifier, GetFinanceState>((ref) {
  return GetFinanceNotifier(ApiService());
});

class GetFinanceState {
  final bool isLoading;
  final String? error;
  final List<dynamic> consultantList;
  final Map<String, dynamic> dashboardData;
  final List<dynamic>? hrConsultantList;
  final Map<String, dynamic> selectedConsultantData;
  final List<Map<String, dynamic>> groupList; // Added for group data

  GetFinanceState({
    this.isLoading = false,
    this.error,
    this.consultantList = const [],
    this.dashboardData = const {},
    this.hrConsultantList,
    this.selectedConsultantData = const {},
    this.groupList = const [], // Initialize as empty list
  });

  GetFinanceState copyWith({
    bool? isLoading,
    String? error,
    List<dynamic>? consultantList,
    Map<String, dynamic>? dashboardData,
    List<dynamic>? hrConsultantList,
    Map<String, dynamic>? selectedConsultantData,
    List<Map<String, dynamic>>? groupList,
  }) {
    return GetFinanceState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      consultantList: consultantList ?? this.consultantList,
      dashboardData: dashboardData ?? this.dashboardData,
      hrConsultantList: hrConsultantList ?? this.hrConsultantList,
      selectedConsultantData:
      selectedConsultantData ?? this.selectedConsultantData,
      groupList: groupList ?? this.groupList,
    );
  }
}

class GetFinanceNotifier extends StateNotifier<GetFinanceState> {
  final ApiService apiService;

  GetFinanceNotifier(this.apiService) : super(GetFinanceState());

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<Map<String, dynamic>> clientList(String token) async {
    state = state.copyWith(error: null);
    try {
      print('token $token');
      final clientResponse = await apiService.getFinanceClientList(token);
      return clientResponse;
    } catch (error) {
      print("errorclientlistprovider ${error.toString()}");
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
      return {"success": false, "message": error.toString()};
    }
  }

  Future<Map<String, dynamic>> getConsultantByClient(
      String clientId, String token) async {
    try {
      final response = await apiService.getConsultantByClient(clientId, token);
      final bool status = response['status'] ?? false;

      if (status) {
        print('consultantListres ${status}');
        state =
            state.copyWith(consultantList: response['data'], isLoading: false);
        print('consultantList ${state.consultantList}');
      } else {
        print('consultantListres ${status}');
        state = state.copyWith(
          consultantList: response['data'],
          isLoading: false,
          error: response['message'] ?? 'Failed to fetch consultant',
        );
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

  Future<Map<String, dynamic>> deleteConsultant(
      int id, String token, String clientId) async {
    try {
      final response = await apiService.deleteConsultant(id, token);
      final bool status = response['status'] ?? false;

      if (status) {
        getConsultantByClient(clientId, token);
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
      }) async {
    state = state.copyWith(error: null);

    try {
      final response = await apiService.getConsultantTimesheetByClient(
          clientId, month, year, token);
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
          selectedConsultantData: {},
        );

        print('previouslySelectedConsultant $previouslySelectedConsultant');
        print('previouslySelectedConsultant33 $month');
        if (previouslySelectedConsultant != null) {
          final selectedEmpId =
          previouslySelectedConsultant['consultant_info']?['user_id'];
          print('selectedEmpId $selectedEmpId');
          if (selectedEmpId != null) {
            print('fullConsultants $fullConsultants');
            final updatedConsultant = fullConsultants.firstWhere(
                  (e) {
                print(
                    'user_id ${e['consultant_info']?['user_id']},$selectedEmpId');
                return e['consultant_info']?['user_id'] == selectedEmpId;
              },
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

  Future<void> getConsultantClaimsByClientFinance(
      String clientId,
      String month,
      String year,
      String token, {
        Map<String, dynamic>? previouslySelectedConsultant,
      }) async {
    state = state.copyWith(error: null);

    try {
      final response = await apiService.getConsultantClaimsByClientFinance(
          clientId, month, year, token);
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
          selectedConsultantData: {},
        );

        print('previouslySelectedConsultant $previouslySelectedConsultant');
        print('previouslySelectedConsultant33 $month');
        if (previouslySelectedConsultant != null) {
          final selectedEmpId =
          previouslySelectedConsultant['consultant_info']?['user_id'];
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

  Future<void> getConsultantTimesheetByClientFinance(
      String clientId,
      String month,
      String year,
      String token, {
        Map<String, dynamic>? previouslySelectedConsultant,
      }) async {
    state = state.copyWith(error: null);
    try {
      final response = await apiService.getConsultantTimesheetByClientFinance(
        clientId,
        month,
        year,
        token,
      );
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
          selectedConsultantData: {},
        );
        if (previouslySelectedConsultant != null) {
          final selectedEmpId =
          previouslySelectedConsultant['consultant_info']?['user_id'];
          if (selectedEmpId != null) {
            final updatedConsultant = fullConsultants.firstWhere(
                  (e) => e['consultant_info']?['user_id'] == selectedEmpId,
              orElse: () => {},
            );
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

  Future<Map<String, dynamic>> getConsultantsByClientFinance(
      String clientId, String token) async {
    state = state.copyWith(error: null, isLoading: true);

    try {
      final response =
      await apiService.getConsultantsByClientFinance(clientId, token);
      final bool status = response['status'] ?? false;

      if (status) {
        final List<dynamic> consultants = response['data'] ?? [];

        final List<Map<String, dynamic>> flattenedConsultantList =
        consultants.map<Map<String, dynamic>>((consultant) {
          final Map<String, dynamic> consultantInfo =
          Map<String, dynamic>.from(consultant['data'] ?? {});
          consultant.forEach((key, value) {
            debugPrint("key value = $key - $value");
            if (key != null) {
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
          selectedConsultantData: {},
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          consultantList: [],
          hrConsultantList: [],
          error: response['message'] ?? 'Failed to fetch consultants',
          isLoading: false,
        );
      }

      return response;
    } catch (e) {
      final errorMsg = e.toString();
      state = state.copyWith(isLoading: false, error: errorMsg);
      return {'status': false, 'message': errorMsg};
    }
  }

  Future<Map<String, dynamic>> createGroupFinance({
    required String clientId,
    required String groupName,
    required List<String> consultantIds,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      debugPrint("consult $consultantIds");
      final response = await apiService.createGroupFinance(
        clientId: clientId,
        groupName: groupName,
        consultantIds: consultantIds,
        token: token,
      );

      state = state.copyWith(isLoading: false);
      return response;
    } catch (e) {
      final errorMsg = e.toString();
      state = state.copyWith(isLoading: false, error: errorMsg);
      return {
        'success': false,
        'message': errorMsg,
      };
    }
  }
  Future<Map<String, dynamic>> editGroupFinance({
    required String clientId,
    required String groupName,
    required List<String> consultantIds,
    required String token,
    required String groupId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      debugPrint("consult $consultantIds");
      final response = await apiService.editGroupFinance(
        clientId: clientId,
        groupName: groupName,
        consultantIds: consultantIds,
        token: token, groupId: groupId,
      );

      state = state.copyWith(isLoading: false);
      groupListFinanceProvider(token: token);
      return response;
    } catch (e) {
      final errorMsg = e.toString();
      state = state.copyWith(isLoading: false, error: errorMsg);
      return {
        'success': false,
        'message': errorMsg,
      };
    }
  }
  Future<Map<String, dynamic>> deleteGroupFinance({
    required String token,
    required String groupId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiService.deleteGroupFinance(
        token: token, groupId: groupId,
      );

      state = state.copyWith(isLoading: false);
      groupListFinanceProvider(token: token);
      return response;
    } catch (e) {
      final errorMsg = e.toString();
      state = state.copyWith(isLoading: false, error: errorMsg);
      return {
        'success': false,
        'message': errorMsg,
      };
    }
  }

  Future<Map<String, dynamic>> groupListFinanceProvider({
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await apiService.groupListFinance(token: token);
      final bool status = response['success'] ?? false;

      if (status) {
        final List<Map<String, dynamic>> groupData =
        (response['data'] as List<dynamic>).cast<Map<String, dynamic>>();
        debugPrint("here is - $groupData");
        state = state.copyWith(
          isLoading: false,
          groupList: groupData,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response['message'] ?? 'Failed to fetch group list',
        );
      }

      return response;
    } catch (e) {
      final errorMsg = e.toString();
      state = state.copyWith(isLoading: false, error: errorMsg);
      return {
        'success': false,
        'message': errorMsg,
      };
    }
  }

  void getSelectedConsultantDetails(Map<String, dynamic> selectedConsultant) {
    final rawData = selectedConsultant['data'];
    final backdateData =
    (rawData is List && rawData.isEmpty) ? {} : (rawData ?? {});
    final status = selectedConsultant['status'] ?? '';
    final remarks = selectedConsultant['remarks'] ?? [];
    final timesheetData = selectedConsultant['timesheet_data'] ?? [];
    final timesheetOverview = selectedConsultant['timesheet_overview'] ?? [];
    final extraTimeLog = selectedConsultant['extra_time_log'] ?? [];
    final payOffLog = selectedConsultant['pay_off_log'] ?? [];
    final compOffLog = selectedConsultant['comp_off_log'] ?? [];
    final getCopies = selectedConsultant['get_copies'] ?? [];
    final claims = selectedConsultant['claims'] ?? [];
    final claimTab = selectedConsultant['claim_tab'] ?? [];

    state = state.copyWith(
      selectedConsultantData: {
        'data': backdateData,
        'status': status,
        'remarks': remarks,
        'timesheet_data': timesheetData,
        'timesheet_overview': timesheetOverview,
        'extra_time_log': extraTimeLog,
        'pay_off_log': payOffLog,
        'comp_off_log': compOffLog,
        'get_copies': getCopies,
        'claim_tab': claimTab,
        'claims': claims,
      },
    );

}

  Future<Map<String, dynamic>> clientListClaimInvoice(String token) async {
    state = state.copyWith(error: null);
    try {
      print('token $token');
      final clientResponse = await apiService.getClientListClaimInvoiceFinance(token);

      return clientResponse;
    } catch (error) {
      print("errorclientlistprovider ${error.toString()}");

      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
      return {"success": false, "message": error.toString()};
    }


  }


  Future<void> financeClaimClientConsultants(String clientId,
      String month,
      String year,
      String token) async {
    state = state.copyWith(error: null);
    try {
      final response = await apiService.financeClaimClientConsultants(
        clientId, month, year, token,
      );
      final bool status = response['success'] ?? false;

      if (status) {
        final List<dynamic> consultants = response['data'] ?? [];


        print('consultants $consultants');


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
}
