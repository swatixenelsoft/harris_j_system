import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harris_j_system/screens/consultancy/add_designation_screen.dart';
import 'package:harris_j_system/screens/consultancy/add_role_screen.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';

class DesignationRoleScreen extends StatefulWidget {
  const DesignationRoleScreen({super.key});

  @override
  State<DesignationRoleScreen> createState() => _DesignationRoleScreenState();
}

class _DesignationRoleScreenState extends State<DesignationRoleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0), // Increased AppBar height
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          title: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                indicator: const BoxDecoration(),
                labelPadding: EdgeInsets.zero,
                tabs: [
                  _buildTab("Designation & Role", 0),
                  _buildTab("Privileges", 1),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Designation', onAdd: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10)),
                            ),
                            builder: (context) => CustomAddDesignationDialog(),
                          );
                        }),
                        const SizedBox(height: 8),
                        _buildDesignationList(),
                        const SizedBox(height: 24),
                        const Divider(height: 1, color: Color(0xFFFF1901)),
                        const SizedBox(height: 20),
                        _buildSectionHeader('Roles', onAdd: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10)),
                            ),
                            builder: (context) => CustomAddRoleDialog(),
                          );
                        }),
                        const SizedBox(height: 8),
                        _buildRolesTable(),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRoleDropdown(),
                        const SizedBox(height: 16),
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
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    final bool isSelected = _tabController.index == index;
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF1901)
              : const Color.fromRGBO(242, 242, 242, 1),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
            vertical: 13, horizontal: 8), // Increased vertical padding
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            fontSize: 16, // Increased font size
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: Color(0xFFFF1901),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF1901),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          icon: SvgPicture.asset(
            'assets/icons/add_icon.svg',
            height: 16,
            width: 16,
          ),
          label: Text('Add $title',
              style: const TextStyle(fontFamily: 'Montserrat')),
          onPressed: onAdd,
        ),
      ],
    );
  }

  Widget _buildDesignationList() {
    final designations = [
      'Consultant',
      'Operator',
      'Human Resources',
      'Finance'
    ];
    return Column(
      children: designations.map((designation) {
        final isSelected = designation == 'Consultant';
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromRGBO(255, 150, 27, 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            designation,
            style: TextStyle(
              fontFamily: 'Montserrat',
              color: isSelected ? const Color(0xFFFF1901) : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRolesTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Color(0xFFFF1901),
            borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
          ),
          child: Row(
            children: const [
              Expanded(
                child: Text(
                  'Application Role',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              SizedBox(
                width: 120,
                child: Text(
                  'Assign',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
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
        DataTable(
          columnSpacing: 0,
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey, width: 1.0),
            bottom: BorderSide(color: Colors.grey, width: 1.0),
          ),
          columns: const [
            DataColumn(
              label: Text(
                'Role',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Status',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
          rows: roles.map((role) {
            final isAssigned = role['assigned'] as bool;
            return DataRow(
              cells: [
                DataCell(
                  Container(
                    width: 160,
                    child: Text(
                      role['role'].toString(),
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                DataCell(
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        role['assigned'] = !role['assigned'];
                      });
                    },
                    child: Container(
                      width: 127,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isAssigned
                            ? const Color.fromRGBO(31, 146, 84, 1)
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 85,
                            child: Text(
                              isAssigned ? 'Assigned' : 'Unassigned',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Role',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Color(0xffFF1901),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        const Divider(height: 1, color: Color(0xFFFF1901)),
        const SizedBox(height: 10),
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
          borderRadius: 12,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text(
              'Selected Role : ',
              style: TextStyle(
                fontFamily: 'montserrat',
                fontSize: 14,
              ),
            ),
            Text(
              selectedRole ?? '',
              style: const TextStyle(
                fontFamily: 'Montserrat',
                color: Color(0xffFF1901),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/icons/green_badge.svg',
              height: 20,
              width: 20,
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
        const Text(
          'Privileges',
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: Color(0xFFFF1901),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        const Divider(height: 1, color: Color(0xFFFF1901)),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Module Names Column
              Column(
                children: [
                  Container(
                    width: 150,
                    height: headerHeight,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDC143C),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(8)),
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 5)),
                    ),
                    child: const Text(
                      'MODULE NAME',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    width: 150,
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
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 11,
                                  color: Colors.black,
                                ),
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
                width: 5,
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
                              bottom:
                                  BorderSide(color: Colors.white, width: 5)),
                        ),
                        child: Row(
                          children: [
                            _buildHeaderCell('VIEW'),
                            Container(
                                width: 5,
                                color: Colors.white,
                                height: headerHeight),
                            _buildHeaderCell('ADD'),
                            Container(
                                width: 5,
                                color: Colors.white,
                                height: headerHeight),
                            _buildHeaderCell('EDIT'),
                            Container(
                                width: 5,
                                color: Colors.white,
                                height: headerHeight),
                            _buildHeaderCell('DELETE'),
                            Container(
                                width: 5,
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
                          children:
                              sortedPrivileges.asMap().entries.map((entry) {
                            final index = entry.key;
                            final privilege = entry.value;
                            return Container(
                              height: rowHeight,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade300, width: 1),
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
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 14,
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
              : BorderSide(color: Colors.grey.shade300, width: 1),
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
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: hasPermission
                  ? const Color(0xFF006806)
                  : Colors.grey.shade400,
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
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFFFF1901),
            side: const BorderSide(color: Color(0xFFFF1901)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {},
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Color(0xFFFF1901),
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF1901),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () {},
          child: const Text(
            'Save',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
} //
