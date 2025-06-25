import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/country_provider.dart';
import 'package:harris_j_system/services/api_service.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAddressBottomSheet extends ConsumerStatefulWidget {
  const AddAddressBottomSheet({super.key, this.address});

  final String? address;

  @override
  ConsumerState<AddAddressBottomSheet> createState() =>
      _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends ConsumerState<AddAddressBottomSheet> {
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _apartmentNameController =
      TextEditingController();
  final TextEditingController _unitNumberController = TextEditingController();
  final TextEditingController _landMarkController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _googleCodeController = TextEditingController();
  String? _selectedAddressType = 'Not Selected';
  String? _selectedCountry = 'Not Selected';
  String? _selectedState = 'Not Selected';
  bool _isSubmitted = false;
  bool _isVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool get isEdit => widget.address != null;

  final List<String> _addressType = [
    'Not Selected',
    'Home',
    'Office',
    'Billing',
    'Shipping',
    'Other'
  ];
  String? token;

  @override
  void initState() {
    print('isEdid');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('isEdit $isEdit');
      fetchData();
    });
  }

  fetchData() async {
    await _getCountryData();

    if (isEdit) {
      await _editData();
    }
  }

  _editData() async {
    print('isEdit');
    final Map<String, String> addressMap = {
      for (var part in widget.address!.split(','))
        part.split(':')[0].trim(): part.split(':')[1].trim()
    };

    _selectedCountry = addressMap['country'] ?? '';
    _postalCodeController.text = addressMap['postalCode'] ?? '';

    _apartmentNameController.text = addressMap['streetName'] ?? '';
    print('_apartmentNameController ${_apartmentNameController.text}');
    await ref
        .read(getCountryProvider.notifier)
        .fetchStates(_selectedCountry!, token!);
    _isVisible = true;
    _selectedState = addressMap['city'] ?? '';
// Now you can access values like:
    print(addressMap['streetName']); // fft
    print(addressMap['city']); // Badghis
    print(addressMap['country']); // Afghanistan
    print(addressMap['postalCode']);
  }

  Future<void> _getCountryData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print('token $token');
    await ref.read(getCountryProvider.notifier).fetchCountries(token!);
  }

  void _submitForm() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isVisible = true;
    });
  }

  String? validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Postal code is required';
    }

    final postalCodePattern =
        RegExp(r'^\d{4,10}$'); // only digits, 4–10 in length
    if (!postalCodePattern.hasMatch(value.trim())) {
      return 'Enter a valid postal code';
    }

    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    // Optional: prevent only numbers or special characters
    final regex = RegExp(r"^[a-zA-Z0-9\s,.\-'/#&]+$");
    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid apartment/street name';
    }

    if (value.trim().length < 3) {
      return 'Must be at least 3 characters';
    }

    return null;
  }

  String? validateUnitNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field – skip validation if empty
    }

    final unitNumberRegex = RegExp(r'^[a-zA-Z0-9\-\/]+$');

    if (!unitNumberRegex.hasMatch(value.trim())) {
      return 'Enter a valid unit number (e.g. 12A, 3/2, 5-1)';
    }

    return null;
  }

  String? validateLandmark(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    final trimmed = value.trim();

    if (trimmed.length < 3) {
      return 'Landmark must be at least 3 characters long';
    }

    final landmarkRegex = RegExp(r'^[a-zA-Z0-9\s,.\-]+$');

    if (!landmarkRegex.hasMatch(trimmed)) {
      return 'Enter a valid landmark (letters, numbers, ., , and - only)';
    }

    return null;
  }

  String? validateTownOrArea(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Town/Area is required';
    }

    final regex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid town or area name';
    }

    if (value.trim().length < 2) {
      return 'Town/Area must be at least 2 characters';
    }

    return null;
  }

  String? validateCityOrDistrict(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City/District is required';
    }

    final regex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!regex.hasMatch(value.trim())) {
      return 'Enter a valid city or district name';
    }

    if (value.trim().length < 2) {
      return 'City/District must be at least 2 characters';
    }

    return null;
  }

  String? validatePlusCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Don't validate if the field is empty
    }

    final trimmed = value.trim().toUpperCase();

    // Match full Plus Codes like 7FG8V4W3+GQ or short codes like 4W3+GQ
    final plusCodeRegex =
        RegExp(r'^[23456789CFGHJMPQRVWX]{4,8}\+[23456789CFGHJMPQRVWX]{2,3}$');

    if (!plusCodeRegex.hasMatch(trimmed)) {
      return 'Enter a valid Plus Code (e.g. 7FG8V4W3+GQ)';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final countryState = ref.watch(getCountryProvider);
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/location_marker.svg',
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Add Address",
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFFFF1901),
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child:
                            Image.asset('assets/icons/close.png', height: 25),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Address Information",
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF1901),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomDropdownField(
                  borderRadius: 8,
                  label: "Address Type",
                  items: _addressType,
                  value: _selectedAddressType,
                  onChanged: (value) {
                    setState(() {
                      _selectedAddressType = value;
                    });
                  },
                  errorText:
                      _isSubmitted && _selectedAddressType == "Not Selected"
                          ? "Address Type is required"
                          : null,
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  color: Color(0xffA6A9B5),
                  thickness: 1.0,
                  indent: 0.0,
                  endIndent: 0.0,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomDropdownField(
                  borderRadius: 8,
                  label: "Country *",
                  items: ["Not Selected", ...?countryState.countryList] ?? [],
                  value: _selectedCountry,
                  onChanged: (value) async {
                    setState(() {
                      _selectedCountry = value;
                      _selectedState = "Not Selected";
                    });
                    await ref
                        .read(getCountryProvider.notifier)
                        .fetchStates(_selectedCountry!, token!);
                  },
                  errorText: _isSubmitted && _selectedCountry == "Not Selected"
                      ? "Country is required"
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                padding: 10,
                borderRadius: 8,
                label: 'Postal Code *',
                hintText: 'Postal Code *',
                controller: _postalCodeController,
                validator: validatePostalCode,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                padding: 10,
                borderRadius: 8,
                label: 'Apartment Name / Street Name *',
                hintText: 'Apartment Name / Street Name *',
                controller: _apartmentNameController,
                validator: validateAddress,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 136,
                    child: CustomTextField(
                      padding: 10,
                      borderRadius: 8,
                      label: 'Unit Number',
                      hintText: 'Unit Number',
                      controller: _unitNumberController,
                      validator: validateUnitNumber,
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: CustomTextField(
                      padding: 10,
                      borderRadius: 8,
                      label: 'Land Mark',
                      hintText: 'Land Mark',
                      controller: _landMarkController,
                      validator: validateLandmark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CustomTextField(
                padding: 10,
                borderRadius: 8,
                label: 'Town / Area *',
                hintText: 'Town / Area *',
                controller: _townController,
                validator: validateTownOrArea,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                padding: 10,
                borderRadius: 8,
                label: 'City / District *',
                hintText: 'City / District *',
                controller: _cityController,
                validator: validateCityOrDistrict,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomDropdownField(
                  borderRadius: 8,
                  label: "State / Province  *",
                  items: ["Not Selected", ...?countryState.stateList] ?? [],
                  value: _selectedState,
                  onChanged: (value) {
                    setState(() {
                      _selectedState = value;
                    });
                  },
                  errorText: _isSubmitted && _selectedState == "Not Selected"
                      ? "State is required"
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                padding: 10,
                borderRadius: 8,
                label: 'Google map plus code',
                hintText: 'Google map plus code',
                controller: _googleCodeController,
                validator: validatePlusCode,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Address",
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF1901),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (_isVisible == true)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 110,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 70,
                          height: 35,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 150, 27, 0.3),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(12),
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
                                    color: const Color(0xffFF1901)),
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 5),
                        child: Text(
                            '${_apartmentNameController.text},${_unitNumberController.text},${_landMarkController.text},$_selectedState,$_selectedCountry-${_postalCodeController.text}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8),
                        child: Row(
                          children: [
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                  child: SvgPicture.asset(
                                'assets/icons/google_code.svg',
                                height: 15,
                                width: 15,
                                color: Colors.red,
                              )),
                            ),
                            Text(_googleCodeController.text),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                        text: 'Cancel',
                        onPressed: () {},
                        width: 110,
                        isOutlined: true),
                    CustomButton(
                        text: 'Save',
                        onPressed: () {
                          setState(() {
                            _isSubmitted = true; // Mark form as submitted
                          });
                          _submitForm();
                        },
                        width: 110),
                    CustomButton(
                      text: 'Confirm',
                      onPressed: () {
                        final confirmedData = {
                          'apartmentName': _apartmentNameController.text,
                          'unitNumber': _unitNumberController.text,
                          'landMark': _landMarkController.text,
                          'state': _selectedState,
                          'country': _selectedCountry,
                          'postalCode': _postalCodeController.text,
                          'googleCode': _googleCodeController.text,
                        };

                        Navigator.pop(context, confirmedData);
                      },
                      width: 110,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
