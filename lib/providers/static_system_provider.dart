import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harris_j_system/services/api_service.dart';

final staticSettingProvider =
    StateNotifierProvider<StaticSettingNotifier, StaticSettingState>((ref) {
  return StaticSettingNotifier(ApiService());
});

class StaticSettingState {
  final bool isLoading;
  final List<dynamic>? roleList;
  final List<dynamic>? designationList;
  final List<dynamic>? lookupList;
  final String? error;

  StaticSettingState({
    this.isLoading = false,
    this.roleList,
    this.designationList,
    this.lookupList,
    this.error,
  });

  StaticSettingState copyWith({
    bool? isLoading,
    final List<dynamic>? roleList,
    final List<dynamic>? designationList,
    final List<dynamic>? lookupList,
    String? error,
  }) {
    return StaticSettingState(
      isLoading: isLoading ?? this.isLoading,
      roleList: roleList ?? this.roleList,
      designationList: designationList ?? this.designationList,
      lookupList: lookupList ?? this.lookupList,
      error: error,
    );
  }
}

class StaticSettingNotifier extends StateNotifier<StaticSettingState> {
  final ApiService apiService;

  StaticSettingNotifier(this.apiService) : super(StaticSettingState());

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<Map<String, dynamic>> addLookup(
      String consultancyId,
      String propertyName,
      String propertyDescription,
      bool status,
      String hexColor,
      List lookupOptions,
      String token,
      String id,
      String index,
      ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final addLookupResponse = await apiService.addLookUp(
        consultancyId,
        propertyName,
        propertyDescription,
        status,
        hexColor,
        lookupOptions,
        token,
        id,
        index,
      );
      state = state.copyWith(isLoading: false);
      getSystemProperty(consultancyId,token);
      return addLookupResponse;
    } catch (error) {
      print("error123 ${error.toString()}");
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
      return {
        "success": false,
        "message": error.toString()
        // Add other default values as per your model
      };
    }
  }

  Future<Map<String, dynamic>> addRoleDesignation(String endPoint,
      String consultancyId, String name, String tag, String token) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final isDesignation = endPoint == 'consultancy-designation/save';
      final addRoleResponse = await apiService.addRoleDesignation(
        endPoint,
        consultancyId,
        name,
        tag,
        token,
      );
      state = state.copyWith(isLoading: false);
      isDesignation?getDesignation(consultancyId, token):getRole(consultancyId, token);
      return addRoleResponse;
    } catch (error) {
      print("error123 ${error}");
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
      return {
        "success": false,
        "message": error.toString()
        // Add other default values as per your model
      };
    }
  }

  Future<Map<String, dynamic>> getDesignation(
      String userId, String token) async
  {
    state = state.copyWith(error: null);
    try {
      final addDesignationResponse = await apiService.getDesignation(
        userId,
        token,
      );
      final data = addDesignationResponse['data'] as List;

      print('addDesignationResponse $data');

      state = state.copyWith(
        designationList: data,
        isLoading: false,
      );
      print('addDesignationResponsestate ${state.designationList}');
      return addDesignationResponse;
    } catch (error) {
      print("error123 ${error}");
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
      return {
        "success": false,
        "message": error.toString()
        // Add other default values as per your model
      };
    }
  }

  Future<Map<String, dynamic>> getRole(String userId, String token) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final addRoleResponse = await apiService.getRole(
        userId,
        token,
      );
      state =
          state.copyWith(isLoading: false, roleList: addRoleResponse['data']);
      return addRoleResponse;
    } catch (error) {
      print("error123 ${error}");
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
      return {
        "success": false,
        "message": error.toString()
        // Add other default values as per your model
      };
    }
  }

  Future<Map<String, dynamic>> getSystemProperty(String userId, String token) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final addLookupResponse = await apiService.getSystemPropertyList(
        userId,
        token,
      );
      state =
          state.copyWith(isLoading: false, lookupList: addLookupResponse['data']);
      print('lookupList ${state.lookupList}');

      return addLookupResponse;
    } catch (error) {
      print("error123 ${error}");
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
      return {
        "success": false,
        "message": error.toString()
        // Add other default values as per your model
      };
    }
  }
}
