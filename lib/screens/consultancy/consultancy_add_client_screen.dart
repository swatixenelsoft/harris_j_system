import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:harris_j_system/providers/consultancy_provider.dart';
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

class ConsultancyAddClientScreen extends ConsumerStatefulWidget {
  const ConsultancyAddClientScreen({super.key, this.client});

  final Map<String, dynamic>? client;

  @override
  ConsumerState<ConsultancyAddClientScreen> createState() =>
      _ConsultancyAddClientScreenState();
}

class _ConsultancyAddClientScreenState
    extends ConsumerState<ConsultancyAddClientScreen> {
  String _primaryCountryCode = ''; // Default country code
  String _secondaryCountryCode = ''; // Default country code
  final TextEditingController _servingClient = TextEditingController();
  final TextEditingController _clientId = TextEditingController();
  final TextEditingController _primaryContactPerson = TextEditingController();
  final TextEditingController _primaryMobileNumber = TextEditingController();
  final TextEditingController _primaryEmail = TextEditingController();
  final TextEditingController _secondaryContactPerson = TextEditingController();
  final TextEditingController _secondaryMobileNumber = TextEditingController();
  final TextEditingController _secondaryEmail = TextEditingController();
  final TextEditingController _description = TextEditingController();

  String? _selectedClientStatus = 'Not Selected';

  final List<String> _clientStatus = [
    'Not Selected',
    'Active',
    'Disable',
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic _confirmedAddress;
  bool get isEdit => widget.client != null;

  String? token;

  @override
  void initState() {
    super.initState();
    print('isEdit $isEdit,${widget.client}');
    if (isEdit) {
      _servingClient.text = widget.client?['serving_client'] ?? '';
      _clientId.text = widget.client?['client_id']?.toString() ?? '';
      _primaryContactPerson.text = widget.client?['primary_contact'] ?? '';
      _primaryMobileNumber.text = widget.client?['primary_mobile'] ?? '';
      _primaryEmail.text = widget.client?['primary_email'] ?? '';
      _secondaryContactPerson.text = widget.client?['secondary_contact'] ?? '';
      _secondaryMobileNumber.text = widget.client?['secondary_mobile'] ?? '';
      _secondaryEmail.text = widget.client?['secondary_email'] ?? '';
      _description.text = widget.client?['description'] ?? '';
      _confirmedAddress = widget.client?['show_address_input'] ?? '';
      _primaryCountryCode = widget.client?['primary_mobile_country_code'] ?? '';
      _secondaryCountryCode =
          widget.client?['secondary_mobile_country_code'] ?? '';
      _selectedClientStatus = widget.client?['client_status'] ?? 'Not Selected';
    }
  }

  @override
  void dispose() {
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
    print('showaddress $address');
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
    }
  }

  String? validateClientId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Client Id';
    }

    final validIdRegex = RegExp(r'^[a-zA-Z0-9_-]{4,20}$');
    if (!validIdRegex.hasMatch(value.trim())) {
      return 'Client Id must be 4–20 characters and can contain letters, numbers, - or _';
    }

    return null;
  }

  String? validateServingClient(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter serving name';
    }

    final validNameRegex = RegExp(r"^[a-zA-Z0-9 .'-]+$");
    if (!validNameRegex.hasMatch(value.trim())) {
      return 'Only letters, numbers, spaces, dots, apostrophes, and hyphens are allowed';
    }

    return null;
  }

  String? validatePrimaryContactPerson(String? value) {
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

  String? validateSecondaryContactPerson(String? value) {
    if (value == null || value.trim().isEmpty) {
      // Field is optional — return null if empty
      return null;
    }

    final name = value.trim();
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$'); // Only letters and spaces

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

  String? validateSecondaryEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
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

  String? validateClientStatus(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a client status';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a description';
    }
    // if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
    //   return 'Description must be numeric only';
    // }
    return null;
  }

  void _submitForm() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userId')!;
    final token = prefs.getString('token');
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final servingClient = _servingClient.text.trim();
    final clientId = _clientId.text.trim();
    final primaryContactPerson = _primaryContactPerson.text.trim();
    final primaryMobileNumber = _primaryMobileNumber.text.trim();
    final primaryEmail = _primaryEmail.text.trim();
    final secondaryContactPerson = _secondaryContactPerson.text.trim();
    final secondaryMobileNumber = _secondaryMobileNumber.text.trim();
    final secondaryEmail = _secondaryEmail.text.trim();
    final description = _description.text.trim();
    final primaryCountryCode = _primaryCountryCode;
    final secondaryCountryCode = _secondaryCountryCode;
    final selectedClientStatus = _selectedClientStatus;

    final fullAddress = isEdit
        ? widget.client!['full_address']
        : "streetName: ${_confirmedAddress!['apartmentName']},city: ${_confirmedAddress!['state']},country: ${_confirmedAddress!['country']},postalCode: ${_confirmedAddress!['postalCode']}";
    final showInputAddress = isEdit
        ? _confirmedAddress
        : "${_confirmedAddress!['apartmentName']},${_confirmedAddress!['state']},${_confirmedAddress!['country']}";

    try {
      ref.read(consultancyProvider.notifier).setLoading(true); // 🔵 Start loading

      final response = isEdit
          ? await ref.read(consultancyProvider.notifier).editClient(
        servingClient,
        clientId,
        primaryContactPerson,
        primaryMobileNumber,
        primaryEmail,
        secondaryContactPerson,
        secondaryMobileNumber,
        secondaryEmail,
        fullAddress,
        description,
        showInputAddress,
        selectedClientStatus!,
        primaryCountryCode,
        secondaryCountryCode,
        token!,
        widget.client!['id'].toString(),
      )
          : await ref.read(consultancyProvider.notifier).addClient(
        servingClient,
        clientId,
        primaryContactPerson,
        primaryMobileNumber,
        primaryEmail,
        secondaryContactPerson,
        secondaryMobileNumber,
        secondaryEmail,
        fullAddress,
        description,
        showInputAddress,
        selectedClientStatus!,
        primaryCountryCode,
        secondaryCountryCode,
        token!,
      );

      if (!mounted) return;

      final dynamic status = response['status'];

      if (status == true) {
        context.pop(true);
        ToastHelper.showSuccess(context, response['message'] ?? (isEdit ? 'Client updated successfully!' : 'Client created successfully!'));
      } else {
        ToastHelper.showError(context, response['message'] ?? 'Failed to submit.');
      }
    } catch (e) {
      if (!mounted) return;
      print('Submit error: $e');
      ToastHelper.showError(context, 'Something went wrong. Please try again.');
    } finally {
      ref.read(consultancyProvider.notifier).setLoading(false); // 🔴 Stop loading
    }
  }


  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(consultancyProvider.select((s) => s.isLoading));

    print('isLoading $isLoading');
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
                            label: 'Serving Client *',
                            hintText: 'Serving Client *',
                            controller: _servingClient,
                            validator: validateServingClient,
                            textCapitalization: TextCapitalization.words,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Client ID *',
                            hintText: 'Client ID *',
                            controller: _clientId,
                            validator: validateClientId,
                            textCapitalization: TextCapitalization.none,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Primary Contact Person *',
                            hintText: 'Primary Contact Person *',
                            controller: _primaryContactPerson,
                            validator: validatePrimaryContactPerson,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          CountryCodePhoneField(
                            controller: _primaryMobileNumber,
                            onCountryCodeChanged: (code) {
                              _primaryCountryCode = code;
                            },
                            validator: validatePhoneNumber,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Primary Email Address *',
                            hintText: 'Primary Email Address *',
                            controller: _primaryEmail,
                            validator: validateEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Secondary Contact Person',
                            hintText: 'Secondary Contact Person',
                            controller: _secondaryContactPerson,
                            validator: validateSecondaryContactPerson,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          CountryCodePhoneField(
                            controller: _secondaryMobileNumber,
                            onCountryCodeChanged: (code) {
                              print("Selected country code: $code");
                              _secondaryCountryCode = code;
                            },
                            validator: validatePhoneNumber,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Secondary Email Address',
                            hintText: 'Secondary Email Address',
                            controller: _secondaryEmail,
                            validator: validateSecondaryEmail,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          _confirmedAddress != null
                              ? Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
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
                                                        widget.client![
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
                            label: "Client Status",
                            items: _clientStatus,
                            value: _selectedClientStatus,
                            onChanged: (value) {
                              _selectedClientStatus = value;
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            padding: 0,
                            borderRadius: 8,
                            label: 'Description',
                            hintText: 'Description',
                            maxLines: 6,
                            controller: _description,
                            keyboardType: TextInputType.text,
                            validator: validateDescription,
                          ),
                          const SizedBox(height: 25),
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
                  isEdit ? 'Edit Client' : 'Add Client',
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
                      widget.client?['full_address'] ?? null,
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
