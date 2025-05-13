import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harris_j_system/services/api_service.dart';

final consultantProvider =
StateNotifierProvider<GetConsultantNotifier, GetConsultantState>((ref) {
  return GetConsultantNotifier(ApiService());
});

class GetConsultantState {
  final bool isLoading;
  final String? error;
  final List<Map<String, dynamic>>? consultancyList;

  GetConsultantState({
    this.isLoading = false,
    this.error,
    this.consultancyList,
  });

  GetConsultantState copyWith({
    bool? isLoading,
    String? error,
    List<Map<String, dynamic>>? consultancyList,
  }) {
    return GetConsultantState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      consultancyList: consultancyList ?? this.consultancyList,
    );
  }
}

class GetConsultantNotifier extends StateNotifier<GetConsultantState> {
  final ApiService apiService;

  GetConsultantNotifier(this.apiService) : super(GetConsultantState());


  Future<Map<String, dynamic>> updateBasicInfo(
  String firstName,String middleName,String lastName,String dob,String selectedCitizen,String selectedNationality,String address,String mobileNumber,File selectedImage,File selectedResume, String token,) async
  {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // print(
      //     "updatebasic $consultancyName,$consultancyId,$uenNumber,$fullAddress,$showAddressInput,$primaryContact,$primaryMobile,$primaryEmail,$secondaryContact,$secondaryEmail,$secondaryMobile,$consultancyType,$consultancyStatus,$licenseStartDate,$licenseEndDate,$licenseNumber,$feesStructure,$lastPaidStatus,$adminEmail,$primaryMobileCountryCode,$secondaryMobileCountryCode,$userId,$resetPassword,$consultancyImage");
      final basicInfoResponse = await apiService.updateBasicInfo(
      firstName,middleName,lastName,dob,selectedCitizen,selectedNationality,address,mobileNumber,selectedImage,selectedResume,'');


  state = state.copyWith(isLoading: false);
      return basicInfoResponse;
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


}
