import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:harris_j_system/services/api_constant.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstant.baseUrl,
  ));

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('login-data $email,$password');
      final response = await _dio.post(
        ApiConstant.login,
        data: {"email": email, "password": "password"},
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

  Future<Map<String, dynamic>> getConsultancy(String token) async {
    print('token $token');
    try {
      final response = await _dio.get(
        ApiConstant.getConsultancy,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
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

  Future<Map<String, dynamic>> fetchCountry(String token) async {
    try {
      final response = await _dio.get(
        ApiConstant.countries,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
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

  Future<Map<String, dynamic>> fetchState(String country, String token) async {
    print(ApiConstant.countries + country);

    try {
      final response = await _dio.get(
        ApiConstant.states + country,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
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
    File consultancyImageFile,
    String token, // Path to the image file
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
        'reset_password': resetPassword ? 1 : 0,
        'user_id': userId.toString(),
        'consultancy_image': await MultipartFile.fromFile(
          consultancyImageFile.path,
        ),
      });

      print('formData ${formData.fields},${formData.files}');
      print('ApiConstant ${ApiConstant.addConsultancy}');

      final response = await _dio.post(
        ApiConstant.addConsultancy,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );
      print('addConsultancyresponse $response');
      return response.data;
    } on DioException catch (e) {
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
    File consultancyImageFile,
    String token, // Path to the image file
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
        'reset_password': resetPassword ? 1 : 0,
        'user_id': userId.toString(),
        'consultancy_image': await MultipartFile.fromFile(
          consultancyImageFile.path,
        ),
      });

      print('formData ${formData.fields},${formData.files}');
      print('ApiConstant ${ApiConstant.updateConsultancy}');

      final response = await _dio.post(
        '${ApiConstant.updateConsultancy}/$id',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );
      print('updateConsultancyresponse $response');
      return response.data;
    } on DioException catch (e) {
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

  Future<Map<String, dynamic>> deleteConsultancy(int id, String token) async {
    try {
      print('deleteId $id');
      final response = await _dio.delete(
        '${ApiConstant.deleteConsultancy}/$id',
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );
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
    String token, // Path to the image file
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'user_id': '',
        'first_name': firstName,
        'middle_name': middleName,
        'last_name': lastName,
        'dob': dob,
        'citizen': selectedCitizen,
        'nationality': selectedNationality,
        'address_by_user': address,
        'mobile_number': mobileNumber,
        'profile_image': await MultipartFile.fromFile(
          selectedImage.path,
        ),
        'resume_file': await MultipartFile.fromFile(
          selectedResume.path,
        ),
      });

      print('formData ${formData.fields},${formData.files}');
      print('ApiConstant ${ApiConstant.updateBasicInfo}');

      final response = await _dio.post(
        ApiConstant.updateBasicInfo,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );
      print('addConsultancyresponse $response');
      return response.data;
    } on DioException catch (e) {
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

//consultant Api
  Future<Map<String, dynamic>> consultantTimesheet(
      String token, String month, String year) async
  {
    try {
      FormData formData = FormData.fromMap({
        'month': month,
        'year': year,
      });
      // print('formData ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.consultantTimeSheet,
        data: formData,
        options: Options(
          headers: {
            // 'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      log('Response data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      print('Request URL: ${e.response!.realUri}');
      print('responsetimesheetelse ${e.response!.statusCode}');
      print('responsetimesheetelse ${e.response!.data}');
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }

  Future<Map<String, dynamic>> consultantClaimSheet(
      String token) async
  {
    try {

      // print('formData ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.consultantClaimSheet,
        options: Options(
          headers: {
            // 'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      log('Response data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      print('Request URL: ${e.response!.realUri}');
      print('responsetimesheetelse ${e.response!.statusCode}');
      print('responsetimesheetelse ${e.response!.data}');
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }

  Future<Map<String, dynamic>> consultantLeaveWorkLog(
      String token, String month, String year) async
  {
    try {
      FormData formData = FormData.fromMap({
        'month': month,
        'year': year,
      });
      // print('formData ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.getLeaveWorkLog,
        data: formData,
        options: Options(
          headers: {
            // 'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      log('Response11 data: ${jsonEncode(response.data)}');

      return response.data;
    } on DioException catch (e) {
      print('Request URL: ${e.response!.realUri}');
      print('responsetimesheetelse ${e.response!.statusCode}');
      print('responsetimesheetelse ${e.response!.data}');
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }

  Future<Map<String, dynamic>> consultantTimesheetRemark(
      String token, String month, String year) async
  {
    try {
      FormData formData = FormData.fromMap({
        'month': month,
        'year': year,
      });
      // print('formData ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.getTimesheetRemarks,
        data: formData,
        options: Options(
          headers: {
            // 'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      log('Response22 data: ${jsonEncode(response.data)}');

      return response.data;
    } on DioException catch (e) {
      print('Request URL: ${e.response!.realUri}');
      print('responsetimesheetelse ${e.response!.statusCode}');
      print('responsetimesheetelse ${e.response!.data}');
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }


  Future<Map<String, dynamic>> fetchDashboardData(String token) async {

    try {
      final response = await _dio.get(
        ApiConstant.getDashboard,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token'},
        ),
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

  Future<Map<String, dynamic>> addFeedBack(
    String token,
    int userId,
    String feedback,
  ) async
  {
    try {
      FormData formData = FormData.fromMap({
        'user_id': userId,
        'message': feedback,
      });
      print('formData $token');
      final response = await _dio.post(
        ApiConstant.feedback,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      print('Response data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      print('Request URL: ${e.response!.realUri}');
      print('responsetimesheetelse ${e.response!.statusCode}');
      print('responsetimesheetelse ${e.response!.data}');
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }


  Future<Map<String, dynamic>> addTimeSheetData(
      String token,
      String userId,
      String type,
      String clientId,
      String clientName,
      String status,
      List<Map<String, dynamic>> record,
      String corporateEmail,
      String reportingManagerEmail,
      String selectMonth,
      String selectYear,
      dynamic certificate,
      ) async
  {
    print('certificate $certificate $corporateEmail,$reportingManagerEmail,$selectMonth,$selectYear');

    final Map<String, dynamic> formMap = {
      'type': type,
      'user_id': userId,
      'client_id': clientId,
      'client_name': clientName,
      'status': status,
      'record': jsonEncode(record),
    };
    if(corporateEmail.isNotEmpty && reportingManagerEmail.isNotEmpty&& selectMonth.isNotEmpty&& selectYear.isNotEmpty){
      formMap['corporate_email'] =corporateEmail;
      formMap['reporting_manager_email'] =reportingManagerEmail;
      formMap['selectedMonth'] =selectMonth;
      formMap['selectedYear'] =selectYear;
    }

    if (certificate != null && certificate is PlatformFile) {
      formMap['certificate'] = await MultipartFile.fromFile(
        certificate.path!,
        filename: certificate.name,
      );
    }

    for (final entry in formMap.entries) {
      if (entry.value is MultipartFile) {
        print('${entry.key}: [File] ${certificate.name}');
      } else {
        print('${entry.key}: ${entry.value}');
      }
    }

    try {
      FormData formData = FormData.fromMap(formMap);


      log('formData ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.addTimesheetData,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      print('Response data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      print('Request URL: ${e.response?.realUri}');
      print('responsetimesheetelse ${e.response?.statusCode}');
      print('responsetimesheetelse ${e.response?.data}');
      return e.response?.data ?? {'error': 'No response from server'};
    }
  }

}
