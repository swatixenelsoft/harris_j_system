import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:harris_j_system/providers/consultancy_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:harris_j_system/providers/bom_provider.dart';
import 'package:harris_j_system/screens/bom/bom_add_address_screen.dart';
import 'package:harris_j_system/services/api_constant.dart';
import 'package:harris_j_system/ulits/common_function.dart';
import 'package:harris_j_system/ulits/custom_icon_container.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_country_picker_field.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsultancyAddUserScreen extends ConsumerStatefulWidget {
  const ConsultancyAddUserScreen({super.key, this.userList});

  final Map<String, dynamic>? userList;

  @override
  ConsumerState<ConsultancyAddUserScreen> createState() =>
      _ConsultancyAddUserScreen();
}

class _ConsultancyAddUserScreen
    extends ConsumerState<ConsultancyAddUserScreen> {
  String _primaryCountryCode = '+65'; // Default country code
  final TextEditingController _employeeName = TextEditingController();
  final TextEditingController _employeeCode = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _emailAddress = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _licenseNumber = TextEditingController();
  final TextEditingController _userCredential = TextEditingController();
  final TextEditingController _passwordCredential = TextEditingController();
  String? _selectedUser = 'Not Selected';
  String? _selectedDesignation = 'Not Selected';
  String? selectedGender = 'Male';
  bool reset_password_value = false;
  dynamic _selectedImage;
  final List<String> _userList = ['Not Selected', 'Active', 'Disable'];
  final List<String> _designation = [
    'Not Selected',
    'Designation1',
    'Designation2'
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic _confirmedAddress;
  bool get isEdit => widget.userList != null;

  @override
  void initState() {
    // print('editcons ${widget.consultancy},$_selectedImage');
    // if (isEdit) {
    //   _employeeName.text = widget.consultancy!['consultancy_name'] ?? '';
    //   _employeeCode.text = widget.consultancy!['consultancy_id'] ?? '';
    //
    //   _confirmedAddress = widget.consultancy!['show_address_input'] ?? '';
    //   _uenNumber.text = widget.consultancy!['uen_number'] ?? '';
    //   _primaryContactPerson.text = widget.consultancy!['primary_contact'] ?? '';
    //   _primaryCountryCode =
    //       widget.consultancy!['primary_mobile_country_code'] ?? '';
    //   _mobileNumber.text = widget.consultancy!['primary_mobile'] ?? '';
    //   _emailAddress.text = widget.consultancy!['primary_email'] ?? '';
    //   _secondaryContactPerson.text =
    //       widget.consultancy!['secondary_contact'] ?? '';
    //   _secondaryEmailAddress.text =
    //       widget.consultancy!['secondary_email'] ?? '';
    //   _secondaryCountryCode =
    //       widget.consultancy!['secondary_mobile_country_code'] ?? '';
    //   _secondaryMobileNumber.text =
    //       widget.consultancy!['secondary_mobile'] ?? '';
    //   _selectedEmployeeStatus =
    //       widget.consultancy!['consultancy_status'] ?? '';
    //   _selectedClient = widget.consultancy!['consultancy_type'] ?? '';
    //   _dobController.text = DateFormat('dd/MM/yyyy').format(
    //           DateTime.parse(widget.consultancy!['license_start_date'])) ??
    //       '';
    //
    //   _licenseNumber.text = widget.consultancy!['license_number'] ?? '';
    //   _selectedLastPaidStatus = widget.consultancy!['last_paid_status'] ?? '';
    //   _selectedFeeStructure = widget.consultancy!['fees_structure'] ?? '';
    //   _userCredential.text = widget.consultancy!['admin_email'] ?? '';
    //   _lastPaidDate = widget.consultancy!['last_paid_date'] ?? '';
    //   _paymentMode = widget.consultancy!['payment_mode'] ?? '';
    //   _licenseNumber.text = widget.consultancy!['license_number'] ?? '';
    // }
    // urlToFile();
    super.initState();
  }

  // urlToFile() async {
  //   // Get temporary directory
  //   final imageUrl = ApiConstant.imageBaseUrl +
  //       (widget.consultancy?['consultancy_logo'] ?? '');
  //
  //   final directory = await getTemporaryDirectory();
  //   final fileName =
  //       path.basename(imageUrl); // ✅ Correct usage// Extract filename
  //   final filePath = '${directory.path}/$fileName';
  //
  //   // Download image
  //   final response = await http.get(Uri.parse(imageUrl));
  //
  //   // Save file
  //   final file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   _selectedImage = file;
  // }

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title, Color color, FontWeight fontWeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontWeight: fontWeight,
          color: color,
          fontSize: 14,
        ),
      ),
    );
  }

  void showAddAddressBottomSheet(BuildContext context, address) async {
    Map<String, dynamic>? confirmedData =
        await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Make the background transparent
      builder: (context) {
        return AddAddressBottomSheet(address: address);
      },
    );

    if (confirmedData != null) {
      setState(() {
        _confirmedAddress = confirmedData;
      });
      print('seletedImage $_selectedImage');
    }
  }

  String? validateEmployeeName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter employee name';
    }

    final validNameRegex = RegExp(r"^[a-zA-Z0-9 .'-]+$");
    if (!validNameRegex.hasMatch(value.trim())) {
      return 'Only letters, numbers, spaces, dots, apostrophes, and hyphens are allowed';
    }

    return null;
  }

  String? validateEmployeeCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter employee code';
    }

    final validIdRegex = RegExp(r'^[a-zA-Z0-9_-]{4,20}$');
    if (!validIdRegex.hasMatch(value.trim())) {
      return 'Employee code must be 4–20 characters and can contain letters, numbers, - or _';
    }

    return null;
  }

  String? validateUEN(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter UEN number';
    }

    final uen = value.trim();
    final uen9CharRegex = RegExp(r'^[A-Z]{1}\d{8}$');
    final uen10CharRegex = RegExp(r'^\d{8}[A-Z]{2}$');

    if (!(uen9CharRegex.hasMatch(uen) || uen10CharRegex.hasMatch(uen))) {
      return 'Invalid UEN format';
    }

    return null;
  }

  String? validateContactPerson(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the contact person\'s name';
    }

    final name = value.trim();
    final nameRegex =
        RegExp(r'^[a-zA-Z\s]+$'); // Allows only letters and spaces.

    if (!nameRegex.hasMatch(name)) {
      return 'Contact person name must only contain letters and spaces';
    }

    if (name.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter an email address';
    }

    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  String? validateLicenseNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field – no validation if empty
    }

    final licenseRegex = RegExp(r'^[A-Za-z0-9\-]{6,20}$');
    if (!licenseRegex.hasMatch(value.trim())) {
      return 'License number must be 6–20 characters (letters, numbers, or hyphens)';
    }

    return null;
  }

  String? validateUserIdOrEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a User ID or Email';
    }

    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    final userIdRegex = RegExp(r'^[a-zA-Z0-9_]{4,20}$');

    if (!emailRegex.hasMatch(value.trim()) &&
        !userIdRegex.hasMatch(value.trim())) {
      return 'Enter a valid email or user ID (4–20 alphanumeric characters)';
    }

    return null;
  }

  String? validateDOBDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    try {
      final startDate = DateFormat('dd/MM/yyyy').parseStrict(value.trim());
      //
      // if(startDate==DateFormat('dd / MM / yyyy').format(DateTime.now())){
      //   return 'start date ';
      // }
      return null;
    } catch (e) {
      return 'Invalid start date format (dd/MM/yyyy)';
    }
  }

  String? validateLicenseEndDate(String? value) {
    final startValue = _dobController.text.trim();

    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    try {
      final endDate = DateFormat('dd/MM/yyyy').parseStrict(value.trim());

      if (startValue.isNotEmpty) {
        final startDate = DateFormat('dd/MM/yyyy').parseStrict(startValue);
        if (endDate.isBefore(startDate)) {
          return 'End date must be after start date';
        }
      }

      return null;
    } catch (e) {
      return 'Invalid end date format (dd/MM/yyyy)';
    }
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      // Not required, so return null (no error)
      return null;
    }

    final phoneRegex = RegExp(r'^\d{6,15}$'); // 6 to 15 digit numbers
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Enter a valid mobile number';
    }

    return null; // Valid input
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }

    print('_selectImage $_selectedImage');
  }

  void _submitForm() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId')!;
    final token = prefs.getString('token');
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final employeeName = _employeeName.text.trim();
    final employeeCode = _employeeCode.text.trim();
    final gender = selectedGender;
    final fullAddress = isEdit
        ? widget.userList!['full_address']
        : "streetName: ${_confirmedAddress!['apartmentName']},city: ${_confirmedAddress!['state']},country: ${_confirmedAddress!['country']},postalCode: ${_confirmedAddress!['postalCode']}";
    final showInputAddress = isEdit
        ? _confirmedAddress
        : "${_confirmedAddress!['apartmentName']},${_confirmedAddress!['state']},${_confirmedAddress!['country']}";

    final age = _ageController.text.trim();
    final mobileNumber = _mobileNumber.text.trim();
    final email = _emailAddress.text.trim();
    final inputFormat = DateFormat(
        'dd/MM/yyyy'); // or 'MM/dd/yyyy' depending on your actual format
    final outputFormat = DateFormat('yyyy-MM-dd');
    final dateOfBirth =
        outputFormat.format(inputFormat.parse(_dobController.text));
    final selectedDesignation = _selectedDesignation!;
    final adminCredential = _userCredential.text.trim();
    final primaryCountryCode = _primaryCountryCode.trim();
    final resetPassword = reset_password_value;
    final userStatus = _selectedUser!;

    print('''
========= Employee Form Data =========
employeeName           : $employeeName
employeeCode           : $employeeCode
gender                 : $gender
fullAddress            : $fullAddress
showInputAddress       : $showInputAddress
age                    : $age
mobileNumber           : $mobileNumber
email                  : $email
dateOfBirth            : $dateOfBirth
adminCredential        : $adminCredential
primaryCountryCode     : $primaryCountryCode
resetPassword          : $resetPassword
selectedClient          : $userStatus
selectedDesignation          : $selectedDesignation
userId          : $userId
======== Null/Empty Check =========
${employeeName.isEmpty ? 'employeeName is EMPTY' : ''}
${employeeCode.isEmpty ? 'employeeCode is EMPTY' : ''}
${gender == null ? 'gender is NULL' : ''}
${fullAddress.isEmpty ? 'fullAddress is EMPTY' : ''}
${age.isEmpty ? 'age is EMPTY' : ''}
${mobileNumber.isEmpty ? 'mobileNumber is EMPTY' : ''}
${email.isEmpty ? 'email is EMPTY' : ''}
${dateOfBirth.isEmpty ? 'dateOfBirth is EMPTY' : ''}
${adminCredential.isEmpty ? 'adminCredential is EMPTY' : ''}
${primaryCountryCode.isEmpty ? 'primaryCountryCode is EMPTY' : ''}
${resetPassword == null ? 'resetPassword is NULL' : ''}
=====================================
''');

    // final
    print('isEdit $isEdit');
    try {
      print('isEdit $isEdit');
      // final response = isEdit
      //     ? await ref.read(consultancyProvider.notifier).editConsultancy(
      //     widget.consultancy!['id'],
      //     consultancyName,
      //     consultancyId,
      //     uenNumber,
      //     fullAddress,
      //     showInputAddress,
      //     primaryContactPerson,
      //     primaryMobileNumber,
      //     primaryEmailAddress,
      //     secondaryContactPerson,
      //     secondaryMobileNumber,
      //     secondaryEmailAddress,
      //     selectedConsultancyType!,
      //     selectedConsultancyStatus!,
      //     licenseStartDate.toString(),
      //     licenseEndDate.toString(),
      //     licenseNumber,
      //     selectedFeeStructure!,
      //     selectedLastPaidStatus!,
      //     adminCredential,
      //     primaryCountryCode,
      //     secondaryCountryCode,
      //     resetPassword,
      //     userId,
      //     _selectedImage!,token!)
      //     :
      final response = await ref.read(consultancyProvider.notifier).addUser(
          employeeName,
          employeeCode,
          gender!,
          fullAddress,
          showInputAddress,
          dateOfBirth,
          age,
          primaryCountryCode,
          mobileNumber,
          email,
          adminCredential,
          resetPassword,
          userId,
          selectedDesignation,
          userStatus,
          _selectedImage!,
          token!);

      if (!mounted) return;

      final dynamic status = response['status'];

      print('status $status');

      if (status) {
        context.pop(true);

        //  Show success toast
        ToastHelper.showSuccess(
            context, response['message'] ?? 'Consultant created successfully!');
      } else if (status == true) {
        context.pop(true);

        //  Show success toast
        ToastHelper.showSuccess(
            context, response['message'] ?? 'Consultant update successfully!');
      } else {
        ToastHelper.showError(context, response['message']);
      }
    } catch (e) {
      if (!mounted) return;
      print('Login error: $e');
      //  Show exception toast
      ToastHelper.showError(context, 'Something went wrong. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(bomProvider).isLoading;
    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: false,
        image: 'assets/icons/cons_logo.png',
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderContent(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          _buildSectionTitle('General & Contact Information',
                              const Color(0xffFF1901), FontWeight.w700),
                          const SizedBox(height: 12),
                          CustomTextField(
                            keyboardType: TextInputType.name,
                            padding: 0,
                            borderRadius: 8,
                            label: ' Employee Name *',
                            hintText: ' Employee Name *',
                            controller: _employeeName,
                            validator: validateEmployeeName,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Employee Code *',
                            hintText: 'Employee Code *',
                            controller: _employeeCode,
                            validator: validateEmployeeCode,
                            textCapitalization: TextCapitalization.none,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Sex :',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff828282),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              genderOption(
                                  label: 'Male',
                                  value: 'Male',
                                  icon: Icons.male),
                              genderOption(
                                  label: 'Female',
                                  value: 'Female',
                                  icon: Icons.female),
                              genderOption(label: 'Others', value: 'Others'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildDateField(
                              'Date of Birth', _dobController, validateDOBDate),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Age :',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff828282),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                width: 230,
                                child: CustomTextField(
                                  borderRadius: 8,
                                  label: 'Enter Age',
                                  hintText: 'Enter Age',
                                  controller: _ageController,
                                  // validator: validator,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CountryCodePhoneField(
                            controller: _mobileNumber,
                            onCountryCodeChanged: (code) {
                              print("Selected country code: $code");
                              _primaryCountryCode = code;
                            },
                            validator: validatePhoneNumber,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Email Address *',
                            hintText: 'Email Address *',
                            controller: _emailAddress,
                            validator: validateEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              height: 45,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFFEDEDED)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/upload.svg',
                                    height: 20,
                                    width: 20,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    'Upload profile picture',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff828282),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '*Recommended Minimum Resolution 512 x 512 px. (Max.file size: 1MB)',
                            style: GoogleFonts.montserrat(
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff798AA3)),
                          ),
                          const SizedBox(height: 13),
                          if (_selectedImage == null) ...[
                            DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(8),
                              dashPattern: const [6, 4],
                              color: const Color(0xffA8B9CA),
                              strokeWidth: 1.5,
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Profile Picture Preview',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xffA8B9CA)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '*rxmed.png  size : 512kb',
                              style: GoogleFonts.montserrat(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff798AA3)),
                            ),
                          ],
                          if (_selectedImage != null &&
                              RegExp(r'\.(jpg|jpeg|png|gif|bmp|webp)$',
                                      caseSensitive: false)
                                  .hasMatch(_selectedImage!.path)) ...[
                            const SizedBox(width: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _selectedImage!,
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                          const SizedBox(height: 13),
                          _confirmedAddress != null
                              ? Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 3, color: Colors.grey)
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 70,
                                          height: 35,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                255, 150, 27, 0.3),
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(12),
                                                topLeft: Radius.circular(12)),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.location_pin,
                                                color: Color(0xffFF1901),
                                                size: 15,
                                              ),
                                              Text(
                                                'Default',
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(
                                                        0xffFF1901)),
                                              ),
                                            ],
                                          )),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _confirmedAddress is String
                                                    ? _confirmedAddress
                                                    : '${_confirmedAddress!['apartmentName']}, '
                                                        '${_confirmedAddress!['unitNumber']}, '
                                                        '${_confirmedAddress!['landMark']}, '
                                                        '${_confirmedAddress!['state']}, '
                                                        '${_confirmedAddress!['country']} - '
                                                        '${_confirmedAddress!['postalCode']}',
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xff1D212D),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    // context.push(Constant.bomAddConsultancyScreen, extra: consultancy);
                                                    showAddAddressBottomSheet(
                                                        context,
                                                        widget.userList![
                                                            'full_address']);
                                                  },
                                                  child: const CustomIconContainer(
                                                      path:
                                                          'assets/icons/edit_pen.svg',
                                                      bgColor:
                                                          Color(0xffF5230C)),
                                                ),
                                                const SizedBox(width: 7),
                                                GestureDetector(
                                                  // onTap: () =>
                                                  //     DeleteConfirmationDialog.show(
                                                  //         context: context,
                                                  //         itemName: 'consultancy',
                                                  //         onConfirm: () async {
                                                  //           final deleteResponse = await ref
                                                  //               .read(
                                                  //               consultancyProvider
                                                  //                   .notifier)
                                                  //               .deleteConsultancy(
                                                  //               consultancy[
                                                  //               'id']);
                                                  //
                                                  //           if (deleteResponse[
                                                  //           'status'] ==
                                                  //               true) {
                                                  //             ToastHelper
                                                  //                 .showSuccess(
                                                  //               context,
                                                  //               deleteResponse[
                                                  //               'message'] ??
                                                  //                   'Consultancy deleted successfully',
                                                  //             );
                                                  //           } else {
                                                  //             ToastHelper
                                                  //                 .showError(
                                                  //               context,
                                                  //               deleteResponse[
                                                  //               'message'] ??
                                                  //                   'Failed to delete consultancy',
                                                  //             );
                                                  //           }
                                                  //         }),
                                                  child: const CustomIconContainer(
                                                      path:
                                                          'assets/icons/red_delete_icon.svg'),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(8),
                                  dashPattern: const [6, 4],
                                  color: const Color(0xffA8B9CA),
                                  strokeWidth: 1.5,
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      '',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xffA8B9CA)),
                                    ),
                                  ),
                                ),
                          SizedBox(height: 12),
                          CustomDropdownField(
                            borderRadius: 8,
                            label: "Select User Status",
                            items: _userList,
                            value: _selectedUser,
                            onChanged: (value) {
                              setState(() {
                                _selectedUser = value;
                              });
                              print('_selectedUser $_selectedUser');
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildSectionTitle('Designation',
                              const Color(0xffFF1901), FontWeight.w700),
                          const SizedBox(height: 10),
                          CustomDropdownField(
                            borderRadius: 8,
                            label: "Designation *",
                            items: _designation,
                            value: _selectedDesignation,
                            onChanged: (value) {
                              setState(() {
                                _selectedDesignation = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildSectionTitle('User Credentials',
                              const Color(0xffFF1901), FontWeight.w700),
                          const SizedBox(height: 8),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'User Id / Email *',
                            hintText: 'User Id / Email *',
                            controller: _userCredential,
                            // validator: validateEmail,
                            validator: validateUserIdOrEmail,
                          ),
                          if (isEdit) ...[
                            const SizedBox(height: 10),
                            CustomTextField(
                              padding: 0,
                              borderRadius: 8,
                              label: 'Type Default Password *',
                              hintText: 'Type Default Password *',
                              controller: _passwordCredential,
                              // validator: validateEmail,
                              validator: validateUserIdOrEmail,
                            ),
                            const SizedBox(height: 12),
                            CustomButton(
                              container: true,
                              containerIcon: reset_password_value,
                              width: 200,
                              height: 46,
                              text: 'Send Password',
                              onPressed: () {
                                setState(() {
                                  reset_password_value = !reset_password_value;
                                });
                              },
                            )
                          ],
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  leftPadding: 2,
                                  text: isEdit ? 'Update' : 'Submit',
                                  width: 160,
                                  height: 36,
                                  borderRadius: 6,
                                  onPressed: () {
                                    _submitForm();
                                  },
                                  isOutlined: true,
                                  svgAsset: 'assets/icons/save.svg',
                                ),
                                CustomButton(
                                  leftPadding: 2,
                                  text: 'Cancel',
                                  width: 160,
                                  height: 36,
                                  borderRadius: 6,
                                  onPressed: () {},
                                  isOutlined: true,
                                  svgAsset: 'assets/icons/clear_icon.svg',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                  alignment: Alignment.center,
                  child: const CustomLoader(
                    color: Color(0xffFF1901),
                    size: 35,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateField(
      String label, TextEditingController controller, validator) {
    return Row(
      children: [
        Text(
          '$label :',
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xff828282),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomTextField(
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: SvgPicture.asset(
                'assets/icons/month_calendar_icon.svg',
                height: 10,
                width: 10,
              ),
            ),
            borderRadius: 8,
            label: 'DD / MM / YYYY',
            hintText: 'DD / MM / YYYY',
            controller: controller,
            validator: validator,
            readOnly: true,
            enableInteractiveSelection: false,
            onTap: () async {
              FocusScope.of(context).unfocus();
              final selected =
                  await CommonFunction().selectDate(context, controller);
              if (selected != null) {
                setState(() {
                  controller.text = selected;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: Color(0xffE8E8E8)),
          left: BorderSide(color: Color(0xffE8E8E8)),
          right: BorderSide(color: Color(0xffE8E8E8)),
          bottom: BorderSide.none, // 👈 removes bottom border
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child:
                        SvgPicture.asset('assets/icons/back.svg', height: 15)),
                const SizedBox(width: 12),
                Text(
                  isEdit ? 'Edit User' : 'Add User',
                  style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffFF1901)),
                ),
                const SizedBox(width: 85),
                CustomButton(
                  leftPadding: 2,
                  text: 'Add Address',
                  width: 100,
                  height: 36,
                  borderRadius: 6,
                  onPressed: () {
                    showAddAddressBottomSheet(
                      context,
                      widget.userList?['full_address'] ?? null,
                    );
                  },
                  svgAsset: 'assets/icons/home_icon.svg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget genderOption({
    required String label,
    required String value,
    IconData? icon,
  }) {
    bool isSelected = selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (val) => setState(() => selectedGender = value),
            activeColor: Color(0xff007BFF),
            side: const BorderSide(color: Color(0xff828282)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: const Color(0xff1D212D),
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(icon, color: isSelected ? Colors.blue : Colors.black54),
        ],
      ),
    );
  }
}
