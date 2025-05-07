import 'dart:io';

import 'package:dio/dio.dart';
import 'package:harris_j_system/services/api_constant.dart';


class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstant.baseUrl,
    headers: {'Content-Type': 'application/json'},
  ));

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('login-data $email,$password');
      final response = await _dio.post(
        ApiConstant.login,
        data: {
          "email": "rohit@example.com",
          "password": "password"
        },
      );
      print('Response statusCode: ${response.statusCode}');
      print('Response data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      print('responseloginelse ${e.response}');
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }




  Future<Map<String, dynamic>> getConsultancy() async {
    try {
      final response = await _dio.get(
        ApiConstant.getConsultancy,

      );

      print('response $response');
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }


  Future<Map<String, dynamic>> fetchCountry()async{
    try {
      final response = await _dio.get(
        ApiConstant.countries,

      );

      print('response $response');
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }

  Future<Map<String, dynamic>> fetchState(String country)async{
    print(ApiConstant.countries+country);

    try {
      final response = await _dio.get(
        ApiConstant.states+country,

      );
      print('response $response');
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
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
      File consultancyImageFile, // Path to the image file
      ) async {
    try {
      FormData formData = FormData.fromMap({
        'consultancy_name': consultancyName,
        'consultancy_id': consultancyId,
        'uen_number': uenNumber,
        'full_address': fullAddress,
        'show_address_input': showAddressInput,
        'primary_contact': primaryContact,
        'primary_mobile': primaryMobile,
        'primary_email': primaryEmail,
        'secondary_contact': secondaryContact,
        'secondary_email': secondaryEmail,
        'secondary_mobile': secondaryMobile,
        'consultancy_type': consultancyType,
        'consultancy_status': consultancyStatus,
        'license_start_date': licenseStartDate,
        'license_end_date': licenseEndDate,
        'license_number': licenseNumber,
        'fees_structure': feesStructure,
        'last_paid_status': lastPaidStatus,
        'admin_email': adminEmail,
        'primary_mobile_country_code': primaryMobileCountryCode,
        'secondary_mobile_country_code': secondaryMobileCountryCode,
        'reset_password': resetPassword?1:0,
        'user_id': userId.toString(),
        'consultancy_image': await MultipartFile.fromFile(
          consultancyImageFile.path,
        ),
      });

      print('formData ${formData.fields},${formData.files}');
      print('ApiConstant ${ ApiConstant.addConsultancy}');

      final response = await _dio.post(
        ApiConstant.addConsultancy,
        data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
              // Add auth or other headers if needed
            },),
      );
print('addConsultancyresponse $response');
      return response.data;
    }  on DioException catch (e) {
      print('the uh ${e.response}');
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        print('error resif ${e.response?.data['message']}');
        throw Exception(e.response?.data['message'] ?? 'An error occurred');
      } else {
        print('error reselse ');
        throw Exception('No response from server');
      }
    } catch (e) {
      print('error rescatch ${e.toString()}');
      throw Exception(e.toString());
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
      File consultancyImageFile, // Path to the image file
      ) async {
    try {
      FormData formData = FormData.fromMap({
        'consultancy_name': consultancyName,
        'consultancy_id': consultancyId,
        'uen_number': uenNumber,
        'full_address': fullAddress,
        'show_address_input': showAddressInput,
        'primary_contact': primaryContact,
        'primary_mobile': primaryMobile,
        'primary_email': primaryEmail,
        'secondary_contact': secondaryContact,
        'secondary_email': secondaryEmail,
        'secondary_mobile': secondaryMobile,
        'consultancy_type': consultancyType,
        'consultancy_status': consultancyStatus,
        'license_start_date': licenseStartDate,
        'license_end_date': licenseEndDate,
        'license_number': licenseNumber,
        'fees_structure': feesStructure,
        'last_paid_status': lastPaidStatus,
        'admin_email': adminEmail,
        'primary_mobile_country_code': primaryMobileCountryCode,
        'secondary_mobile_country_code': secondaryMobileCountryCode,
        'reset_password': resetPassword?1:0,
        'user_id': userId.toString(),
        'consultancy_image': await MultipartFile.fromFile(
          consultancyImageFile.path,
        ),
      });

      print('formData ${formData.fields},${formData.files}');
      print('ApiConstant ${ ApiConstant.updateConsultancy}');

      final response = await _dio.post(
        '${ApiConstant.updateConsultancy}/$id',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            // Add auth or other headers if needed
          },),
      );
      print('updateConsultancyresponse $response');
      return response.data;
    }  on DioException catch (e) {
      print('the uh ${e.response}');
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        print('error resif ${e.response?.data['message']}');
        throw Exception(e.response?.data['message'] ?? 'An error occurred');
      } else {
        print('error reselse ');
        throw Exception('No response from server');
      }
    } catch (e) {
      print('error rescatch ${e.toString()}');
      throw Exception(e.toString());
    }

  }

  Future<Map<String, dynamic>> deleteConsultancy(int id) async {
    try {
      print('deleteId $id');
      final response = await _dio.delete('${ApiConstant.deleteConsultancy}/$id');
      print('response-delete $response');
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }

}
