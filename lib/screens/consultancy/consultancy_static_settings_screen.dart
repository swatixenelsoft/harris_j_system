import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/consultancy/add_lookup_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_app_setting_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_holiday_management_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_roles_privilages_screen.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_system_properties_screen.dart';
import 'package:harris_j_system/ulits/common_function.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_country_picker_field.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_phone_number_field.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

import 'package:intl/intl.dart';

class ConsultancySettingsScreen extends StatefulWidget {
  const ConsultancySettingsScreen({Key? key}) : super(key: key);

  @override
  _ConsultancySettingsScreenState createState() =>
      _ConsultancySettingsScreenState();
}

class _ConsultancySettingsScreenState extends State<ConsultancySettingsScreen> {
  DateTime? _licenseStartDate;
  DateTime? _licenseEndDate;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _mobileNumber =
      TextEditingController(text: '9876543210');

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
  final List<Map<String, String>> tabs = [
    {
      "label": "Consultancy",
      "icon": "assets/icons/consultancy_house.png",
    },
    {
      "label": "Holiday Management",
      "icon": "assets/icons/holiday_house.png",
    },
    {
      "label": "System Properties",
      "icon": "assets/icons/system_properties.png",
    },
    {
      "label": "Roles & Privileges",
      "icon": "assets/icons/roles.png",
    },
  ];
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showBackButton: false,
        image: 'assets/icons/cons_logo.png',
      ),
      body: SafeArea(
          child: Column(
        children: [
          _buildHeaderContent(),
          Expanded(child: _buildTab()),
        ],
      )),
    );
  }

  Widget _buildHeaderContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        border: Border.all(color: const Color(0xffE8E8E8)),
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
                const SizedBox(width: 15),
                Text(
                  'Setting',
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffFF1901)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: "Search",
            hintText: "Search Consultant...",
            controller: _searchController,
            prefixIcon: Padding(
              padding:
                  const EdgeInsets.all(14.0), // optional padding for spacing
              child: SizedBox(
                height: 10,
                width: 10,
                child: SvgPicture.asset(
                  'assets/icons/search_icon.svg',
                ),
              ),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildTab() {
    return Column(
      children: [
        // Custom Scrollable TabBar
        Container(
          color: Colors.white,
          height: 40,
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            child: Row(
              children: List.generate(tabs.length, (index) {
                final tab = tabs[index];
                final isSelected = _currentTabIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentTabIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 13, right: 8),
                    height: 40,
                    child: Row(
                      children: [
                        Image.asset(
                          tab['icon']!,
                          width: 18,
                          height: 18,
                          color: isSelected
                              ? const Color(0xFFFF1901)
                              : const Color(0xFF8D91A0),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tab['label']!,
                          style: GoogleFonts.montserrat(
                            color: isSelected
                                ? const Color(0xFFFF1901)
                                : const Color(0xFF8D91A0),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Tab content
        Expanded(
          child: _buildTabContent(),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return buildConsultancyForm();
      case 1:
        return const HolidayManagementScreen();
      case 2:
        return const HolidayPropertyScreen();
      case 3:
        return const DesignationRoleScreen();
      case 4:
        return const AppSettingsScreen();
      default:
        return const Center(child: Text('No screen found.'));
    }
  }

  Widget buildConsultancyForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle( 'General & Contact Information',true),
          const SizedBox(height: 12),
          Opacity(
            opacity: 0.4,
            child: buildTextField('Consultancy Name *', 'New Consultancy',
                readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('Consultancy ID *', 'con09928id',
                readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('UEN Number *', 'U90340E892398N',
                readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: 80,
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Text(
                      'Design Avenue, #765, AV Super Mall (Near) Design Avenue, #765, AV Super Mall (Near)',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff1D212D),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Consultancy Logo *',
                style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: const Color.fromRGBO(134, 135, 156, 1)),
              ),
              const SizedBox(height: 8),
              Opacity(
                opacity: 0.4,
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
                  ),
                  child: Image.asset(
                    'assets/icons/Logo_Consultancy.png',
                    fit: BoxFit.contain,
                    height: 43,
                    width: 158,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('Primary Contact Person', 'sam jhon',
                readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: CountryCodePhoneField(
              controller: _mobileNumber,
              readOnly: true,
            ),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField(
                'Primary Email Address *', 'samjhon@gmail.com',
                readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('Secondary Contact Person', 'Jeo',
                readOnly: true),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: CountryCodePhoneField(
              controller: _mobileNumber,
              readOnly: true,
            ),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('Secondary Email Address *', 'jeo@gmail.com',
                readOnly: true),
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
            child:
                buildDropdownField('Consultancy Status', _consultancyStatus, [
              'Active',
              'Inactive',
              'Pending',
            ], (newValue) {
              setState(() {
                _consultancyStatus = newValue!;
              });
            }),
          ),
          const SizedBox(height: 20),
          _buildSectionTitle('Subscription Information',true),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: _buildDateField('License Start Date', _startDateController),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: _buildDateField('License End Date', _endDateController),
          ),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('License Number *', _licenseNumber,
                readOnly: true),
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
          const SizedBox(height: 8),
          Opacity(
            opacity: 0.4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildSectionTitle('Last Paid Date / Payment mode :Card',false),
                const SizedBox(width: 5),
                SvgPicture.asset('assets/icons/info_icon.svg'),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _buildSectionTitle('Admin Credentials',true),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.4,
            child: buildTextField('User Id / Email *', _useridemail,
                readOnly: true),
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

  Widget _buildSectionTitle(String title,bool redColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            color: redColor? const Color(0xFFFF1901):const Color(0xFF798AA3),
            fontSize: 13,
          ),
        ),
        const Divider(
            color: Color(
              0xFFFF1901,
            ),
            height: 3),
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
    return CustomTextField(
      label: label,
      hintText: initialValue,
      controller: controller ?? TextEditingController(text: initialValue),
      isPassword: isPassword,
      readOnly: readOnly,
      suffixIcon: suffixIcon,
      borderRadius: 10,
      useUnderlineBorder: false,
      keyboardType: label.contains('Email')
          ? TextInputType.emailAddress
          : TextInputType.text,
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
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
            padding: 10,
            borderRadius: 8,
            label: '',
            hintText: 'DD / MM / YYYY',
            controller: controller,
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

  Widget buildDropdownField(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return CustomDropdownField(
      label: label,
      items: items,
      value: value,
      onChanged: onChanged,
      borderColor: 0xff8991A3,
      borderRadius: 10,
    );
  }
}
