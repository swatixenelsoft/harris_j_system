import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harris_j_system/services/api_service.dart';

final staticSettingProvider =
    StateNotifierProvider<StaticSettingNotifier, StaticSettingState>((ref) {
  return StaticSettingNotifier(ApiService());
});

class StaticSettingState {
  final List<dynamic>? holidayList;
  final bool isLoading;
  final List<dynamic>? roleList;
  final List<dynamic>? designationList;
  final List<dynamic>? lookupList;
  final String? error;

  StaticSettingState({
    this.holidayList,
    this.isLoading = false,
    this.roleList,
    this.designationList,
    this.lookupList,
    this.error,
  });

  StaticSettingState copyWith({
    List<dynamic>? holidayList,
    bool? isLoading,
    final List<dynamic>? roleList,
    final List<dynamic>? designationList,
    final List<dynamic>? lookupList,
    String? error,
  }) {
    return StaticSettingState(
      holidayList: holidayList ?? this.holidayList,
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
      getSystemProperty(consultancyId, token);
      return addLookupResponse;
    } catch (error) {
      print("addLookup error: $error");
      state = state.copyWith(isLoading: false, error: error.toString());
      return {
        "success": false,
        "message": error.toString(),
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
      isDesignation
          ? getDesignation(consultancyId, token)
          : getRole(consultancyId, token);
      return addRoleResponse;
    } catch (error) {
      print("addRole error: $error");
      state = state.copyWith(isLoading: false, error: error.toString());
      return {
        "success": false,
        "message": error.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getDesignation(
      String userId, String token) async {
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

  Future<Map<String, dynamic>> getSystemProperty(
      String userId, String token) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final addLookupResponse = await apiService.getSystemPropertyList(
        userId,
        token,
      );
      state = state.copyWith(
          isLoading: false, lookupList: addLookupResponse['data']);
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

  Future<Map<String, dynamic>> createHoliday({
    required String consultancyId,
    required String holidayProfileName,
    required String holidayProfileDate,
    required int daysCount,
    required String validUpto,
    required int holidayProfileStatus,
    required String childHolidayName,
    required String childHolidayDate,
    required int childHolidayDayCount,
    required String childHolidayValidUpto,
    required int childHolidayStatus,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiService.createHoliday(
        consultancyId: consultancyId,
        holidayProfileName: holidayProfileName,
        holidayProfileDate: holidayProfileDate,
        daysCount: daysCount,
        validUpto: validUpto,
        holidayProfileStatus: holidayProfileStatus,
        childHolidayName: childHolidayName,
        childHolidayDate: childHolidayDate,
        childHolidayDayCount: childHolidayDayCount,
        childHolidayValidUpto: childHolidayValidUpto,
        childHolidayStatus: childHolidayStatus,
        token: token,
      );

      state = state.copyWith(isLoading: false);
      return response;
    } catch (error) {
      print("createHoliday error: ${error.toString()}");
      state = state.copyWith(isLoading: false, error: error.toString());
      return {
        "success": false,
        "message": error.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> addHoliday({
    required String consultancyId,
    required String holidayProfileName,
    required String holidayProfileDate,
    required int daysCount,
    required String validUpto,
    required int holidayProfileStatus,
    required String parentId,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiService.addHoliday(
        consultancyId: consultancyId,
        holidayProfileName: holidayProfileName,
        holidayProfileDate: holidayProfileDate,
        daysCount: daysCount,
        validUpto: validUpto,
        holidayProfileStatus: holidayProfileStatus,
        parentId: parentId,
        token: token,
      );

      state = state.copyWith(isLoading: false);
      return response;
    } catch (error) {
      print("addHoliday error: ${error.toString()}");
      state = state.copyWith(isLoading: false, error: error.toString());
      return {
        "success": false,
        "message": error.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> editHoliday({
    required String holidayProfileName,
    required String holidayProfileDate,
    required int daysCount,
    required String validUpto,
    required int holidayProfileStatus,
    required String id,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiService.editHoliday(
        holidayProfileName: holidayProfileName,
        holidayProfileDate: holidayProfileDate,
        daysCount: daysCount,
        validUpto: validUpto,
        holidayProfileStatus: holidayProfileStatus,
        id: id,
        token: token,
      );
      state = state.copyWith(isLoading: false);
      return response;
    } catch (error) {
      print("editHoliday error: ${error.toString()}");
      state = state.copyWith(isLoading: false, error: error.toString());
      return {
        "success": false,
        "message": error.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> getHolidayList(
      {required String userId, required String token}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await apiService.getHolidayList(userId, token);
      print('response $response');
      state = state.copyWith(holidayList: response['data']);
      return response;
    } catch (error) {
      print("getHolidayList error: ${error.toString()}");
      state = state.copyWith(isLoading: false, error: error.toString());
      return {
        "success": false,
        "message": error.toString(),
      };
    }
  }
}
