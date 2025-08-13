import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/widgets/multi_select.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_search_dropdown.dart';
import '../../providers/finance_provider.dart';
import 'package:harris_j_system/ulits/toast_helper.dart'; // Make sure you add your ToastHelper import

class FinanceAddGroupScreen extends ConsumerStatefulWidget {
  const FinanceAddGroupScreen({super.key});

  @override
  ConsumerState<FinanceAddGroupScreen> createState() =>
      _FinanceAddGroupScreenState();
}

class _FinanceAddGroupScreenState extends ConsumerState<FinanceAddGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();

  List<Map<String, dynamic>> clientList = [];
  List<Map<String, String>> consultantList = []; // [{'id': '1', 'name': 'John'}]

  String? selectedClientName;
  String? selectedClientId;
  List<String> selectedConsultants = []; // this will store selected names

  bool isClientLoading = true;
  bool isConsultantLoading = false;
  String? error;

  final Color brandRed = const Color(0xFFFF1901);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      fetchClients();
    });
  }

  Future<void> fetchClients() async {
    setState(() {
      isClientLoading = true;
      error = null;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await ref.read(financeProvider.notifier).clientList(token);

    if (response['success'] == true && response['data'] != null) {
      final data = response['data'] as List<dynamic>;
      setState(() {
        clientList = data.map((e) => e as Map<String, dynamic>).toList();
        isClientLoading = false;
      });
      ref.read(financeProvider.notifier).setLoading(false);
    } else {
      setState(() {
        isClientLoading = false;
        error = response['message'] ?? 'Failed to load clients';
      });
      ref.read(financeProvider.notifier).setLoading(false);
    }
  }

  Future<void> fetchConsultantsByClient(String clientId) async {
    setState(() {
      isConsultantLoading = true;
      consultantList = [];
      selectedConsultants = [];
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await ref
        .read(financeProvider.notifier)
        .getConsultantsByClientFinance(clientId, token);

    final bool status = response['status'] ?? false;
    print(" status value: $status");
    print(" response: $response");


    if (status && response['data'] != null) {
      final List<dynamic> consultants = response['data'];
      setState(() {
        consultantList = consultants.map<Map<String, String>>((e) {
          return {
            'id': e['id'].toString(),
            'emp_name': e['emp_name'] ?? '',
          };
        }).toList();
        isConsultantLoading = false;
      });
    } else {
      setState(() {
        consultantList = [];
        isConsultantLoading = false;
      });
    }
  }

  Future<void> handleSave() async {
    final groupName = groupNameController.text.trim();

    if (selectedClientId == null ||
        groupName.isEmpty ||
        selectedConsultants.isEmpty) {
      ToastHelper.showError(context, 'Please fill all fields');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    setState(() {
      isClientLoading = true;
    });

    // Map selected consultant names to their IDs
    final selectedConsultantIds = consultantList
        .where((consultant) =>
        selectedConsultants.contains(consultant['emp_name']))
        .map((e) => e['id']!)
        .toList();

    final response = await ref.read(financeProvider.notifier).createGroupFinance(
      clientId: selectedClientId!,
      groupName: groupName,
      consultantIds: selectedConsultantIds,
      token: token,
    );

    setState(() {
      isClientLoading = false;
    });

    if (response['success'] == true || response['status'] == true) {
      ToastHelper.showSuccess(context, 'Group created successfully');
    } else {
      ToastHelper.showError(context, response['message'] ?? 'Failed to create group');
    }

  }

  @override
  Widget build(BuildContext context) {
    final financeState = ref.watch(financeProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBackButton: false,
        image: 'assets/icons/cons_logo.png',
        onProfilePressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
              border: Border(
                top: BorderSide(color: Color(0xffE8E8E8)),
                left: BorderSide(color: Color(0xffE8E8E8)),
                right: BorderSide(color: Color(0xffE8E8E8)),
              ),
            ),
            child: error != null
                ? Center(
              child: Text(
                error!,
                style: const TextStyle(color: Colors.red),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: SvgPicture.asset(
                          'assets/icons/back.svg',
                          height: 15,
                        ),
                      ),
                      const SizedBox(width: 90),
                      Text(
                        'Add Group',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        "New / modify Group Billing",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: brandRed,
                        ),
                      ),
                      const Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.black26,
                          indent: 8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Client Name",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: brandRed,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (!isClientLoading && clientList.isNotEmpty)
                    CustomClientDropdown(
                      clients: clientList,
                      initialClientName: null,
                      onChanged: (clientName, clientId) {
                        setState(() {
                          selectedClientName = clientName;
                          selectedClientId = clientId;
                        });
                        fetchConsultantsByClient(clientId!);
                      },
                    )
                  else if (!isClientLoading && clientList.isEmpty)
                    const Text(
                      'No clients available',
                      style: TextStyle(color: Colors.grey),
                    )
                  else
                    const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Group Name*",
                    controller: groupNameController,
                    useUnderlineBorder: false,
                    padding: 0,
                    borderRadius: 12,
                  ),
                  const SizedBox(height: 20),
                  SimpleTapMultiSelectDropdown(
                    label: "Consultants",
                    hint: "Select consultants",
                    items:
                    consultantList.map((e) => e['emp_name']!).toList(),
                    selectedItems: selectedConsultants,
                    onChanged: (newList) {
                      setState(() {
                        selectedConsultants = newList;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          if (isClientLoading || isConsultantLoading)
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
          if (!isClientLoading && error == null)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        groupNameController.clear();
                        setState(() {
                          selectedClientName = null;
                          selectedClientId = null;
                          selectedConsultants = [];
                          consultantList = [];
                        });
                      },
                      child: SvgPicture.asset(
                        'assets/icons/clearr.svg',
                        width: 35.0,
                        height: 35.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: handleSave,
                      child: SvgPicture.asset(
                        'assets/icons/savee.svg',
                        width: 35.0,
                        height: 35.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
