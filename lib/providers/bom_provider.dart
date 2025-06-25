import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harris_j_system/services/api_service.dart';

final bomProvider =
    StateNotifierProvider<GetBomNotifier, GetBomState>((ref) {
  return GetBomNotifier(ApiService());
});

class GetBomState {
  final bool isLoading;
  final String? error;
  final List<Map<String, dynamic>>? consultancyList;

  GetBomState({
    this.isLoading = false,
    this.error,
    this.consultancyList,
  });

  GetBomState copyWith({
    bool? isLoading,
    String? error,
    List<Map<String, dynamic>>? consultancyList,
  }) {
    return GetBomState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      consultancyList: consultancyList ?? this.consultancyList,
    );
  }
}

class GetBomNotifier extends StateNotifier<GetBomState> {
  final ApiService apiService;

  GetBomNotifier(this.apiService) : super(GetBomState());

  Future<void> fetchConsultancy(String token) async {
    state = state.copyWith(isLoading: true, error: null);
    print('vghgj');

    try {
      final response = await apiService.getConsultancy(token);

      final bool status = response['status'] ?? false;
      if (status) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(response['data'] ?? []);
        state = state.copyWith(isLoading: false, consultancyList: data);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response['message'] ?? 'Unknown error',
        );
      }
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    }
  }

  Future<Map<String, dynamic>> addConsultancy(
      String consultancyName,
      String consultancyId,
      String uenNumber,
      String fullAddress,
      String showAddressInput,
      String primaryContact,
      String primaryMobile,
      String primaryEmail,
      String secondaryContact,
      String secondaryEmail,
      String secondaryMobile,
      String consultancyType,
      String consultancyStatus,
      String licenseStartDate,
      String licenseEndDate,
      String licenseNumber,
      String feesStructure,
      String lastPaidStatus,
      String adminEmail,
      String primaryMobileCountryCode,
      String secondaryMobileCountryCode,
      bool resetPassword,
      int userId,
      File consultancyImage,
      String token,
      ) async
  {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print(
          "add-consultancy $consultancyName,$consultancyId,$uenNumber,$fullAddress,$showAddressInput,$primaryContact,$primaryMobile,$primaryEmail,$secondaryContact,$secondaryEmail,$secondaryMobile,$consultancyType,$consultancyStatus,$licenseStartDate,$licenseEndDate,$licenseNumber,$feesStructure,$lastPaidStatus,$adminEmail,$primaryMobileCountryCode,$secondaryMobileCountryCode,$userId,$resetPassword,$consultancyImage");
      final addConsultancyResponse = await apiService.addConsultancy(
          consultancyName,
          consultancyId,
          uenNumber,
          fullAddress,
          showAddressInput,
          primaryContact,
          primaryMobile,
          primaryEmail,
          secondaryContact,
          secondaryMobile,
          secondaryEmail,
          consultancyType,
          consultancyStatus,
          licenseStartDate,
          licenseEndDate,
          licenseNumber,
          feesStructure,
          lastPaidStatus,
          adminEmail,
          primaryMobileCountryCode,
          secondaryMobileCountryCode,
          resetPassword,
          userId,
          consultancyImage,
      token,
      );

      state = state.copyWith(isLoading: false);
      return addConsultancyResponse;
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

  Future<Map<String, dynamic>> editConsultancy(
      int id,
      String consultancyName,
      String consultancyId,
      String uenNumber,
      String fullAddress,
      String showAddressInput,
      String primaryContact,
      String primaryMobile,
      String primaryEmail,
      String secondaryContact,
      String secondaryEmail,
      String secondaryMobile,
      String consultancyType,
      String consultancyStatus,
      String licenseStartDate,
      String licenseEndDate,
      String licenseNumber,
      String feesStructure,
      String lastPaidStatus,
      String adminEmail,
      String primaryMobileCountryCode,
      String secondaryMobileCountryCode,
      bool resetPassword,
      int userId,
      File consultancyImage,
      String token,
      ) async
  {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print(
          "edit-consultancy$id, $consultancyName,$consultancyId,$uenNumber,$fullAddress,$showAddressInput,$primaryContact,$primaryMobile,$primaryEmail,$secondaryContact,$secondaryEmail,$secondaryMobile,$consultancyType,$consultancyStatus,$licenseStartDate,$licenseEndDate,$licenseNumber,$feesStructure,$lastPaidStatus,$adminEmail,$primaryMobileCountryCode,$secondaryMobileCountryCode,$userId,$resetPassword,$consultancyImage");
      final editConsultancyResponse = await apiService.editConsultancy(
        id,
          consultancyName,
          consultancyId,
          uenNumber,
          fullAddress,
          showAddressInput,
          primaryContact,
          primaryMobile,
          primaryEmail,
          secondaryContact,
          secondaryMobile,
          secondaryEmail,
          consultancyType,
          consultancyStatus,
          licenseStartDate,
          licenseEndDate,
          licenseNumber,
          feesStructure,
          lastPaidStatus,
          adminEmail,
          primaryMobileCountryCode,
          secondaryMobileCountryCode,
          resetPassword,
          userId,
          consultancyImage,token);

      // if (editConsultancyResponse['status']) {
        await fetchConsultancy(token); // Refresh list
        state = state.copyWith(isLoading: false);
        return editConsultancyResponse;
      // }


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

  Future<Map<String, dynamic>> deleteConsultancy(int id,String token) async {
    try {
      final response = await apiService.deleteConsultancy(id,token);
      final bool status = response['status'] ?? false;

      if (status) {
        await fetchConsultancy(token); // Refresh list
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


}
