import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/services/api_service.dart';
import 'package:harris_j_system/ulits/common_function.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_phone_number_field.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasicInformationScreen extends ConsumerStatefulWidget {
  const BasicInformationScreen({super.key});

  @override
  ConsumerState<BasicInformationScreen> createState() =>
      _BasicInformationScreenState();
}

class _BasicInformationScreenState
    extends ConsumerState<BasicInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _primaryCountryCode = '+65';
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _citizenController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _resumeController = TextEditingController();

  String? _selectedCitizenType = 'Not Selected';
  String? _selectedNationalityType = 'Not Selected';
  String? _citizenError;
  String? _nationalityError;
  bool _isSubmitted = false;
  bool _isLoading = false;

  File? _selectedImage;
  File? _selectedResume;
  String? token;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBasicInfo();
    });
  }

  Future<void> getBasicInfo() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    final response = await ref.read(consultantProvider.notifier).getBasicInfo(token!);

    if (response['success'] == true) {
      final data = response['data'];

      if (data['dob'] != null && data['dob'].toString().isNotEmpty) {
        try {
          DateTime parsedDate = DateTime.parse(data['dob']);
          _dobController.text = DateFormat('dd/MM/yyyy').format(parsedDate);
        } catch (e) {
          _dobController.text = '';
        }
      } else {
        _dobController.text = '';
      }

      // Text Controllers
      _firstNameController.text = data['first_name'] ?? '';
      _middleNameController.text = data['middle_name'] ?? '';
      _lastNameController.text = data['last_name'] ?? '';
      _addressController.text = data['address_by_user'] ?? '';
      _contactNumberController.text = data['mobile_number'] ?? '';
      _citizenController.text = data['citizen'] ?? '';
      _nationalityController.text = data['nationality'] ?? '';
      _resumeController.text = data['resume_file'] != null
          ? data['resume_file'].toString().split('/').last
          : '';

      // Dropdown / selection variables
      // _selectedCitizenType = data['citizen'] ?? 'Not Selected';
      // _selectedNationalityType = data['nationality'] ?? 'Not Selected';

      // Files
      if (data['profile_image'] != null) {
        _selectedImage = File(data['profile_image']);
        // You might need to handle network image separately if this is just a path
      }

      if (data['resume_file'] != null) {
        _selectedResume = File(data['resume_file']);
        // Again, handle if it's a remote file (download or show name only)
      }

      setState(() {}); // Refresh UI
    }
  }


  // ✅ Name Validation
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'First name is required';
    }
    if (value.trim().length < 2) {
      return 'First name must be at least 2 characters';
    }
    if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value.trim())) {
      return 'Only alphabets allowed';
    }
    return null;
  }

  // ✅ Middle Name Validation
  String? _validateMiddleName(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      if (value.trim().length < 2) {
        return 'Middle name must be at least 2 characters';
      }
      if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value.trim())) {
        return 'Only alphabets allowed';
      }
    }
    return null;
  }

  // ✅ Last name Validation
  String? _validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Last name is required';
    }
    if (value.trim().length < 2) {
      return 'Last name must be at least 2 characters';
    }
    if (!RegExp(r"^[a-zA-Z]+$").hasMatch(value.trim())) {
      return 'Only alphabets allowed';
    }
    return null;
  }

  // ✅ Dob Validation
  String? _validateDob(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of Birth is required';
    }

    try {
      DateTime selectedDate = DateFormat('dd/MM/yyyy').parseStrict(value);
      DateTime now = DateTime.now();

      if (selectedDate.year == now.year &&
          selectedDate.month == now.month &&
          selectedDate.day == now.day) {
        return "You can't select today's date";
      }

      return null;
    } catch (e) {
      return 'Invalid date format';
    }
  }

  // ✅ Address Validation
  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    return null;
  }

  // ✅ Phone number Validation
  void _validateAndSubmit() async {
    final firstName = _firstNameController.text.trim();
    final middleName = _middleNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final dob = _dobController.text.trim();
    final selectedCitizen = _citizenController.text.trim();
    final selectedNationality = _nationalityController.text.trim();
    final address = _addressController.text.trim();
    final mobileNumber = _contactNumberController.text.trim();

    // 1️⃣ Validate form fields
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2️⃣ Check required files
    if (_selectedImage == null) {
      ToastHelper.showError(context, 'Please select a profile image');
      return;
    }

    if (_selectedResume == null) {
      ToastHelper.showError(context, 'Please upload a resume file');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 🔍 Debug print all values
    print('--- BASIC INFO FORM DATA ---');
    print('First Name: ${firstName.isEmpty ? "NULL" : firstName}');
    print('Middle Name: ${middleName.isEmpty ? "NULL" : middleName}');
    print('Last Name: ${lastName.isEmpty ? "NULL" : lastName}');
    print('DOB: ${dob.isEmpty ? "NULL" : dob}');
    print('Citizen: ${selectedCitizen.isEmpty ? "NULL" : selectedCitizen}');
    print('Nationality: ${selectedNationality.isEmpty ? "NULL" : selectedNationality}');
    print('Address: ${address.isEmpty ? "NULL" : address}');
    print('Mobile Number: ${mobileNumber.isEmpty ? "NULL" : mobileNumber}');
    print('Selected Image: $_selectedImage');
    print('Selected Resume: $_selectedResume');
    print('Token: ${token ?? "NULL"}');
    print('---------------------------');

    try {
      final response = await ref.read(consultantProvider.notifier).updateBasicInfo(
        firstName,
        middleName,
        lastName,
        dob,
        selectedCitizen,
        selectedNationality,
        address,
        mobileNumber,
        _selectedImage!,
        _selectedResume!,
        token!,
      );

      setState(() {
        _isLoading = false;
      });

      ToastHelper.showSuccess(context, 'Basic information updated successfully!');
      context.pushReplacement(Constant.consultantDashBoardScreen);

    } catch (e) {
      print('Error in updateBasicInfo: $e');
      setState(() {
        _isLoading = false;
      });
      ToastHelper.showError(context, 'Failed to update. Please try again.');
    }
  }



  String? _validateResume(String? value) {
    if (value == null || value.isEmpty) {
      return 'Resume upload is required';
    }
    return null;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _resumeController.text = result.files.single.name; // Display file name
        _selectedResume = File(result.files.single.path!); // Create File object
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: CustomLoader(color: Color(0xffFF1901)),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: CustomAppBar(
        image: 'assets/icons/cons_logo.png',
        showBackButton: true,
        showNotificationIcon: false,
        showProfileIcon: false,
        onBackPressed: () => Navigator.pop(context),
        onNotificationPressed: () {
          // Handle notification tap
        },
        onProfilePressed: () {
          // Handle profile tap
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Basic Information",
                  style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                const SizedBox(height: 5),
                Text(
                  "Please fill out following details to proceed further",
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                const SizedBox(height: 25),
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pickImage();
                        }, // Opens image picker when tapped
                        child: Container(
                          width: 91,
                          height: 91,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(
                                255, 25, 1, 0.1), // Light red background
                          ),
                          child: Center(
                            child: _selectedImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      _selectedImage!,
                                      width: 91,
                                      height: 91,
                                      fit: BoxFit
                                          .cover, // Ensures proper scaling
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/icons/upload_icons.svg',
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Upload Profile Image",
                        style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      if (_selectedImage == null)
                        Text(
                          "Image is required",
                          style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade900),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  label: 'First Name',
                  hintText: 'Enter first name',
                  controller: _firstNameController,
                  validator: _validateName,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: 'Middle Name',
                  hintText: 'Enter middle name',
                  controller: _middleNameController,
                  validator: _validateMiddleName,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: 'Last Name',
                  hintText: 'Enter last name',
                  controller: _lastNameController,
                  validator: _validateLastName,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: 'DOB',
                  hintText: 'Enter DOB',
                  controller: _dobController,
                  validator: _validateDob,
                  keyboardType: TextInputType.datetime,
                  textCapitalization: TextCapitalization.sentences,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  readOnly: true,
                  enableInteractiveSelection: false,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    CommonFunction().selectDate(context, _dobController);
                  },
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: 'Citizen',
                  hintText: 'Enter Citizen',
                  controller: _citizenController,
                  // validator: _validateLastName,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                ),
                // CustomDropdownField(
                //   label: "Citizen/SPR/EP",
                //   items: const ["Not Selected", "Citizen", "SPR", "EP"],
                //   value: _selectedCitizenType,
                //   onChanged: (value) {
                //     setState(() {
                //       _selectedCitizenType = value;
                //     });
                //   },
                //   errorText:
                //       _isSubmitted && _selectedCitizenType == "Not Selected"
                //           ? "Citizenship is required"
                //           : null,
                // ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: 'Nationality',
                  hintText: 'Enter nationality',
                  controller: _nationalityController,
                  // validator: _validateLastName,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.sentences,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                ),
                // CustomDropdownField(
                //   label: "Nationality",
                //   items: const [
                //     "Not Selected",
                //     "Indian",
                //     "American",
                //     "British",
                //     "Canadian"
                //   ],
                //   value: _selectedNationalityType,
                //   onChanged: (value) {
                //     setState(() {
                //       _selectedNationalityType = value;
                //     });
                //   },
                //   errorText:
                //       _isSubmitted && _selectedNationalityType == "Not Selected"
                //           ? "Nationality is required"
                //           : null,
                // ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: 'Address',
                  hintText: 'Enter address',
                  controller: _addressController,
                  validator: _validateAddress,
                  keyboardType: TextInputType.streetAddress,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 15),
                CustomPhoneNumberField(
                  controller: _contactNumberController,
                  onChanged: (number) {
                    print("Full Phone Number: $number");
                  },
                  onCountryChanged: (code) {
                    print("Selected Country Code: $code");
                  },
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  label: 'Resume',
                  hintText: 'Upload resume',
                  controller: _resumeController,
                  validator: _validateResume,
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.sentences,
                  readOnly: true,
                  enableInteractiveSelection: false,
                  suffixIcon: Padding(
                    padding:
                        const EdgeInsets.all(10), // Adjust padding as needed
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          'assets/icons/upload_icons.svg',
                          height: 20,
                          width: 20,
                          fit: BoxFit.contain, // Ensures proper scaling
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    _pickFile();
                  },
                ),
                const SizedBox(height: 50),
                CustomButton(
                  text: "SUBMIT",
                  onPressed: () {
                    setState(() {
                      _isSubmitted = true; // Mark form as submitted
                    });
                    _validateAndSubmit();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
