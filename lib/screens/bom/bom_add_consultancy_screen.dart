import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:harris_j_system/screens/bom/widget/dialog_subscription.dart';
import 'package:harris_j_system/widgets/custom_currency_picker.dart';
import 'package:harris_j_system/widgets/custom_red_button_textfield.dart';
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

class BomAddConsultancyScreen extends ConsumerStatefulWidget {
  const BomAddConsultancyScreen({super.key, this.consultancy});

  final Map<String, dynamic>? consultancy;

  @override
  ConsumerState<BomAddConsultancyScreen> createState() =>
      _BomAddConsultancyScreenState();
}
class _BomAddConsultancyScreenState
    extends ConsumerState<BomAddConsultancyScreen> {
  String _primaryCountryCode = '+65'; // Default country code
  String _secondaryCountryCode = '+91'; // Default country code
  final TextEditingController _consultancyName = TextEditingController();
  final TextEditingController _consultancyId = TextEditingController();
  final TextEditingController _uenNumber = TextEditingController();
  final TextEditingController _primaryContactPerson = TextEditingController();
  final TextEditingController _primaryMobileNumber = TextEditingController();
  final TextEditingController _primaryEmailAddress = TextEditingController();
  final TextEditingController _secondaryContactPerson = TextEditingController();
  final TextEditingController _secondaryMobileNumber = TextEditingController();
  final TextEditingController _secondaryEmailAddress = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _licenseNumber = TextEditingController();
  final TextEditingController _adminCredential = TextEditingController();
  final TextEditingController _subscriptionController = TextEditingController();
  String? _selectedConsultancyType = 'Not Selected';
  String? _selectedConsultancyStatus = 'Not Selected';
  String? _selectedFeeStructure = 'Not Selected';
  String? _selectedLastPaidStatus = 'Not Selected';
  String? _lastPaidDate = '';
  String? _paymentMode = '';
  bool reset_password_value = false;
  dynamic _selectedImage;
  final List<Map<String, String>> _consultancyType = [
    {'label': 'Not Selected', 'value': ''},
    {'label': 'Primary Consultancy', 'value': 'type1'},
    {'label': 'Silver Consultancy', 'value': 'type2'},
  ];
  final List<String> _consultancyStatus = [
    'Not Selected',
    'Active',
    'Disabled',
  ];
  final List<String> _feeStructure = [
    'Not Selected',
    'Monthly',
    'Quarterly',
    'Half-Yearly',
    'Yearly',
  ];
  final List<String> _lastPaidStatus = ['Not Selected', 'Pending', 'Paid'];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic _confirmedAddress;
  bool get isEdit => widget.consultancy != null;

  @override
  void initState() {
    print('editcons ${widget.consultancy},$_selectedImage');
    if (isEdit) {
      _consultancyName.text = widget.consultancy!['consultancy_name'] ?? '';
      _consultancyId.text = widget.consultancy!['consultancy_id'] ?? '';
      _confirmedAddress = widget.consultancy!['show_address_input'] ?? '';
      _uenNumber.text = widget.consultancy!['uen_number'] ?? '';
      _primaryContactPerson.text = widget.consultancy!['primary_contact'] ?? '';
      _primaryCountryCode =
          widget.consultancy!['primary_mobile_country_code'] ?? '';
      _primaryMobileNumber.text = widget.consultancy!['primary_mobile'] ?? '';
      _primaryEmailAddress.text = widget.consultancy!['primary_email'] ?? '';
      _secondaryContactPerson.text =
          widget.consultancy!['secondary_contact'] ?? '';
      _secondaryEmailAddress.text =
          widget.consultancy!['secondary_email'] ?? '';
      _secondaryCountryCode =
          widget.consultancy!['secondary_mobile_country_code'] ?? '';
      _secondaryMobileNumber.text =
          widget.consultancy!['secondary_mobile'] ?? '';
      _selectedConsultancyStatus =
          widget.consultancy!['consultancy_status'] ?? '';
      _selectedConsultancyType = widget.consultancy!['consultancy_type'] ?? '';
      _startDateController.text = DateFormat('dd/MM/yyyy').format(
              DateTime.parse(widget.consultancy!['license_start_date'])) ?? '';
      _endDateController.text = DateFormat('dd/MM/yyyy').format(
              DateTime.parse(widget.consultancy!['license_end_date'])) ?? '';
      _licenseNumber.text = widget.consultancy!['license_number'] ?? '';
      _selectedLastPaidStatus = widget.consultancy!['last_paid_status'] ?? '';
      _selectedFeeStructure = widget.consultancy!['fees_structure'] ?? '';
      _adminCredential.text = widget.consultancy!['admin_email'] ?? '';
      _lastPaidDate = widget.consultancy!['last_paid_date'] ?? '';
      _paymentMode = widget.consultancy!['payment_mode'] ?? '';
      _licenseNumber.text = widget.consultancy!['license_number'] ?? '';
    }
    urlToFile();
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

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Widget _buildSectionTitle(String title, Color color, FontWeight fontWeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontWeight: fontWeight,
          color: color,
          fontSize: 12,
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

  String? validateConsultancyName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter consultancy name';
    }

    final validNameRegex = RegExp(r"^[a-zA-Z0-9 .'-]+$");
    if (!validNameRegex.hasMatch(value.trim())) {
      return 'Only letters, numbers, spaces, dots, apostrophes, and hyphens are allowed';
    }

    return null;
  }

  String? validateConsultancyId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter consultancy ID';
    }

    final validIdRegex = RegExp(r'^[a-zA-Z0-9_-]{4,20}$');
    if (!validIdRegex.hasMatch(value.trim())) {
      return 'Consultancy ID must be 4–20 characters and can contain letters, numbers, - or _';
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

  String? validateLicenseStartDate(String? value) {
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
    final startValue = _startDateController.text.trim();

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

    final consultancyName = _consultancyName.text.trim();
    final consultancyId = _consultancyId.text.trim();
    final uenNumber = _uenNumber.text.trim();
    final fullAddress = isEdit
        ? widget.consultancy!['full_address']
        : "streetName: ${_confirmedAddress!['apartmentName']},city: ${_confirmedAddress!['state']},country: ${_confirmedAddress!['country']},postalCode: ${_confirmedAddress!['postalCode']}";
    final showInputAddress = isEdit
        ? _confirmedAddress
        : "${_confirmedAddress!['apartmentName']},${_confirmedAddress!['state']},${_confirmedAddress!['country']}";
    final primaryContactPerson = _primaryContactPerson.text.trim();
    final primaryMobileNumber = _primaryMobileNumber.text.trim();
    final primaryEmailAddress = _primaryEmailAddress.text.trim();
    final secondaryContactPerson = _secondaryContactPerson.text.trim();
    final secondaryMobileNumber = _secondaryMobileNumber.text.trim();
    final secondaryEmailAddress = _secondaryEmailAddress.text.trim();
    final selectedConsultancyType = _selectedConsultancyType;
    final selectedConsultancyStatus = _selectedConsultancyStatus;
    final inputFormat = DateFormat(
        'dd/MM/yyyy'); // or 'MM/dd/yyyy' depending on your actual format
    final outputFormat = DateFormat('yyyy-MM-dd');

    final licenseStartDate =
        outputFormat.format(inputFormat.parse(_startDateController.text));
    final licenseEndDate =
        outputFormat.format(inputFormat.parse(_endDateController.text));

    final licenseNumber = _licenseNumber.text.trim();
    final selectedFeeStructure = _selectedFeeStructure;
    final selectedLastPaidStatus = _selectedLastPaidStatus;
    final adminCredential = _adminCredential.text.trim();
    final primaryCountryCode = _primaryCountryCode.trim();
    final secondaryCountryCode = _secondaryCountryCode.trim();
    final resetPassword = reset_password_value;

    // final
    print('isEdit $isEdit');
    try {
      print('isEdit $isEdit');
      final response = isEdit
          ? await ref.read(bomProvider.notifier).editConsultancy(
              widget.consultancy!['id'],
              consultancyName,
              consultancyId,
              uenNumber,
              fullAddress,
              showInputAddress,
              primaryContactPerson,
              primaryMobileNumber,
              primaryEmailAddress,
              secondaryContactPerson,
              secondaryMobileNumber,
              secondaryEmailAddress,
              selectedConsultancyType!,
              selectedConsultancyStatus!,
              licenseStartDate.toString(),
              licenseEndDate.toString(),
              licenseNumber,
              selectedFeeStructure!,
              selectedLastPaidStatus!,
              adminCredential,
              primaryCountryCode,
              secondaryCountryCode,
              resetPassword,
              userId,
              _selectedImage!,
              token!)
          : await ref.read(bomProvider.notifier).addConsultancy(
              consultancyName,
              consultancyId,
              uenNumber,
              fullAddress,
              showInputAddress,
              primaryContactPerson,
              primaryMobileNumber,
              primaryEmailAddress,
              secondaryContactPerson,
              secondaryMobileNumber,
              secondaryEmailAddress,
              selectedConsultancyType!,
              selectedConsultancyStatus!,
              licenseStartDate.toString(),
              licenseEndDate.toString(),
              licenseNumber,
              selectedFeeStructure!,
              selectedLastPaidStatus!,
              adminCredential,
              primaryCountryCode,
              secondaryCountryCode,
              resetPassword,
              userId,
              _selectedImage!,
              token!);

      if (!mounted) return;

      final dynamic status = response['status'];

      print('status $status');

      if (status == "success") {
        context.pop(true);

        //  Show success toast
        ToastHelper.showSuccess(context,
            response['message'] ?? 'Consultancy created successfully!');
      } else if (status == true) {
        context.pop(true);

        //  Show success toast
        ToastHelper.showSuccess(
            context, response['message'] ?? 'Consultancy update successfully!');
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
    print('_selectedImage $_selectedFeeStructure');
    final isLoading = ref.watch(bomProvider).isLoading;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showBackButton: false,
        image: 'assets/images/bom/bom_logo.png',
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeaderContent(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          _buildSectionTitle('General & Contact Information',
                              const Color(0xffFF1901), FontWeight.w700),
                          const SizedBox(height: 12),
                          CustomTextField(
                            keyboardType: TextInputType.name,
                            padding: 0,
                            borderRadius: 8,
                            label: 'Consultancy Name *',
                            hintText: 'Consultancy Name *',
                            controller: _consultancyName,
                            validator: validateConsultancyName,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Consultancy ID *',
                            hintText: 'Consultancy ID *',
                            controller: _consultancyId,
                            validator: validateConsultancyId,
                            textCapitalization: TextCapitalization.none,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                              padding: 0,
                              borderRadius: 8,
                              label: 'UEN Number *',
                              hintText: 'UEN Number *',
                              controller: _uenNumber,
                              validator: validateUEN,
                              keyboardType: TextInputType.text,
                              textCapitalization:
                                  TextCapitalization.characters),
                          const SizedBox(height: 12),
                          _confirmedAddress != null && _confirmedAddress != ''
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
                                          height: 30,
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
                                    padding: const EdgeInsets.all(12),
                                    child: const Text(''),
                                  ),
                                ),
                          const SizedBox(height: 15),
                          const Divider(color: Color(0xffA6A9B5)),
                          const SizedBox(height: 15),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Primary Contact Person',
                            hintText: 'Primary Contact Person',
                            controller: _primaryContactPerson,
                            validator: validateContactPerson,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 12),
                          CountryCodePhoneField(
                            controller: _primaryMobileNumber,
                            onCountryCodeChanged: (code) {
                              print("Selected country code: $code");
                            },
                            validator: validatePhoneNumber,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Primary Email Address *',
                            hintText: 'Primary Email Address *',
                            controller: _primaryEmailAddress,
                            validator: validateEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 15),
                          const Divider(color: Color(0xffA6A9B5)),
                          const SizedBox(height: 15),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Secondary Contact Person',
                            hintText: 'Secondary Contact Person',
                            controller: _secondaryContactPerson,
                            validator: validateContactPerson,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Secondary Email Address',
                            hintText: 'Secondary Email Address',
                            controller: _secondaryEmailAddress,
                            validator: validateEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          CountryCodePhoneField(
                            controller: _secondaryMobileNumber,
                            onCountryCodeChanged: (code) {
                              print("Selected country code: $code");
                            },
                            validator: validatePhoneNumber,
                          ),
                          const SizedBox(height: 15),
                          const Divider(color: Color(0xffA6A9B5)),
                          const SizedBox(height: 15),
                          // CustomDropdownField(
                          //   borderRadius: 8,
                          //   label: "Consultancy Type",
                          //   items: _consultancyType.map((e) => e['label']!).toList(),
                          //   value: _consultancyType.firstWhere(
                          //         (element) => element['value'] == _selectedConsultancyType,
                          //     orElse: () => _consultancyType[0],
                          //   )['label'],
                          //   onChanged: (label) {
                          //     final selectedMap = _consultancyType.firstWhere(
                          //           (element) => element['label'] == label,
                          //       orElse: () => _consultancyType[0],
                          //     );
                          //
                          //     setState(() {
                          //       _selectedConsultancyType = selectedMap['value'];
                          //     });
                          //   },
                          // ),

                          const SizedBox(height: 12),
                          CustomDropdownField(
                            borderRadius: 8,
                            label: "Consultancy Status",
                            items: _consultancyStatus,
                            value: _selectedConsultancyStatus,
                            onChanged: (value) {
                              setState(() {
                                _selectedConsultancyStatus = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          CurrencyPickerField(
                            controller: TextEditingController(),
                            initialCurrencyCode: "GBP",
                            onCurrencyChanged: (currencyCode) {
                              print('Selected currency: $currencyCode');
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter amount';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),
                          Row(

                            children: [
                              Expanded(
                                flex: _selectedImage != null ? 8 : 10,
                                child: GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    height: 45,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFFEDEDED)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/upload_icons.svg',
                                          height: 20,
                                          width: 20,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Upload Consultancy Logo',
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
                              ),
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
                              ]
                            ],
                          ),
                          const SizedBox(height: 25),
                          _buildSectionTitle('Subscription Information',
                              const Color(0xffFF1901), FontWeight.w700),
                          const SizedBox(height: 10),
                          _buildDateField('License Start Date',
                              _startDateController, validateLicenseStartDate),
                          const SizedBox(height: 12),
                          _buildDateField('License End Date',
                              _endDateController, validateLicenseEndDate),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'License Number',
                            hintText: 'License Number',
                            controller: _licenseNumber,
                            // validator: validateEmail,
                            validator: validateLicenseNumber,
                          ),
                          const SizedBox(height: 12),
                          Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              CustomRedButtonTextField(
                                label: "",
                                hintText: "Choose Subscription",
                                controller: TextEditingController(),
                                prefixIcon: SvgPicture.asset(
                                  'assets/icons/subscription.svg',
                                  width: 20,
                                  height: 20,
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => ChooseSubscriptionDialog(
                                      controller: _subscriptionController, // ✅ Dotted box controller
                                    ),
                                  ).whenComplete(() {
                                    setState(() {}); // Update dotted box
                                  });
                                },
                              ),


                              const SizedBox(height: 12),

                              // 🟦 Dotted Box showing selected plan
                              DottedBorder(
                                borderType: BorderType.RRect,
                                radius: const Radius.circular(8),
                                dashPattern: const [6, 4],
                                color: const Color(0xffA8B9CA),
                                strokeWidth: 1.5,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    _subscriptionController.text.isNotEmpty
                                        ? _subscriptionController.text
                                        : 'Selected Plan will appear here',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // CustomDropdownField(
                          //   borderRadius: 8,
                          //   label: "Fees Structure",
                          //   items: _feeStructure,
                          //   value: _selectedFeeStructure,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _selectedFeeStructure = value;
                          //     });
                          //   },
                          // ),
                          const SizedBox(height: 12),
                          // CustomDropdownField(
                          //   borderRadius: 8,
                          //   label: "Last Paid Status",
                          //   items: _lastPaidStatus,
                          //   value: _selectedLastPaidStatus,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _selectedLastPaidStatus = value;
                          //     });
                          //   },
                          // ),
                          const SizedBox(height: 12),
                          // Row(
                          //   // mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //     _buildSectionTitle(
                          //       'Last Paid Date / Payment mode :   --',
                          //       const Color(0xff828282),
                          //       FontWeight.w500,
                          //     ),
                          //     SvgPicture.asset('assets/icons/info_icon.svg'),
                          //   ],
                          // ),
                          const SizedBox(height: 25),
                          _buildSectionTitle('Admin Credentials',
                              const Color(0xffFF1901), FontWeight.w700),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'User Id / Email *',
                            hintText: 'User Id / Email *',
                            controller: _adminCredential,
                            // validator: validateEmail,
                            validator: validateUserIdOrEmail,
                          ),
                          const SizedBox(height: 12),
                        if (isEdit) ...[
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
                          )],
                          const SizedBox(height: 30),
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
            fontSize: 12,
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
            padding: 10,
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
              print(
                  'Start date: ${_startDateController.text} ${_endDateController.text}');
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child:
                        SvgPicture.asset('assets/icons/back.svg', height: 15)),
                const SizedBox(width: 35),
                CustomButton(
                  leftPadding: 2,
                  text: isEdit ? 'Update' : 'Save',
                  width: 75,
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
                  text: 'Clear',
                  width: 75,
                  height: 36,
                  borderRadius: 6,
                  onPressed: () {
                    setState(() {
                      // Clear text controllers
                      _consultancyName.clear();
                      _consultancyId.clear();
                      _uenNumber.clear();
                      _primaryContactPerson.clear();
                      _primaryMobileNumber.clear();
                      _primaryEmailAddress.clear();
                      _secondaryContactPerson.clear();
                      _secondaryEmailAddress.clear();
                      _secondaryMobileNumber.clear();
                      _startDateController.clear();
                      _endDateController.clear();
                      _licenseNumber.clear();
                      _adminCredential.clear();

                      // Reset variables
                      _confirmedAddress = '';
                      _primaryCountryCode = '';
                      _secondaryCountryCode = '';
                      _selectedConsultancyStatus = '';
                      _selectedConsultancyType = '';
                      _selectedLastPaidStatus = '';
                      _selectedFeeStructure = '';
                      _lastPaidDate = '';
                      _paymentMode = '';
                    });
                  },
                  isOutlined: true,
                  svgAsset: 'assets/icons/clear_icon.svg',
                ),
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
  }
