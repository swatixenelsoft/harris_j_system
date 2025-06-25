import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harris_j_system/services/api_service.dart';

final consultancyProvider =
    StateNotifierProvider<ConsultancyNotifier, ConsultancyState>((ref) {
  return ConsultancyNotifier(ApiService());
});

class ConsultancyState {
  final bool isLoading;
  final String? error;
  final List<dynamic>? clientList;
  final List<dynamic>? usersList;

  ConsultancyState({
    this.isLoading = false,
    this.error,
    this.clientList = const [],
    this.usersList = const [],
  });

  ConsultancyState copyWith({
    bool? isLoading,
    String? error,
    List<dynamic>? clientList,
    List<dynamic>? usersList,
  }) {
    return ConsultancyState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      clientList: clientList ?? this.clientList,
      usersList: usersList ?? this.usersList,
    );
  }
}

class ConsultancyNotifier extends StateNotifier<ConsultancyState> {
  final ApiService apiService;

  ConsultancyNotifier(this.apiService) : super(ConsultancyState());

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<Map<String, dynamic>> getClientList(String token) async {
    try {
      final response = await apiService.getClient(token);
      final bool status = response['status'] ?? false;

      if (status) {
        print('consultantListres ${status}');
        state = state.copyWith(clientList: response['data'], isLoading: false);
        print('consultantList ${state.clientList}');
      } else {
        print('consultantListres ${status}');
        state = state.copyWith(
          clientList: response['data'],
          isLoading: false,
          error: response['message'] ?? 'Failed to fetch consultant',
        );
        print('consultantList ${state.clientList}');
      }

      return response;
    } catch (e) {
      final errorMsg = e.toString();
      print('consultantList ${errorMsg}');
      state = state.copyWith(isLoading: false, error: errorMsg);
      return {'status': false, 'message': errorMsg};
    }
  }

  Future<Map<String, dynamic>> addClient(
    String servingClient,
    String clientId,
    String primaryContact,
    String primaryMobile,
    String primaryEmail,
    String secondaryContact,
    String secondaryMobile,
    String secondaryEmail,
    String fullAddress,
    String description,
    String showInputAddress,
    String clientStatus,
    String primaryCode,
    String secondaryCode,
    String token,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final addConsultancyResponse = await apiService.addClient(
        servingClient,
        clientId,
        primaryContact,
        primaryMobile,
        primaryEmail,
        secondaryContact,
        secondaryMobile,
        secondaryEmail,
        fullAddress,
        description,
        showInputAddress,
        clientStatus,
        primaryCode,
        secondaryCode,
        token,
      );
      getClientList(token);
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

  Future<Map<String, dynamic>> editClient(
    String servingClient,
    String clientId,
    String primaryContact,
    String primaryMobile,
    String primaryEmail,
    String secondaryContact,
    String secondaryMobile,
    String secondaryEmail,
    String fullAddress,
    String description,
    String showInputAddress,
    String clientStatus,
    String primaryCode,
    String secondaryCode,
    String token,
    String id,
  ) async {
    state = state.copyWith(error: null);
    try {
      final editConsultancyResponse = await apiService.editClient(
        servingClient,
        clientId,
        primaryContact,
        primaryMobile,
        primaryEmail,
        secondaryContact,
        secondaryMobile,
        secondaryEmail,
        fullAddress,
        description,
        showInputAddress,
        clientStatus,
        primaryCode,
        secondaryCode,
        token,
        id,
      );
      getClientList(token);
      return editConsultancyResponse;
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

  Future<Map<String, dynamic>> deleteClient(int id, String token) async {
    try {
      final response = await apiService.deleteClient(id, token);
      final bool status = response['status'] ?? false;

      if (status) {
        await getClientList(token); // Refresh list
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

  Future<Map<String, dynamic>> getUsers(String token) async {
    try {
      final response = await apiService.getUsers(token);
      final bool status = response['status'] ?? false;

      if (status) {
        print('consultantListres ${status}');
        state = state.copyWith(usersList: response['data'], isLoading: false);
        print('consultantList ${state.usersList}');
      } else {
        print('consultantListres ${status}');
        state = state.copyWith(
          usersList: response['data'],
          isLoading: false,
          error: response['message'] ?? 'Failed to fetch consultant',
        );
        print('consultantList ${state.usersList}');
      }

      return response;
    } catch (e) {
      final errorMsg = e.toString();
      print('consultantList ${errorMsg}');
      state = state.copyWith(isLoading: false, error: errorMsg);
      return {'status': false, 'message': errorMsg};
    }
  }

  Future<Map<String, dynamic>> addUser(
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
    String adminEmail,
    bool resetPassword,
    int userId,
    String designation,
    String userStatus,
    File consultantImage,
    String token,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final addUserResponse = await apiService.addUser(
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
        adminEmail,
        resetPassword,
        userId,
        designation,
        userStatus,
        consultantImage,
        token,
      );

      // Optionally reload user list
      getUsers(token);

      state = state.copyWith(isLoading: false);
      return addUserResponse;
    } catch (error) {
      print("error123 ${error.toString()}");
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
      return {
        "status": false,
        "message": error.toString(),
      };
    }
  }
}
