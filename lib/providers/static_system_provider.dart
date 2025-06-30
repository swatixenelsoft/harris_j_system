import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harris_j_system/services/api_service.dart';

final staticSettingProvider =
StateNotifierProvider<StaticSettingNotifier, StaticSettingState>((ref) {
  return StaticSettingNotifier(ApiService());
});

class StaticSettingState {
  final bool isLoading;
  final String? error;


  StaticSettingState({
    this.isLoading = false,
    this.error,

  });

  StaticSettingState copyWith({
    bool? isLoading,
    String? error,

  }) {
    return StaticSettingState(
      isLoading: isLoading ?? this.isLoading,
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
      String token
      ) async
  {
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
      );
      state = state.copyWith(isLoading: false);
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


  Future<Map<String, dynamic>> addRole(
      String endPoint,
      String consultancyId,
      String name,
      String tag,
      String token
      ) async
  {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final addRoleResponse = await apiService.addRole(
        endPoint,
        consultancyId,
        name,
        tag,
        token,
      );
      state = state.copyWith(isLoading: false);
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
}
