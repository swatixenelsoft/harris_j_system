import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:harris_j_system/providers/country_provider.dart';
import 'package:harris_j_system/providers/hr_provider.dart';
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

class HrAddConsultantScreen extends ConsumerStatefulWidget {
  const HrAddConsultantScreen({super.key, this.consultancy});

  final Map<String, dynamic>? consultancy;

  @override
  ConsumerState<HrAddConsultantScreen> createState() =>
      _HrAddConsultantScreenState();
}

class _HrAddConsultantScreenState extends ConsumerState<HrAddConsultantScreen> {
  String _primaryCountryCode = '+65'; // Default country code
  String _secondaryCountryCode = '+91'; // Default country code
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _middleName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _employeeCode = TextEditingController();
  final TextEditingController _uenNumber = TextEditingController();
  final TextEditingController _primaryContactPerson = TextEditingController();
  final TextEditingController _mobileNumber = TextEditingController();
  final TextEditingController _emailAddress = TextEditingController();
  final TextEditingController _accountManagerEmailAddress = TextEditingController();
  final TextEditingController _operatorEmailAddress = TextEditingController();
  final TextEditingController _clientAddress = TextEditingController();
  final TextEditingController _secondaryContactPerson = TextEditingController();
  final TextEditingController _secondaryMobileNumber = TextEditingController();
  final TextEditingController _secondaryEmailAddress = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _contractPeriodController =
      TextEditingController();
  final TextEditingController _epDateController = TextEditingController();
  final TextEditingController _joiningDateController = TextEditingController();
  final TextEditingController _lastWorkingDateController =
      TextEditingController();
  final TextEditingController _contractRenewalDateController =
  TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _licenseNumber = TextEditingController();
  final TextEditingController _userCredential = TextEditingController();
  final TextEditingController _passwordCredential = TextEditingController();
  final TextEditingController _billingAmountController =
      TextEditingController();
  final TextEditingController _workingHoursController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _bonusController = TextEditingController();
  final TextEditingController _contractPeriod = TextEditingController();
  final TextEditingController _annualLeaveController = TextEditingController();
  final TextEditingController _medicalLeaveController = TextEditingController();
  final TextEditingController _paidDayOffController = TextEditingController();
  final TextEditingController _compOffController = TextEditingController();
  final TextEditingController _unpaidController = TextEditingController();
  String? _selectedClient = 'Not Selected';
  String? _selectedClientId;
  String? _selectedEmployeeStatus = 'Not Selected';
  String? _selectedEpStatus = 'Not Selected';
  String? _selectedHolidayStatus = 'Not Selected';
  String? _selectedResidentialStatus = 'Not Selected';
  String? _selectedContractStatus = 'Not Selected';
  String? _selectedDesignation = 'Not Selected';
  String? selectedGender = 'Male';
  String? selectedContract = 'no';
  String? _selectedFeeStructure = 'Not Selected';
  String? _selectedLastPaidStatus = 'Not Selected';
  String? _lastPaidDate = '';
  String? _paymentMode = '';
  bool reset_password_value = true;
  dynamic _selectedImage;

  List<String> _clientList = [];
  List<String> _residentialStatusNames = [];
  List<Map<String, dynamic>> _rawClientList = [];
  String? _selectedCountry = 'Not Selected';
  final List<String> _holidayList = [
    'Not Selected',
    'Holiday 1',
    'Holiday 2',
  ];

  final List<String> _epList = [
    'Not Selected',
    'EP',
    'DP',
    'Adhaar No.',
    'NRIC'
  ];
  final List<String> _employeeStatus = [
    'Not Selected',
    'Active',
    'Inactive',
    'Notice Period',
  ];

  final List<Map<String, String>> _residentialStatusList = [
    {'id': 'SR', 'name': 'Singapore Resident'},
    {'id': 'SPR', 'name': 'Singapore Permanent Resident'},
    {'id': 'PP', 'name': 'Passport Holder'},
    {'id': 'EP', 'name': 'Employment Pass'},
  ];

  String? _selectedResidentialStatusName;

  final List<String> _contractStatus = [
    'Not Selected',
    '2 Months',
    '6 Months',
    '1 Year',
    '2 Years',
    '3 Years',
  ];
  final List<String> _designation = [
    'Not Selected',
    'Designation 1',
    'Designation 2',
    'Designation 3',
  ];
  final List<String> _lastPaidStatus = ['Not Selected', 'Pending', 'Paid'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic _confirmedAddress;
  bool get isEdit => widget.consultancy != null;

  String? token;

  @override
  void initState() {
    print('editcons ${widget.consultancy},$_selectedImage');
    if (isEdit) {
      _firstName.text = widget.consultancy!['consultancy_name'] ?? '';
      _employeeCode.text = widget.consultancy!['consultancy_id'] ?? '';

      _confirmedAddress = widget.consultancy!['show_address_input'] ?? '';
      _uenNumber.text = widget.consultancy!['uen_number'] ?? '';
      _primaryContactPerson.text = widget.consultancy!['primary_contact'] ?? '';
      _primaryCountryCode =
          widget.consultancy!['primary_mobile_country_code'] ?? '';
      _mobileNumber.text = widget.consultancy!['primary_mobile'] ?? '';
      _emailAddress.text = widget.consultancy!['primary_email'] ?? '';
      _secondaryContactPerson.text =
          widget.consultancy!['secondary_contact'] ?? '';
      _secondaryEmailAddress.text =
          widget.consultancy!['secondary_email'] ?? '';
      _secondaryCountryCode =
          widget.consultancy!['secondary_mobile_country_code'] ?? '';
      _secondaryMobileNumber.text =
          widget.consultancy!['secondary_mobile'] ?? '';
      _selectedEmployeeStatus = widget.consultancy!['consultancy_status'] ?? '';
      _selectedClient = widget.consultancy!['consultancy_type'] ?? '';
      _dobController.text = DateFormat('dd/MM/yyyy').format(
              DateTime.parse(widget.consultancy!['license_start_date'])) ??
          '';

      _licenseNumber.text = widget.consultancy!['license_number'] ?? '';
      _selectedLastPaidStatus = widget.consultancy!['last_paid_status'] ?? '';
      _selectedFeeStructure = widget.consultancy!['fees_structure'] ?? '';
      _userCredential.text = widget.consultancy!['admin_email'] ?? '';
      _lastPaidDate = widget.consultancy!['last_paid_date'] ?? '';
      _paymentMode = widget.consultancy!['payment_mode'] ?? '';
      _licenseNumber.text = widget.consultancy!['license_number'] ?? '';
    }
    urlToFile();
    getClientList();
    super.initState();
  }

  urlToFile() async {
    // Get temporary directory
    final imageUrl = ApiConstant.imageBaseUrl +
        (widget.consultancy?['consultancy_logo'] ?? '');

    final directory = await getTemporaryDirectory();
    final fileName =
        path.basename(imageUrl); // ✅ Correct usage// Extract filename
    final filePath = '${directory.path}/$fileName';

    // Download image
    final response = await http.get(Uri.parse(imageUrl));

    // Save file
    final file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    _selectedImage = file;
  }

  getClientList() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    final client = await ref.read(hrProvider.notifier).clientList(token!);
    print('client $client');
    _rawClientList = List<Map<String, dynamic>>.from(client['data']);

    _clientList = (client['data'] as List)
        .map<String>((item) => item['serving_client'].toString())
        .toList();

    _residentialStatusNames =
        _residentialStatusList.map((e) => e['name']!).toList();
    print('_clientList $_clientList');
  }

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

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final userIdRegex = RegExp(r'^[a-zA-Z0-9_]{4,20}$');

    if (!emailRegex.hasMatch(value.trim()) &&
        !userIdRegex.hasMatch(value.trim())) {
      return 'Enter a valid email or user ID (4–20 alphanumeric characters)';
    }

    return null;
  }

  String? validateDOBDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required';
    }

    try {
      final inputDate = DateFormat('dd/MM/yyyy').parseStrict(value.trim());
      final currentDate = DateTime.now();

      // Check if date is in the future
      if (inputDate.isAfter(currentDate)) {
        return 'Date of birth cannot be in the future';
      }

      // Calculate age
      int age = currentDate.year - inputDate.year;
      if (currentDate.month < inputDate.month ||
          (currentDate.month == inputDate.month && currentDate.day < inputDate.day)) {
        age--;
      }

      if (age < 21) {
        _ageController.text = '';
        return 'You must be at least 21 years old';

      }

      // ✅ Set age without setState
      _ageController.text = age.toString();
      return null; // Valid DOB
    } catch (e) {
      return 'Invalid date format (dd/MM/yyyy)';
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
    print('dgh');
    final employeeName = _firstName.text.trim();
    final employeeMiddleName=_middleName.text.trim();
    final employeeLastName=_lastName.text.trim();
    final employeeCode = _employeeCode.text.trim();
    final gender = selectedGender;
    final fullAddress = isEdit
        ? widget.consultancy!['full_address']
        : "streetName: ${_confirmedAddress!['apartmentName']},city: ${_confirmedAddress!['state']},country: ${_confirmedAddress!['country']},postalCode: ${_confirmedAddress!['postalCode']}";
    final showInputAddress = isEdit
        ? _confirmedAddress
        : "${_confirmedAddress!['apartmentName']},${_confirmedAddress!['state']},${_confirmedAddress!['country']}";

    final age = _ageController.text.trim();
    final mobileNumber = _mobileNumber.text.trim();
    final email = _emailAddress.text.trim();
    final inputFormat  = DateFormat(
        'dd/MM/yyyy'); // or 'MM/dd/yyyy' depending on your actual format
    final outputFormat = DateFormat('yyyy-MM-dd');
    final joiningDate =
        outputFormat.format(inputFormat.parse(_joiningDateController.text));
    final dateOfBirth =
        outputFormat.format(inputFormat.parse(_dobController.text));
    final endDate =
        outputFormat.format(inputFormat.parse(_lastWorkingDateController.text));
    final selectedClient = _selectedClientId;
    final selectedEmployeeStatus = _selectedEmployeeStatus;
    final selectedHolidayProfile = _selectedHolidayStatus;
    final selectedResidential = _selectedResidentialStatus;
    final selectedDesignation = _selectedDesignation;
    final billingAmount = _billingAmountController.text.trim();
    final workingHours = _workingHoursController.text.trim();
    final adminCredential = _userCredential.text.trim();
    final primaryCountryCode = _primaryCountryCode.trim();
    final resetPassword = reset_password_value;
    final clientName = _selectedClient;
    final annualLeaveCount = _annualLeaveController.text.trim();
    final medicalLeaveCount = _medicalLeaveController.text.trim();
    final paidDayOffCount = _paidDayOffController.text.trim();
    final compOffCount = _compOffController.text.trim();
    final unpaidCount = _unpaidController.text.trim();
    final operatorEmailId=_operatorEmailAddress.text.trim();
    final salary = _salaryController.text.trim();
    final bonus  = _bonusController.text.trim();
    final contractRenewal=selectedContract;
    final contractPeriod=_contractPeriodController.text.trim();
    final contractRenewalDate=_contractRenewalDateController.text.trim();
    final clientCountry=_selectedCountry;
    final clientAddress=_clientAddress.text.trim();

    print('''
============= Employee Form Data =============

👤 Personal Info
First Name             : $employeeName
Middle Name            : $employeeMiddleName
Last Name              : $employeeLastName
Employee Code          : $employeeCode
Gender                 : $gender
Date of Birth          : $dateOfBirth
Age                    : $age
Mobile Number          : $mobileNumber
Email                  : $email

🏢 Employment Info
Joining Date           : $joiningDate
Last Working Date      : $endDate
Client ID              : $selectedClient
Client Name            : $clientName
Designation            : $selectedDesignation
Employee Status        : $selectedEmployeeStatus
Holiday Profile        : $selectedHolidayProfile
Residential Status     : $selectedResidential
Contract Status        : $selectedContract
Contract Renewal       : $contractRenewal
Contract Renewal Date  : $contractRenewalDate

💵 Compensation
Salary                 : $salary
Bonus                  : $bonus
Billing Amount         : $billingAmount
Working Hours          : $workingHours

📍 Address Info
Full Address           : $fullAddress
Show Input Address     : $showInputAddress
Client Address         : $clientAddress
Client Country         : $clientCountry

🔐 Admin Info
Admin Credential       : $adminCredential
Operator Email ID      : $operatorEmailId
Primary Country Code   : $primaryCountryCode
Reset Password         : $resetPassword

📆 Leaves
Annual Leave Count     : $annualLeaveCount
Medical Leave Count    : $medicalLeaveCount
Paid Day Off Count     : $paidDayOffCount
Comp Off Count         : $compOffCount
Unpaid Count           : $unpaidCount

============= Null/Empty Check =============
${employeeName.isEmpty ? '⚠️ employeeName is EMPTY' : ''}
${employeeCode.isEmpty ? '⚠️ employeeCode is EMPTY' : ''}
${gender == null ? '⚠️ gender is NULL' : ''}
${fullAddress.isEmpty ? '⚠️ fullAddress is EMPTY' : ''}
${age.isEmpty ? '⚠️ age is EMPTY' : ''}
${mobileNumber.isEmpty ? '⚠️ mobileNumber is EMPTY' : ''}
${email.isEmpty ? '⚠️ email is EMPTY' : ''}
${joiningDate.isEmpty ? '⚠️ joiningDate is EMPTY' : ''}
${dateOfBirth.isEmpty ? '⚠️ dateOfBirth is EMPTY' : ''}
${endDate.isEmpty ? '⚠️ endDate is EMPTY' : ''}
${selectedClient == null ? '⚠️ selectedClient is NULL' : ''}
${selectedEmployeeStatus == null ? '⚠️ selectedEmployeeStatus is NULL' : ''}
${selectedHolidayProfile == null ? '⚠️ selectedHolidayProfile is NULL' : ''}
${selectedResidential == null ? '⚠️ selectedResidential is NULL' : ''}
${selectedContract == null ? '⚠️ selectedContract is NULL' : ''}
${selectedDesignation == null ? '⚠️ selectedDesignation is NULL' : ''}
${billingAmount.isEmpty ? '⚠️ billingAmount is EMPTY' : ''}
${workingHours.isEmpty ? '⚠️ workingHours is EMPTY' : ''}
${adminCredential.isEmpty ? '⚠️ adminCredential is EMPTY' : ''}
${primaryCountryCode.isEmpty ? '⚠️ primaryCountryCode is EMPTY' : ''}
${resetPassword == null ? '⚠️ resetPassword is NULL' : ''}

============================================
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
      final response = await ref.read(hrProvider.notifier).addConsultant(
        employeeName,
        employeeMiddleName,
        employeeLastName,
        employeeCode,
        gender!,
        fullAddress,
        showInputAddress,
        dateOfBirth,
        age,
        primaryCountryCode,
        mobileNumber,
        email,
        joiningDate,
        endDate,
        selectedClient!,
        selectedEmployeeStatus!,
        selectedHolidayProfile!,
        selectedResidential!,
        contractPeriod,
        selectedDesignation!,
        billingAmount,
        workingHours,
        adminCredential,
        resetPassword,
        userId,
        _selectedImage!,
        token!,
        operatorEmailId,
        salary,
        bonus,
        contractRenewal!,
        contractRenewalDate,
        clientCountry!,
        clientAddress,
        annualLeaveCount,
        medicalLeaveCount,
        paidDayOffCount,
        compOffCount,
        unpaidCount,
      );

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
    final countryState = ref.watch(getCountryProvider);
    final isLoading = ref.watch(hrProvider).isLoading;
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
                            label: ' First Name *',
                            hintText: ' First Name *',
                            controller: _firstName,
                            validator: validateEmployeeName,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            keyboardType: TextInputType.name,
                            padding: 0,
                            borderRadius: 8,
                            label: ' Middle Name *',
                            hintText: ' Middle Name *',
                            controller: _middleName,
                            validator: validateEmployeeName,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            keyboardType: TextInputType.name,
                            padding: 0,
                            borderRadius: 8,
                            label: ' Last Name *',
                            hintText: ' Last Name *',
                            controller: _lastName,
                            validator: validateEmployeeName,
                            textCapitalization: TextCapitalization.words,
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
                                  keyboardType: TextInputType.number,
                                  // validator: validator,
                                ),
                              ),
                            ],
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
                          CountryCodePhoneField(
                            controller: _mobileNumber,
                            onCountryCodeChanged: (code) {
                              print("Selected country code: $code");
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
                                            horizontal: 8, vertical: 5),
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
                                                        widget.consultancy![
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

                          const SizedBox(height: 12),
                          CustomDropdownField(
                            borderRadius: 8,
                            label: "",
                            items: _epList,
                            value: _selectedEpStatus,
                            onChanged: (value) {
                              setState(() {
                                _selectedEpStatus = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              child: SvgPicture.asset(
                                'assets/icons/month_calendar_icon.svg',
                                height: 10,
                                width: 10,
                              ),
                            ),
                            borderRadius: 8,
                            label: 'Select EP Expire date',
                            hintText: 'Select EP Expire date',
                            controller: _epDateController,
                            // validator: validator,
                            readOnly: true,
                            enableInteractiveSelection: false,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              final selected = await CommonFunction()
                                  .selectDate(context, _epDateController);
                              if (selected != null) {
                                setState(() {
                                  _epDateController.text = selected;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Account Manager Email ID',
                            hintText: 'Account Manager Email ID',
                            controller: _accountManagerEmailAddress,
                            validator: validateEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Operator Email ID',
                            hintText: 'COperator Email ID',
                            controller: _operatorEmailAddress,
                            validator: validateEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 12),
                          CustomDropdownField(
                            borderRadius: 8,
                            label: "Select Client",
                            items: ['Not Selected', ..._clientList],
                            value: _selectedClient,
                            onChanged: (value) {
                              setState(() {
                                _selectedClient = value;

                                // Find the client_id for the selected client name
                                final selectedClient =
                                _rawClientList.firstWhere(
                                      (item) => item['serving_client'] == value,
                                  orElse: () => {},
                                );
                                _selectedClientId =
                                    selectedClient['id'].toString() ?? null;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomDropdownField(
                            borderRadius: 8,
                            label: "Country *",
                            items: ["Not Selected", ...?countryState.countryList] ?? [],
                            value: _selectedCountry,
                            onChanged: (value) async {
                              setState(() {
                                _selectedCountry = value;
                              });
                            },
                            // errorText: _isSubmitted && _selectedCountry == "Not Selected"
                            //     ? "Country is required"
                            //     : null,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Client Address',
                            hintText: 'Client address',
                            controller: _clientAddress,
                          ),
                          const SizedBox(height: 12),
                          CustomDropdownField(
                            borderRadius: 8,
                            label: "Select Consultant Status",
                            items: _employeeStatus,
                            value: _selectedEmployeeStatus,
                            onChanged: (value) {
                              setState(() {
                                _selectedEmployeeStatus = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomDropdownField(
                            borderRadius: 8,
                            label: "Select Residential Status",
                            items: ['Not Selected', ..._residentialStatusNames],
                            value: _selectedResidentialStatusName,
                            onChanged: (value) {
                              setState(() {
                                _selectedResidentialStatusName = value;
                                if (value == 'Not Selected') {
                                  // handle no selection if needed
                                } else {
                                  // Find id for selected name
                                  final selected =
                                  _residentialStatusList.firstWhere(
                                        (element) => element['name'] == value,
                                    orElse: () => {'id': '', 'name': ''},
                                  );
                                  _selectedResidentialStatus = selected['id'];
                                  print(
                                      'Selected id: $_selectedResidentialStatus');
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              child: SvgPicture.asset(
                                'assets/icons/month_calendar_icon.svg',
                                height: 10,
                                width: 10,
                              ),
                            ),
                            borderRadius: 8,
                            label: 'Start Date / Joining Date',
                            hintText: 'Start Date / Joining Date',
                            controller: _joiningDateController,
                            // validator: validator,
                            readOnly: true,
                            enableInteractiveSelection: false,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              final selected = await CommonFunction()
                                  .selectDate(context, _joiningDateController);
                              if (selected != null) {
                                setState(() {
                                  _joiningDateController.text = selected;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              child: SvgPicture.asset(
                                'assets/icons/month_calendar_icon.svg',
                                height: 10,
                                width: 10,
                              ),
                            ),
                            borderRadius: 8,
                            label: 'Select Expire / Last working date',
                            hintText: 'Select Expire / Last working date',
                            controller: _lastWorkingDateController,
                            // validator: validator,
                            readOnly: true,
                            enableInteractiveSelection: false,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              final selected = await CommonFunction()
                                  .selectDate(
                                      context, _lastWorkingDateController);
                              if (selected != null) {
                                setState(() {
                                  _lastWorkingDateController.text = selected;
                                });
                              }
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
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Enter billing amount',
                            hintText: 'Enter billing amount',
                            controller: _billingAmountController,
                            keyboardType: TextInputType.number,
                            // validator: validateEmail,
                            // validator: validateUserIdOrEmail,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Enter Working Hours',
                            hintText: 'Enter Working Hours',
                            controller: _workingHoursController,
                            keyboardType: TextInputType.number,
                            // validator: validateEmail,
                            // validator: validateUserIdOrEmail,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Enter Salary',
                            hintText: 'Enter Salary',
                            controller: _salaryController,
                            keyboardType: TextInputType.number,
                            // validator: validateEmail,
                            // validator: validateUserIdOrEmail,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Enter Bonus',
                            hintText: 'Enter Bonus',
                            controller: _bonusController,
                            keyboardType: TextInputType.number,
                            // validator: validateEmail,
                            // validator: validateUserIdOrEmail,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Contract Renewal :',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff828282),
                                ),
                              ),
                              contractOption(
                                label: 'Yes',
                                value: 'yes',
                              ),
                              contractOption(
                                label: 'No',
                                value: 'no',
                              ),

                            ],
                          ),
                         if(selectedContract=='yes')...[ CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Add Contract Period',
                            hintText: 'Add Contract Period',
                            controller: _contractPeriod,
                            keyboardType: TextInputType.number,
                            // validator: validateEmail,
                            // validator: validateUserIdOrEmail,
                          ),

                          const SizedBox(height: 12),
                          CustomTextField(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              child: SvgPicture.asset(
                                'assets/icons/month_calendar_icon.svg',
                                height: 10,
                                width: 10,
                              ),
                            ),
                            borderRadius: 8,
                            label: 'Select Contract renewal Date',
                            hintText: 'Select Contract renewal Date',
                            controller: _contractRenewalDateController,
                            // validator: validator,
                            readOnly: true,
                            enableInteractiveSelection: false,
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              final selected = await CommonFunction()
                                  .selectDate(
                                  context, _contractRenewalDateController);
                              if (selected != null) {
                                setState(() {
                                  _contractRenewalDateController.text = selected;
                                });
                              }
                            },
                          ),],
                          const SizedBox(height: 10),
                          _buildSectionTitle('Holiday Assigned',
                              const Color(0xffFF1901), FontWeight.w700),
                          const SizedBox(height: 10),

                          CustomDropdownField(
                            borderRadius: 8,
                            label: "Select Holiday Profile",
                            items: _holidayList,
                            value: _selectedHolidayStatus,
                            onChanged: (value) {
                              setState(() {
                                _selectedHolidayStatus = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Enter Annual Leave Count',
                            hintText: 'Enter Annual Leave Count',
                            controller: _annualLeaveController,
                            keyboardType: TextInputType.number,
                            // validator: validateEmail,
                            // validator: validateUserIdOrEmail,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Enter Medical Leave Count',
                            hintText: 'Enter Medical Leave Count',
                            controller: _medicalLeaveController,
                            keyboardType: TextInputType.number,
                            // validator: validateEmail,
                            // validator: validateUserIdOrEmail,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Enter Paid day off Count',
                            hintText: 'Enter Paid day off Count',
                            controller: _paidDayOffController,
                            keyboardType: TextInputType.number,
                            // validator: validateEmail,
                            // validator: validateUserIdOrEmail,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Enter Comp off Count',
                            hintText: 'Enter Comp off Count',
                            controller: _compOffController,
                            keyboardType: TextInputType.number,
                            // validator: validateEmail,
                            // validator: validateUserIdOrEmail,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Enter unpaid Count',
                            hintText: 'Enter unpaid Count',
                            controller: _unpaidController,
                            keyboardType: TextInputType.number,
                            // validator: validateEmail,
                            // validator: validateUserIdOrEmail,
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
                          const SizedBox(height: 10),
                          if (isEdit) ...[
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
                            text: 'Reset Password',
                            onPressed: () {
                              setState(() {
                                reset_password_value = !reset_password_value;
                              });
                            },
                          ),],
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
                  'Add Consultant',
                  style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffFF1901)),
                ),
                const SizedBox(width: 35),
                CustomButton(
                  leftPadding: 2,
                  text: 'Add Address',
                  width: 100,
                  height: 36,
                  borderRadius: 6,
                  onPressed: () {
                    showAddAddressBottomSheet(
                      context,
                      widget.consultancy?['full_address'] ?? '',
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
  })
  {
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

  Widget contractOption({
    required String label,
    required String value,
    IconData? icon,
  })
  {
    bool isSelected = selectedContract == value;
    return GestureDetector(
      onTap: () => setState(() => selectedContract = value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (val) => setState(() => selectedContract = value),
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
