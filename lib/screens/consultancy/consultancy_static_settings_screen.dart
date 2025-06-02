import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/consultancy/add_lookup_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_app_setting_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_holiday_management_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_roles_privilages_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_system_properties_screen.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/custom_phone_number_field.dart';
import 'package:intl/intl.dart';

class ConsultancySettingsScreen extends StatefulWidget {
  const ConsultancySettingsScreen({Key? key}) : super(key: key);

  @override
  _ConsultancySettingsScreenState createState() => _ConsultancySettingsScreenState();
}

class _ConsultancySettingsScreenState extends State<ConsultancySettingsScreen> {
  DateTime? _licenseStartDate;
  DateTime? _licenseEndDate;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  String _consultancyType = 'Information technology consulting';
  String _consultancyStatus = 'Active';
  String _feesStructure = '3 Months';
  String _lastPaidStatus = 'Paid';
  String _licenseNumber = 'LIC0923899NUM89233299';
  String _lastPaidDatePaymentMode = 'Card';
  String _useridemail = 'samjhon@gmail.com';
  String _password = '88888888888';
  bool _isPasswordVisible = false;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _startDateController.text = '12/09/2024';
    _endDateController.text = '12/09/2025';
    _passwordController.text = _password;
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _passwordController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(
          showBackButton: false,
          image: 'assets/images/bom/bom_logo.png',
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Header and search bar container
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  border: Border.all(color: const Color(0xffE8E8E8)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            'assets/icons/back.svg',
                            width: 31,
                            height: 18,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Text(
                          'Settings',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFFF1901),
                          ),
                        ),
                        const Spacer(),
                        if (_currentTabIndex == 2)
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF1901),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AddLookupPopup(),
                                );
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/circle.svg',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Add Lookup',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: 'montserrat',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (_currentTabIndex == 4)
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF1901),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AddLookupPopup(),
                                );
                              },
                              child: const Text(
                                'Edit/Update',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Search',
                      hintText: 'Search',
                      controller: _searchController,
                      readOnly: false,
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      borderRadius: 12,
                      useUnderlineBorder: false,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
              const Divider(height: 0.5, color: Color.fromRGBO(141, 145, 160, 0.4)),
              // TabBar
              TabBar(
                labelColor: const Color(0xFFFF1901),
                unselectedLabelColor: Colors.grey,
                indicator: const BoxDecoration(),
                dividerColor: Colors.transparent,
                dividerHeight: 0,
                isScrollable: true,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                onTap: (index) {
                  setState(() {
                    _currentTabIndex = index;
                  });
                },
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/icons/consultancy_house.png",
                          width: 18,
                          height: 18,
                          color: _currentTabIndex == 0 ? const Color(0xFFFF1901) : const Color(0xFF8D91A0),
                        ),
                        const SizedBox(width: 6),
                        Text("Consultancy", style: GoogleFonts.montserrat()),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/icons/holiday_house.png",
                          width: 18,
                          height: 18,
                          color: _currentTabIndex == 1 ? const Color(0xFFFF1901) : const Color(0xFF8D91A0),
                        ),
                        const SizedBox(width: 6),
                        Text("Holiday Management", style: GoogleFonts.montserrat()),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/icons/system_properties.png",
                          width: 18,
                          height: 18,
                          color: _currentTabIndex == 2 ? const Color(0xFFFF1901) : const Color(0xFF8D91A0),
                        ),
                        const SizedBox(width: 6),
                        Text("System Properties", style: GoogleFonts.montserrat()),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/icons/roles.png",
                          width: 18,
                          height: 18,
                          color: _currentTabIndex == 3 ? const Color(0xFFFF1901) : const Color(0xFF8D91A0),
                        ),
                        const SizedBox(width: 6),
                        Text("Roles & Privileges", style: GoogleFonts.montserrat()),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/icons/app_setting.png",
                          width: 18,
                          height: 18,
                          color: _currentTabIndex == 4 ? const Color(0xFFFF1901) : const Color(0xFF8D91A0),
                        ),
                        const SizedBox(width: 6),
                        Text("App Setting", style: GoogleFonts.montserrat()),
                      ],
                    ),
                  ),
                ],
              ),
              // TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    buildConsultancyForm(),
                    const HolidayManagementScreen(),
                    const HolidayPropertyScreen(),
                    const DesignationRoleScreen(),
                    const AppSettingsScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildConsultancyForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General & Contact Information',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: const Color(0xFFFF1901),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFFF1901)),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('Consultancy Name *', 'New Consultancy', readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('Consultancy ID *', 'con09928id', readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('UEN Number *', 'U90340E892398N', readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: SizedBox(
              width: double.infinity,
              height: 80,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Design Avenue, #765, AV Super Mall (Near)',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Singapore - 569933',
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFEAEA),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        '📍 Default',
                        style: GoogleFonts.montserrat(
                          color: Color(0xFFFF1901),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Consultancy Logo *',
                style: GoogleFonts.montserrat(color: Color.fromRGBO(134, 135, 156, 1)),
              ),
              const SizedBox(height: 8),
              Opacity(
                opacity: 0.4,
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Image.asset(
                      'assets/icons/Logo_Consultancy.png',
                      fit: BoxFit.contain,
                      height: 43,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('Primary Contact Person', 'sam jhon', readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildPhoneField('Mobile Number *', '+6567878987', readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('Primary Email Address *', 'samjhon@gmail.com', readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('Secondary Contact Person', 'Jeo', readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildPhoneField('Mobile Number', '+6578765656', readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('Secondary Email Address *', 'jeo@gmail.com', readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildDropdownField('Consultancy Type', _consultancyType, [
              'Information technology consulting',
              'Management Consulting',
              'Financial Consulting',
            ], (newValue) {
              setState(() {
                _consultancyType = newValue!;
              });
            }),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildDropdownField('Consultancy Status', _consultancyStatus, [
              'Active',
              'Inactive',
              'Pending',
            ], (newValue) {
              setState(() {
                _consultancyStatus = newValue!;
              });
            }),
          ),
          const SizedBox(height: 30),
          _buildSectionTitle('Subscription Information'),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildDateField('License Start Date *', _startDateController, true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildDateField('License End Date *', _endDateController, false),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('License Number *', _licenseNumber, readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildDropdownField('Fees Structure *', _feesStructure, [
              '1 Month',
              '3 Months',
              '6 Months',
              '1 Year',
            ], (newValue) {
              setState(() {
                _feesStructure = newValue!;
              });
            }),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildDropdownField('Last Paid Status', _lastPaidStatus, [
              'Paid',
              'Pending',
              'Overdue',
            ], (newValue) {
              setState(() {
                _lastPaidStatus = newValue!;
              });
            }),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Last Paid Date / Payment mode:',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _lastPaidDatePaymentMode,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _buildSectionTitle('Admin Credentials'),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('User Id / Email *', _useridemail, readOnly: true),
          ),
          const SizedBox(height: 16),
          buildTextField(
            'Password *',
            _password,
            isPassword: !_isPasswordVisible,
            controller: _passwordController,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFF1901),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        const Divider(color: Color(0xFFFF1901)),
      ],
    );
  }

  Widget buildTextField(
      String label,
      String initialValue, {
        bool isPassword = false,
        bool readOnly = false,
        TextEditingController? controller,
        Widget? suffixIcon,
      }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: CustomTextField(
        label: label,
        hintText: initialValue,
        controller: controller ?? TextEditingController(text: initialValue),
        isPassword: isPassword,
        readOnly: readOnly,
        suffixIcon: suffixIcon,
        borderRadius: 10,
        useUnderlineBorder: false,
        keyboardType: label.contains('Email') ? TextInputType.emailAddress : TextInputType.text,
      ),
    );
  }

  Widget buildPhoneField(String label, String initialValue, {bool readOnly = false}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: CustomPhoneNumberField(
        controller: TextEditingController(text: initialValue.replaceAll('+', '')),
        onChanged: readOnly ? null : (value) {},
        onCountryChanged: (code) {},
      ),
    );
  }

  Widget buildDateField(String label, TextEditingController controller, bool isStartDate) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 60,
            child: CustomTextField(
              label: label,
              hintText: controller.text.isEmpty ? 'DD/MM/YYYY' : controller.text,
              controller: controller,
              readOnly: true,
              prefixIcon: const Icon(
                Icons.calendar_today,
                color: Colors.grey,
                size: 20,
              ),
              borderRadius: 10,
              useUnderlineBorder: false,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    controller.text = _dateFormat.format(pickedDate);
                    if (isStartDate) {
                      _licenseStartDate = pickedDate;
                    } else {
                      _licenseEndDate = pickedDate;
                    }
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: CustomDropdownField(
        label: label,
        items: items,
        value: value,
        onChanged: onChanged,
        borderColor: 0xff8991A3,
        borderRadius: 10,
      ),
    );
  }
}