import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/static_system_provider.dart';
import 'package:harris_j_system/screens/consultancy/add_designation_screen.dart';
import 'package:harris_j_system/screens/consultancy/add_role_screen.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DesignationRoleScreen extends ConsumerStatefulWidget {
  const DesignationRoleScreen({super.key});

  @override
  ConsumerState<DesignationRoleScreen> createState() => _DesignationRoleScreenState();
}

class _DesignationRoleScreenState extends ConsumerState<DesignationRoleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final designations = ['Consultant', 'Operator', 'Human Resources', 'Finance'];
  String selectedDesignation = 'Consultant';

  final List<Map<String, dynamic>> roles = [
    {'role': 'Consultant', 'assigned': true},
    {'role': 'Human Resources', 'assigned': false},
    {'role': 'Operator', 'assigned': false},
    {'role': 'Finance', 'assigned': false},
  ];

  // State for the dropdown and privileges
  String? selectedRole = 'Human Resources';
  final List<Map<String, dynamic>> privileges = [
    {
      'module': 'Consultant',
      'view': false,
      'add': true,
      'edit': false,
      'delete': false,
      'print': false
    },
    {
      'module': 'Consultancy',
      'view': true,
      'add': true,
      'edit': true,
      'delete': false,
      'print': true
    },
    {
      'module': 'User',
      'view': true,
      'add': true,
      'edit': false,
      'delete': true,
      'print': false
    },
    {
      'module': 'System Property',
      'view': true,
      'add': true,
      'edit': true,
      'delete': false,
      'print': true
    },
    {
      'module': 'Timesheet Submission',
      'view': true,
      'add': true,
      'edit': false,
      'delete': false,
      'print': true
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    Future.microtask(() {
      getRoleDesignationList();
    });
  }

  getRoleDesignationList() async {
    ref.read(staticSettingProvider.notifier).setLoading(true);
    final prefs = await SharedPreferences.getInstance();
   final token = prefs.getString('token');
  final  userId = prefs.getInt('userId');

    await ref.read(staticSettingProvider.notifier).getDesignation(userId.toString(),token!);
    await ref.read(staticSettingProvider.notifier).getRole(userId.toString(),token);

    ref.read(staticSettingProvider.notifier).setLoading(false);
  }

  @override
  Widget build(BuildContext context) {

    final staticSettingState = ref.watch(staticSettingProvider);


    final isLoading = staticSettingState.isLoading;
    print('isLoading $isLoading');
    final designationList=staticSettingState.designationList;
    final roleList=staticSettingState.roleList;
    print('designationList $designationList,$roleList');

    return

      isLoading?
          CustomLoader(color: Colors.red)
          :
      Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: false,
          indicator: const BoxDecoration(),
          labelPadding: EdgeInsets.zero,
          dividerColor: Colors.transparent,
          tabs: [
            _buildTab("Designation & Role", 0),
            _buildTab("Privileges", 1),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 10),
                      child: _buildSectionHeader('Designation', onAdd: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => AddBottomSheet(
                            title: 'Add Designation',
                            label: 'Designation Name*',
                            hintText: 'Enter designation name',
                            tags: const ['HR', 'Manager', 'Assistant'],
                            onSubmit: (data) {
                              print('Designation: $data');
                              ToastHelper.showSuccess(context,
                                  data['message'] ?? 'Add successfully');
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: _buildDesignationList(designationList!),
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(height: 1, color: Color(0xFFFF1901)),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildSectionHeader('Roles', onAdd: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => AddBottomSheet(
                            title: 'Add Role',
                            label: 'Role Name*',
                            hintText: 'Enter role name',
                            tags: const ['Tag 1', 'Tag 2', 'Tag 3'],
                            onSubmit: (data) {
                              ToastHelper.showSuccess(context,
                                  data['message'] ?? 'Add successfully');
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                    _buildRolesTable(roleList!),
                  ],
                ),
              ),
              SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRoleDropdown(),
                    const SizedBox(height: 20),
                    _buildPrivilegesTable(),
                    const SizedBox(height: 16),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String title, int index) {
    final bool isSelected = _tabController.index == index;
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF1901) : const Color(0xffF2F2F2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
          vertical: 13, horizontal: 8), // Increased vertical padding
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 12, // Increased font size
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFFF1901),
          ),
        ),
        CustomButton(
          text: 'Add $title',
          onPressed: onAdd,
          svgAsset: 'assets/icons/add_icon.svg',
          height: 39,
          width: 125,
        )
      ],
    );
  }

  Widget _buildDesignationList(List designationList) {
    if (designationList.isEmpty) {
      return const Text("No designations found.");
    }

    return SizedBox(
      height: 4 * 54, // Approximate height for 4 items (adjust as needed)
      child: ListView.builder(
        itemCount: designationList.length,
        itemBuilder: (context, index) {
          final designation = designationList[index];
          final isSelected =
              designation['designation_name'] == selectedDesignation;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDesignation = designation['designation_name'];
              });
              print('designationedit $designation');
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => AddBottomSheet(
                  title: 'Edit Designation',
                  label: 'Designation Name*',
                  hintText: 'Enter designation name',
                  tags: const ['HR', 'Manager', 'Assistant'],
                  onSubmit: (data) {
                    print('Designation: $data');
                    ToastHelper.showSuccess(context,
                        data['message'] ?? 'Add successfully');
                  },
                ),
              );
              print('selectedDesignation $selectedDesignation, $isSelected');
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromRGBO(255, 150, 27, 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border:
                Border.all(color: const Color.fromRGBO(0, 0, 0, 0.25)),
              ),
              child: Text(
                designation['designation_name'],
                style: GoogleFonts.spaceGrotesk(
                  color: isSelected ? const Color(0xFFFF1901) : Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildRolesTable(List roleList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom table heading
        Container(
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: Color(0xFFFF1901),
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Application Role',
                  style: GoogleFonts.spaceGrotesk(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(
                width: 180,
                child: Text(
                  'Assign',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),

        // Scrollable list with max height showing 4 items
        SizedBox(
          height: 4 * 58, // assuming each item is ~58px tall including padding
          child: ListView.builder(
            itemCount: roleList.length,
            itemBuilder: (context, index) {
              final role = roleList[index];
              return Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffE4E4EF)),
                  ),
                ),
                padding: const EdgeInsets.only(
                    left: 15, right: 20, top: 12, bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        role['name'].toString(),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          color: const Color(0xff1D212D),
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Role',
          style: GoogleFonts.montserrat(
            color: const Color(0xffFF1901),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        const Divider(height: 1, color: Color(0xFFFF1901)),
        const SizedBox(height: 20),
        CustomDropdownField(
          label: 'Role *',
          items: roles.map((role) => role['role'] as String).toList(),
          value: selectedRole,
          onChanged: (value) {
            setState(() {
              selectedRole = value;
            });
          },
          errorText: null,
          borderColor: 0xffFF1901,
          borderRadius: 8,
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              'Selected Role : ',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            Text(
              selectedRole ?? '',
              style: GoogleFonts.montserrat(
                color: const Color(0xffFF1901),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/icons/green_badge.svg',
              height: 16,
              width: 16,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrivilegesTable() {
    // Sort privileges list: "Consultant" first, "Timesheet Submission" last
    final sortedPrivileges = List<Map<String, dynamic>>.from(privileges)
      ..sort((a, b) {
        if (a['module'] == 'Consultant') return -1;
        if (b['module'] == 'Consultant') return 1;
        if (a['module'] == 'Timesheet Submission') return 1;
        if (b['module'] == 'Timesheet Submission') return -1;
        return 0;
      });

    const double rowHeight = 56.0;
    const double headerHeight = 40.0;
    final ScrollController verticalScrollController = ScrollController();
    final ScrollController horizontalScrollController = ScrollController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Privileges',
          style: GoogleFonts.montserrat(
            color: const Color(0xFFFF1901),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        const Divider(height: 1, color: Color(0xFFFF1901)),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Module Names Column
            Column(
              children: [
                Container(
                  width: 160,
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDC143C),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        bottomLeft: Radius.circular(24)),
                  ),
                  child: Text(
                    'MODULE NAME',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  width: 160,
                  color: const Color(0xFFF2F2F2),
                  child: SingleChildScrollView(
                    controller: verticalScrollController,
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: sortedPrivileges.asMap().entries.map((entry) {
                        final privilege = entry.value;
                        return Container(
                          height: rowHeight,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              privilege['module'].toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: const Color(0xff1D212D),
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 3,
              color: Colors.white,
              height: headerHeight + (rowHeight * sortedPrivileges.length),
            ),
            // Permission Headers and Rows
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: horizontalScrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Permission Headers
                    Container(
                      height: headerHeight,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC143C),
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(8)),
                        border: Border(
                            bottom: BorderSide(color: Colors.white, width: 5)),
                      ),
                      child: Row(
                        children: [
                          _buildHeaderCell('VIEW'),
                          Container(
                              width: 3,
                              color: Colors.white,
                              height: headerHeight),
                          _buildHeaderCell('ADD'),
                          Container(
                              width: 3,
                              color: Colors.white,
                              height: headerHeight),
                          _buildHeaderCell('EDIT'),
                          Container(
                              width: 3,
                              color: Colors.white,
                              height: headerHeight),
                          _buildHeaderCell('DELETE'),
                          Container(
                              width: 3,
                              color: Colors.white,
                              height: headerHeight),
                          _buildHeaderCell('PRINT'),
                        ],
                      ),
                    ),
                    // Permission Rows
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      controller: verticalScrollController,
                      child: Column(
                        children: sortedPrivileges.asMap().entries.map((entry) {
                          final index = entry.key;
                          final privilege = entry.value;
                          return Container(
                            height: rowHeight,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: Color.fromRGBO(0, 0, 0, 0.27),
                                    width: 1),
                              ),
                            ),
                            child: Row(
                              children: [
                                _buildPermissionCell(
                                    privilege, 'view', index, rowHeight,
                                    isLast: false),
                                Container(width: 5, color: Colors.white),
                                _buildPermissionCell(
                                    privilege, 'add', index, rowHeight,
                                    isLast: false),
                                Container(width: 5, color: Colors.white),
                                _buildPermissionCell(
                                    privilege, 'edit', index, rowHeight,
                                    isLast: false),
                                Container(width: 5, color: Colors.white),
                                _buildPermissionCell(
                                    privilege, 'delete', index, rowHeight,
                                    isLast: false),
                                Container(width: 5, color: Colors.white),
                                _buildPermissionCell(
                                    privilege, 'print', index, rowHeight,
                                    isLast: true),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String title) {
    return Container(
      width: 80,
      height: 40,
      alignment: Alignment.center,
      color: const Color(0xFFDC143C),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildPermissionCell(
    Map<String, dynamic> privilege,
    String key,
    int index,
    double rowHeight, {
    required bool isLast,
  }) {
    final bool hasPermission = privilege[key] as bool? ?? false;
    return Container(
      width: 80,
      height: rowHeight,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          right: isLast
              ? BorderSide.none
              : BorderSide(color: Color.fromRGBO(0, 0, 0, 0.27), width: 1),
        ),
      ),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          setState(() {
            privilege[key] = !hasPermission;
          });
        },
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasPermission ? Colors.white : Color(0xffA8B9CA),
            border: Border.all(
              color:
                  hasPermission ? const Color(0xFF006806) : Colors.transparent,
              width: 2,
            ),
          ),
          child: hasPermission
              ? const Icon(
                  Icons.check,
                  color: Color(0xFF006806),
                  size: 16,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomButton(
          text: 'Cancel',
          onPressed: () {},
          width: 110,
          height: 39,
          isOutlined: true,
          borderRadius: 12,
        ),
        const SizedBox(width: 8),
        CustomButton(
          text: 'Save',
          onPressed: () {},
          width: 110,
          height: 39,
          borderRadius: 12,
        ),
      ],
    );
  }
} //
