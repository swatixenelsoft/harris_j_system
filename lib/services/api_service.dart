import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:harris_j_system/providers/static_system_provider.dart';
import 'package:harris_j_system/services/api_constant.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstant.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('login-data $email,$password');
      final response = await _dio.post(
        ApiConstant.login,
        data: {"email": email, "password": password},
      );
      print('Response statusCode: ${response.statusCode}');
      print('Response data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      print('Response statusCode else: ${e}');
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

  Future<Map<String, dynamic>> fetchBomDashboard(String token) async {
    try {
      final response = await _dio.post(
        ApiConstant.bomDashboard,
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
            'Content-Type': 'application/json',
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

  Future<Map<String, dynamic>> getBasicInfo(String token) async {
    print('token $token');
    try {
      final response = await _dio.post(
        ApiConstant.getBasic,
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
      String token, String month, String year) async {
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

  Future<Map<String, dynamic>> consultantClaimSheet(String token) async {
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
      String token, String month, String year) async {
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

  Future<Map<String, dynamic>> consultantClaimAndCopy(
      String token, String month, String year) async {
    try {
      FormData formData = FormData.fromMap({
        'month': month,
        'year': year,
      });
      // print('formData ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.getClaimAndCopies,
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
      String url, String token, String month, String year) async {
    try {
      FormData formData = FormData.fromMap({
        'month': month,
        'year': year,
      });
      print('formData ${formData.fields}');
      final response = await _dio.post(
        url,
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

      print('remakr Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      log('remakr Response22 data: ${jsonEncode(response.data)}');

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

  Future<Map<String, dynamic>> backDatedClaims(
      String userId, String month, String year, String token) async {
    try {
      FormData formData = FormData.fromMap({
        'user_id': userId,
        'month': month,
        'year': year,
      });
      print('formDatabackdate $token,${formData.fields}');

      final response = await _dio.post(
        ApiConstant.backdatedClaimsData,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('eroro msg $e');
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

  Future<Map<String, dynamic>> addFeedBack(
    String token,
    int userId,
    String feedback,
  ) async {
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
    List<dynamic> record,
    String corporateEmail,
    String reportingManagerEmail,
    String selectMonth,
    String selectYear,
    dynamic certificate,
  ) async {
    print(
        'certificate111 $certificate $corporateEmail,$reportingManagerEmail,$selectMonth,$selectYear');

    final Map<String, dynamic> formMap = {
      'type': type,
      'user_id': userId,
      'client_id': clientId,
      'client_name': clientName,
      'status': status,
      'record': jsonEncode(record),
    };
    if (corporateEmail.isNotEmpty &&
        reportingManagerEmail.isNotEmpty &&
        selectMonth.isNotEmpty &&
        selectYear.isNotEmpty) {
      formMap['corporate_email'] = corporateEmail;
      formMap['reporting_manager_email'] = reportingManagerEmail;
      formMap['selectedMonth'] = selectMonth;
      formMap['selectedYear'] = selectYear;
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

  Future<Map<String, dynamic>> addClaimData(
    String token,
    String userId,
    String type,
    String clientId,
    String clientName,
    String status,
    Map<String, dynamic> record,
    String corporateEmail,
    String reportingManagerEmail,
    String selectMonth,
    String selectYear,
    dynamic certificate,
    String claimId,
  ) async {
    print(
        'certificate $certificate $corporateEmail,$reportingManagerEmail,$selectMonth,$selectYear');

    final Map<String, dynamic> formMap = {
      'type': type,
      'user_id': userId,
      'client_id': clientId,
      'client_name': clientName,
      'status': status,
      'record': jsonEncode(record),
    };
    if (corporateEmail.isNotEmpty &&
        reportingManagerEmail.isNotEmpty &&
        selectMonth.isNotEmpty &&
        selectYear.isNotEmpty) {
      formMap['corporate_email'] = corporateEmail;
      formMap['reporting_manager_email'] = reportingManagerEmail;
      formMap['selectedMonth'] = selectMonth;
      formMap['selectedYear'] = selectYear;
    }

    if (certificate != null && certificate is PlatformFile) {
      formMap['certificate'] = await MultipartFile.fromFile(
        certificate.path!,
        filename: certificate.name,
      );
    }
    if (claimId.isNotEmpty) {
      formMap['edit_id'] = claimId;
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
        ApiConstant.addClaimsData,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      print('claim Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      print('claim Response data: ${response.data}');

      return response.data;
    } on DioException catch (e) {
      print('Request URL: ${e.response?.realUri}');
      print('responsetimesheetelse ${e.response?.statusCode}');
      print('responsetimesheetelse ${e.response?.data}');
      return e.response?.data ?? {'error': 'No response from server'};
    }
  }

  Future<Map<String, dynamic>> deleteClaims(int id, String token) async {
    try {
      print('deleteId $id');
      final response = await _dio.post(
        '${ApiConstant.deleteClaim}/$id',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
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

  Future<Map<String, dynamic>> addConsultant(
      String employeeName,
      String employeeMiddleName,
      String employeeLastName,
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
      String operatorEmailId,
      String salary,
      String bonus,
      String contractRenewal,
      String contractRenewalDate,
      String clientCountry,
      String clientAddress,
      String annualLeaveCount,
      String medicalLeaveCount,
      String paidDayOffCount,
      String compOffCount,
      String unpaidCount,
      ) async {
    try {
      FormData formData = FormData.fromMap({
        'emp_name': employeeName,
        'emp_code': employeeCode,
        'sex': gender,
        'full_address': fullAddress,
        'show_address_input': showInputAddress,
        'dob': dob,
        'mobile_number_code': countryCode,
        'mobile_number': primaryMobile,
        'email': primaryEmail,
        'joining_date': joiningDate,
        'resignation_date': endDate,
        'status': 'Active',
        'select_holiday': holidayProfile,
        'designation': designation,
        'residential_status': residential,
        'contract_period': contractPeriod,
        'billing_amount': billingAmount,
        'working_hours': workingHours,
        'login_email': adminEmail,
        'reset_password': resetPassword ? 1 : 0,
        'client_id': client.toString(),
        'profile_image': await MultipartFile.fromFile(
          consultantImage.path,
        ),
      });

      print('formData ${formData.fields},${formData.files}');
      print('ApiConstant ${ApiConstant.addConsultant}');

      final response = await _dio.post(
        ApiConstant.addConsultant,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );
      print('addConsultancyresponse,${response.statusCode} $response');
      return response.data;
    } on DioException catch (e) {
      print('the uh,${e.response!.statusCode}, ${e.response}');
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

  Future<Map<String, dynamic>> getClientList(
    String token,
  ) async
  {
    try {
      print('formData $token');
      final response = await _dio.post(
        ApiConstant.clientList,
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

  Future<Map<String, dynamic>> getDashBoardByClient(
    String clientId,
    String token,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'client_id': clientId,
      });
      print('formData $token, ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.hrDashBoard,
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

  Future<Map<String, dynamic>> getConsultantTimesheetByClient(
    String clientId,
    String month,
    String year,
    String token,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'client_id': clientId,
        'month': month,
        'year': year,
      });
      print('formData $token, ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.consultantTimesheetListHrTab,
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
      log('Response datatime: ${jsonEncode(response.data)}');

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

  Future<Map<String, dynamic>> getConsultantClaimsByClient(
    String clientId,
    String month,
    String year,
    String token,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'client_id': clientId,
        'month': month,
        'year': year,
      });
      print('formData $token, ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.consultantClaimsListHrTab,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri},$month,$year');
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

  Future<Map<String, dynamic>> getConsultantByClient(
    String clientId,
    String token,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'client_id': clientId,
      });
      print('formData $token, ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.consultantList,
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

  Future<Map<String, dynamic>> deleteConsultant(int id, String token) async {
    try {
      FormData formData = FormData.fromMap({
        'consultant_id': id,
      });
      print('formData $token, ${formData.fields}');
      print('deleteId $id');
      final response = await _dio.post(
        ApiConstant.deleteConsultant,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
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

  //Consultancy
  Future<Map<String, dynamic>> getClient(String token) async {
    print('token $token');
    try {
      final response = await _dio.get(
        ApiConstant.getClients,
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
    try {
      FormData formData = FormData.fromMap({
        'serving_client': servingClient,
        'client_id': clientId,
        'primary_contact': primaryContact,
        'primary_mobile': primaryMobile,
        'primary_email': primaryEmail,
        'secondary_contact': secondaryContact,
        'secondary_mobile': secondaryMobile,
        'secondary_email': secondaryEmail,
        'full_address': fullAddress,
        'description': description,
        'show_address_input': showInputAddress,
        'client_status': clientStatus,
        'primary_mobile_country_code': primaryCode,
        'secondary_mobile_country_code': secondaryCode,
      });

      print('formData ${formData.fields}');
      print('ApiConstant ${ApiConstant.addClient}');

      final response = await _dio.post(
        ApiConstant.addClient,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );
      print('addConsultancyresponse,${response.statusCode} $response');
      return response.data;
    } on DioException catch (e) {
      print('the uh,${e.response!.statusCode}, ${e.response}');
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
    try {
      FormData formData = FormData.fromMap({
        'serving_client': servingClient,
        'client_id': clientId,
        'primary_contact': primaryContact,
        'primary_mobile': primaryMobile,
        'primary_email': primaryEmail,
        'secondary_contact': secondaryContact,
        'secondary_mobile': secondaryMobile,
        'secondary_email': secondaryEmail,
        'full_address': fullAddress,
        'description': description,
        'show_address_input': showInputAddress,
        'client_status': clientStatus,
        'primary_mobile_country_code': primaryCode,
        'secondary_mobile_country_code': secondaryCode,
        'id': id
      });

      print('formData ${formData.fields}');
      print('ApiConstant ${ApiConstant.updateClient}');

      final response = await _dio.post(
        ApiConstant.updateClient,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );
      print('addConsultancyresponse,${response.statusCode} $response');
      return response.data;
    } on DioException catch (e) {
      print('the uh,${e.response!.statusCode}, ${e.response}');
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

  Future<Map<String, dynamic>> deleteClient(int id, String token) async {
    try {
      FormData formData = FormData.fromMap({
        'id': id,
      });
      print('formData $token, ${formData.fields}');
      print('deleteId $id');
      final response = await _dio.post(
        ApiConstant.deleteClient,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
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

  Future<Map<String, dynamic>> getUsers(String token) async {
    print('token $token');
    try {
      final response = await _dio.get(
        ApiConstant.getUsers,
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
    try {
      FormData formData = FormData.fromMap({
        'emp_name': employeeName,
        'emp_code': employeeCode,
        'sex': gender,
        'full_address': fullAddress,
        'show_address_input': showInputAddress,
        'dob': dob,
        // 'age': age,
        'mobile_number_code': countryCode,
        'mobile_number': primaryMobile,
        'email': primaryEmail,
        'status': userStatus,
        'designation': designation,
        'login_email': adminEmail,
        'reset_password': resetPassword ? 1 : 0,
        'user_id': userId.toString(),
        'receipt_file': await MultipartFile.fromFile(consultantImage.path),
        'joining_date': '',
        'resignation_date': '',
      });

      print('formData: ${formData.fields}, ${formData.files}');
      print('Endpoint: ${ApiConstant.addUser}');

      final response = await _dio.post(
        ApiConstant.addUser,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Response [${response.statusCode}]: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('Dio error: ${e.response?.statusCode}, ${e.response}');
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        throw Exception(e.response?.data['message'] ?? 'An error occurred');
      } else {
        throw Exception('No response from server');
      }
    } catch (e) {
      print('Unexpected error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> editUser(
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
    String id,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'emp_name': employeeName,
        'emp_code': employeeCode,
        'sex': gender,
        'full_address': fullAddress,
        'show_address_input': showInputAddress,
        'dob': dob,
        // 'age': age,
        'mobile_number_code': countryCode,
        'mobile_number': primaryMobile,
        'email': primaryEmail,
        'status': userStatus,
        'designation': designation,
        'login_email': adminEmail,
        'reset_password': resetPassword ? 1 : 0,
        'user_id': userId.toString(),
        'receipt_file': await MultipartFile.fromFile(consultantImage.path),
        'joining_date': '',
        'resignation_date': '',
        'id': id,
      });

      print('formData: ${formData.fields}, ${formData.files}');
      print('Endpoint: ${ApiConstant.editUser}');

      final response = await _dio.post(
        ApiConstant.editUser,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Response [${response.statusCode}]: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('Dio error: ${e.response?.statusCode}, ${e.response}');
      if (e.response != null && e.response?.data is Map<String, dynamic>) {
        throw Exception(e.response?.data['message'] ?? 'An error occurred');
      } else {
        throw Exception('No response from server');
      }
    } catch (e) {
      print('Unexpected error: ${e.toString()}');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> deleteUser(
      String id, String userId, String token) async {
    try {
      FormData formData = FormData.fromMap({
        'id': id,
        'user_id': userId,
      });
      print('formData $token, ${formData.fields}');
      print('deleteId $id');
      final response = await _dio.post(
        ApiConstant.deleteUser,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
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

  Future<Map<String, dynamic>> addLookUp(
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
    try {
      FormData formData = FormData.fromMap({
        'consultancy_id': consultancyId,
        'property_name': propertyName,
        'property_description': propertyDescription,
        'status': status ? '1' : '0',
        'hex_color': hexColor,
        'lookup_options': lookupOptions,
        if (id != "") 'id': id,
        if (index != "") 'lookup_option_index': index,
      });
      print('formData $token, ${formData.fields}');

      final response = await _dio.post(
        ApiConstant.addLookup,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );
      print('response-addlookup $response');
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }

  Future<Map<String, dynamic>> addRoleDesignation(String endPoint,
      String consultancyId, String name, String tag, String token) async {
    try {
      final isDesignation = endPoint == 'consultancy-designation/save';

      final formData = FormData.fromMap({
        'consultancy_id': consultancyId,
        if (isDesignation) 'designation_name': name,
        if (isDesignation) 'designation_tag': tag,
        if (!isDesignation) 'name': name,
        if (!isDesignation) 'tag': tag,
        'status': '1',
      });
      print('formData $token, ${formData.fields},$endPoint');

      final response = await _dio.post(
        endPoint,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('eroro msg $e');
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
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
    try {
      FormData formData = FormData.fromMap({
        'consultancy_id': consultancyId,
        'holiday_name': holidayProfileName,
        'holiday_date': holidayProfileDate,
        'days_count': daysCount,
        'valid_upto': validUpto,
        'status': holidayProfileStatus,
        'child_holiday_name': childHolidayName,
        'child_holiday_date': childHolidayDate,
        'child_days_count': childHolidayDayCount,
        'child_valid_upto': childHolidayValidUpto,
        'child_status': childHolidayStatus,
      });

      print('formData $token, ${formData.fields}');

      final response = await _dio.post(
        ApiConstant.createHoliday, // Make sure this constant is defined
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('response-createHoliday $response');
      return response.data;
    } on DioException catch (e) {
      print('erro ${e.toString()}');
      if (e.response != null) {
        return e.response?.data ??
            {'success': false, 'message': 'Unknown error'};
      } else {
        return {'success': false, 'message': 'No response from server'};
      }
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
    try {
      FormData formData = FormData.fromMap({
        'consultancy_id': consultancyId,
        'holiday_name': holidayProfileName,
        'holiday_date': holidayProfileDate,
        'days_count': daysCount,
        'valid_upto': validUpto,
        'status': holidayProfileStatus,
        'parent_id': parentId,
      });

      print('formData $token, ${formData.fields}');

      final response = await _dio.post(
        ApiConstant.createHoliday, // Make sure this constant is defined
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('response-addHoliday $response');
      return response.data;
    } on DioException catch (e) {
      print('erro ${e.toString()}');
      if (e.response != null) {
        return e.response?.data ??
            {'success': false, 'message': 'Unknown error'};
      } else {
        return {'success': false, 'message': 'No response from server'};
      }
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
    //here user id is mandatory bcoz of api
    required dynamic userId
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'holiday_name': holidayProfileName,
        'holiday_date': holidayProfileDate,
        'days_count': daysCount,
        'valid_upto': validUpto,
        'status': holidayProfileStatus,
        'id': id,
        'consultancy_id':userId //here user id will go
      });

      print('formData $token, ${formData.fields}');

      final response = await _dio.post(
        ApiConstant.createHoliday, // Make sure this constant is defined
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('response-editHoliday $response');
      return response.data;
    } on DioException catch (e) {
      print('erro ${e.toString()}');
      if (e.response != null) {
        return e.response?.data ??
            {'success': false, 'message': 'Unknown error'};
      } else {
        return {'success': false, 'message': 'No response from server'};
      }
    }
  }

  Future<Map<String, dynamic>> getHolidayList(
    String userId,
    String token,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'user_id': userId,
      });
      print('formData $token, ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.getHolidayList, // make sure this constant is correct
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('response-getHolidayList ${response.data}');
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response?.data ??
            {'success': false, 'message': 'Unknown error'};
      } else {
        return {'success': false, 'message': 'No response from server'};
      }
    }
  }

  Future<Map<String, dynamic>> getDesignation(
      String userId, String token) async {
    try {
      final formData = FormData.fromMap({'user_id': userId});
      print('formData $token, ${formData.fields}');

      final response = await _dio.post(
        ApiConstant.designationList,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('eroro msg $e');
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }

  Future<Map<String, dynamic>> getRole(String userId, String token) async {
    try {
      final formData = FormData.fromMap({'user_id': userId});
      print('formData $token, ${formData.fields}');

      final response = await _dio.post(
        ApiConstant.roleList,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('eroro msg $e');
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }

  Future<Map<String, dynamic>> getSystemPropertyList(
      String userId, String token) async {
    try {
      final formData = FormData.fromMap({'user_id': userId});
      print('formData $token, ${formData.fields}');

      final response = await _dio.post(
        ApiConstant.systemPropertyList,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('eroro msg $e');
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }

  Future<Map<String, dynamic>> operatorDashBoard(String token) async {
    try {
      print('formData $token');

      final response = await _dio.post(
        ApiConstant.operatorDashboard,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
            // Add auth or other headers if needed
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri}');
      print('Response statusCode: ${response.statusCode}');
      print('Response data: ${response.data}');
      return response.data;
    } on DioException catch (e) {
      print('eroro msg $e');
      if (e.response != null) {
        return e.response?.data ?? {'error': 'Unknown error'};
      } else {
        return {'error': 'No response from server'};
      }
    }
  }

  Future<Map<String, dynamic>> getConsultantClaimsByClientOperator(
    String clientId,
    String month,
    String year,
    String token,
  ) async
  {
    try {
      FormData formData = FormData.fromMap({
        'client_id': clientId,
        'month': month,
        'year': year,
      });
      print('formData $token, ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.operatorClaims,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri},$month,$year');
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

  Future<Map<String, dynamic>> getConsultantTimesheetByClientOperator(
    String clientId,
    String month,
    String year,
    String token,
  ) async
  {
    try {
      FormData formData = FormData.fromMap({
        'client_id': clientId,
        'month': month,
        'year': year,
      });
      print('formData $token, ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.operatorHumanResource,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri},$month,$year');
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
//get finance client list
  Future<Map<String, dynamic>> getFinanceClientList(
    String token,
  ) async {
    try {
      print('formData $token');
      final response = await _dio.post(
        ApiConstant.financeClientList,
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

  Future<Map<String, dynamic>> getConsultantClaimsByClientFinance(
      String clientId,
      String month,
      String year,
      String token,
      ) async
  {
    try {
      FormData formData = FormData.fromMap({
        'client_id': clientId,
        'month': month,
        'year': year,
      });
      print('formData $token, ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.consultantClaimsListFinanceTab,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      print('Request URL: ${response.requestOptions.uri},$month,$year');
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
  Future<Map<String, dynamic>> getConsultantTimesheetByClientFinance(
      String clientId,
      String month,
      String year,
      String token,
      ) async
  {
    try {
      FormData formData = FormData.fromMap({
        'client_id': clientId,
        'month': month,
        'year': year,
      });
      print('formData $token, ${formData.fields}');
      final response = await _dio.post(
        ApiConstant.consultantTimesheetFinanceTab,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );
      print('Request URL: ${response.requestOptions.uri},$month,$year');
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

  Future<Map<String, dynamic>> getClientListClaimInvoiceFinance(
      String token,
      ) async
  {
    try {
      print('formData $token');
      final response = await _dio.post(
        ApiConstant.financeClaimInvoiceClientList,
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

  Future<Map<String, dynamic>> financeClaimClientConsultants(
      String clientId,
      int month,
      int year,
      String token,
      ) async
  {
    try {

      FormData formData = FormData.fromMap({
        'client_id': clientId,
        'month': month,
        'year': year,
      });
      print('formData $token');
      final response = await _dio.post(
        ApiConstant.financeClaimClientConsultants,
        data: formData,
        options: Options(

          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          },
        ),
      );

      print('Request URL: ${response.requestOptions.uri}');
      print('Response fin statusCode: ${response.statusCode}');
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
  
  
  Future<Map<String, dynamic>> getConsultantsByClientFinance(
    String clientId,
    String token,
    ) async
{
  try {
    FormData formData = FormData.fromMap({
      'client_id': clientId,
    });
    print('formData $token, ${formData.fields}');
    final response = await _dio.post(
      ApiConstant.financeConsultantList,
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    print('Request URL: ${response.requestOptions.uri},$clientId');
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
  Future<Map<String, dynamic>> createGroupFinance({
    required String clientId,
    required String groupName,
    required List<String> consultantIds,
    required String token,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'client_id': clientId,
        'group_name': groupName,
        'consultant_ids': consultantIds,
      });
      print('formData $token, ${formData.fields}');

      final response = await _dio.post(
        ApiConstant.financeAddGroup, // Ensure this constant is correctly defined
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('response-createGroupFinance $response');
      return response.data;
    } on DioException catch (e) {
      print('error ${e.toString()}');
      if (e.response != null) {
        return e.response?.data ?? {'success': false, 'message': 'Unknown error'};
      } else {
        return {'success': false, 'message': 'No response from server'};
      }
    }
  }
  Future<Map<String, dynamic>> editGroupFinance({
    required String clientId,
    required String groupName,
    required List<String> consultantIds,
    required String token,
    required String groupId,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'client_id': clientId,
        'group_name': groupName,
        'consultant_ids': consultantIds,
        'group_id' : groupId,
      });
      print('formData $token, ${formData.fields}');

      final response = await _dio.post(
        ApiConstant.financeEditGroup, // Ensure this constant is correctly defined
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('response-createGroupFinance $response');
      return response.data;
    } on DioException catch (e) {
      print('error ${e.toString()}');
      if (e.response != null) {
        return e.response?.data ?? {'success': false, 'message': 'Unknown error'};
      } else {
        return {'success': false, 'message': 'No response from server'};
      }
    }
  }
  Future<Map<String, dynamic>> deleteGroupFinance({
    required String token,
    required String groupId,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'group_id' : groupId,
      });
      print('formData $token, ${formData.fields}');

      final response = await _dio.post(
        ApiConstant. financeDeleteGroup, // Ensure this constant is correctly defined
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('response-createGroupFinance $response');
      return response.data;
    } on DioException catch (e) {
      print('error ${e.toString()}');
      if (e.response != null) {
        return e.response?.data ?? {'success': false, 'message': 'Unknown error'};
      } else {
        return {'success': false, 'message': 'No response from server'};
      }
    }
  }

  Future<Map<String, dynamic>> groupListFinance({
    required String token,
  }) async {
    try {
      FormData formData = FormData.fromMap({});
      print('formData $token, ${formData.fields}');

      final response = await _dio.post(
        ApiConstant.financeGroupList, // Ensure this constant is correctly defined
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print('response-createGroupFinance $response');
      return response.data;
    } on DioException catch (e) {
      print('error ${e.toString()}');
      if (e.response != null) {
        return e.response?.data ?? {'success': false, 'message': 'Unknown error'};
      } else {
        return {'success': false, 'message': 'No response from server'};
      }
    }
  }


}