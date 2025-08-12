import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/widgets/custom_search_dropdown.dart';
import 'package:harris_j_system/widgets/multi_select.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/providers/finance_provider.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';

// -------------------- TOAST HELPER --------------------
class ToastHelper {
  static void showSuccess(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      icon: Icons.check_circle,
      iconColor: Colors.green,
      containerColor: Colors.green.shade100,
      duration: const Duration(seconds: 2),
    );
  }

  static void showError(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      icon: Icons.error,
      iconColor: Colors.red,
      containerColor: Colors.red.shade100,
      duration: const Duration(seconds: 4),
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      icon: Icons.info,
      iconColor: Colors.blue,
      containerColor: Colors.blue.shade100,
      duration: const Duration(seconds: 3),
    );
  }

  static void _showCustomToast(
      BuildContext context,
      String message, {
        required IconData icon,
        required Color iconColor,
        required Color containerColor,
        required Duration duration,
      }) {
    DelightToastBar(
      builder: (context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  message,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      position: DelightSnackbarPosition.bottom,
      autoDismiss: true,
      snackbarDuration: duration,
    ).show(context);
  }
}

// -------------------- MAIN SCREEN --------------------
class FinanceEditGroupScreen extends ConsumerStatefulWidget {
  final String groupName;
  final Map<String, dynamic> groupData;

  const FinanceEditGroupScreen({
    super.key,
    required this.groupName,
    required this.groupData,
  });

  @override
  ConsumerState<FinanceEditGroupScreen> createState() =>
      _FinanceEditGroupScreenState();
}

class _FinanceEditGroupScreenState
    extends ConsumerState<FinanceEditGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  List<Map<String, dynamic>> clientList = [];
  List<Map<String, String>> consultantList = [];
  List<String> selectedConsultants = [];
  String? selectedClientName;
  String? selectedClientId;
  String? groupId;
  bool isClientLoading = true;
  bool isConsultantLoading = false;

  final Color brandRed = const Color(0xFFFF1901);

  @override
  void initState() {
    super.initState();
    groupNameController.text =
    widget.groupName.isNotEmpty ? widget.groupName : '';
    groupId = widget.groupData['id']?.toString();
    selectedClientId = widget.groupData['client_id']?.toString();
    selectedClientName = widget.groupData['client_name']?.toString() ?? '';
    selectedConsultants =
        (widget.groupData['consultants'] as List<dynamic>?)
            ?.cast<String>() ??
            [];

    if (groupId == null || selectedClientId == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ToastHelper.showError(context, 'Invalid group data provided');
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchClients();
      if (selectedClientId != null) {
        await fetchConsultantsByClient(selectedClientId!);
      }
    });
  }

  Future<void> fetchClients() async {
    setState(() => isClientLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response =
    await ref.read(financeProvider.notifier).clientList(token);

    if (response['success'] == true && response['data'] != null) {
      final data = response['data'] as List<dynamic>;
      setState(() {
        clientList = data.map((e) => e as Map<String, dynamic>).toList();
        isClientLoading = false;
        if (selectedClientId != null) {
          final selectedClient = clientList.firstWhere(
                (client) => client['id'].toString() == selectedClientId,
            orElse: () => {'serving_client': selectedClientName},
          );
          selectedClientName =
              selectedClient['serving_client']?.toString() ??
                  selectedClientName;
        }
      });
    } else {
      setState(() => isClientLoading = false);
      ToastHelper.showError(
          context, response['message'] ?? 'Failed to load clients');
    }
  }

  Future<void> fetchConsultantsByClient(String clientId) async {
    setState(() {
      isConsultantLoading = true;
      consultantList = [];
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await ref
        .read(financeProvider.notifier)
        .getConsultantsByClientFinance(clientId, token);

    if (response['status'] == true && response['data'] != null) {
      final List<dynamic> consultants = response['data'];
      setState(() {
        consultantList = consultants.map<Map<String, String>>((e) {
          return {
            'id': e['id'].toString(),
            'emp_name': e['emp_name'] ?? '',
          };
        }).toList();
        selectedConsultants = selectedConsultants
            .where((name) =>
            consultantList.any((c) => c['emp_name'] == name))
            .toList();
        isConsultantLoading = false;
      });
    } else {
      setState(() {
        consultantList = [];
        isConsultantLoading = false;
      });
      ToastHelper.showError(
          context, response['message'] ?? 'Failed to load consultants');
    }
  }

  Future<void> handleSave() async {
    final groupName = groupNameController.text.trim();
    if (selectedClientId == null ||
        groupName.isEmpty ||
        selectedConsultants.isEmpty ||
        groupId == null) {
      ToastHelper.showError(context, 'Please fill all fields');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    setState(() => isClientLoading = true);

    final selectedConsultantIds = consultantList
        .where((consultant) =>
        selectedConsultants.contains(consultant['emp_name']))
        .map((e) => e['id']!)
        .toList();

    final response = await ref.read(financeProvider.notifier).editGroupFinance(
      clientId: selectedClientId!,
      groupName: groupName,
      consultantIds: selectedConsultantIds,
      token: token,
      groupId: groupId!,
    );

    setState(() => isClientLoading = false);

    if (response['success'] == true || response['status'] == true) {
      ToastHelper.showSuccess(context, 'Group updated successfully');
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.of(context).pop({
          'id': groupId,
          'client_id': selectedClientId,
          'client_name': selectedClientName,
          'group_name': groupName,
          'consultants': selectedConsultants,
        });
      }
    } else {
      ToastHelper.showError(
          context, response['message'] ?? 'Failed to update group');
    }
  }

  Future<void> handleDelete() async {
    if (groupId == null) {
      ToastHelper.showError(context, 'Invalid group ID');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    setState(() => isClientLoading = true);

    final response = await ref
        .read(financeProvider.notifier)
        .deleteGroupFinance(token: token, groupId: groupId!);

    setState(() => isClientLoading = false);

    if (response['success'] == true) {
      ToastHelper.showSuccess(context, 'Group deleted successfully');
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      ToastHelper.showError(
          context, response['message'] ?? 'Failed to delete group');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(financeProvider);

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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: SvgPicture.asset(
                          'assets/icons/back.svg',
                          height: 15,
                        ),
                      ),
                      const SizedBox(width: 90),
                      Text(
                        'Edit Group',
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
                        'Modify Group Billing',
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
                    'Client Name',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: brandRed,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Consumer(
                    builder: (context, ref, child) {
                      return isClientLoading
                          ? const Center(
                          child: CustomLoader(
                              color: Color(0xffFF1901), size: 25))
                          : clientList.isEmpty
                          ? const Text(
                        'No clients available',
                        style: TextStyle(color: Colors.grey),
                      )
                          : CustomClientDropdown(
                        key: ValueKey(selectedClientName),
                        clients: clientList,
                        initialClientName: selectedClientName,
                        onChanged: (clientName, clientId) {
                          setState(() {
                            selectedClientName = clientName;
                            selectedClientId = clientId;
                            selectedConsultants = [];
                            consultantList = [];
                          });
                          if (clientId != null) {
                            fetchConsultantsByClient(clientId);
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'Group Name*',
                    controller: groupNameController,
                    useUnderlineBorder: false,
                    padding: 0,
                    borderRadius: 12,
                  ),
                  const SizedBox(height: 20),
                  Consumer(
                    builder: (context, ref, child) {
                      return isConsultantLoading
                          ? const Center(
                          child: CustomLoader(
                              color: Color(0xffFF1901), size: 25))
                          : consultantList.isEmpty
                          ? const Text(
                        'No consultants available',
                        style: TextStyle(color: Colors.grey),
                      )
                          : SimpleTapMultiSelectDropdown(
                        key: ValueKey(selectedConsultants.join()),
                        label: 'Consultants',
                        hint: 'Select consultants',
                        items: consultantList
                            .map((e) => e['emp_name']!)
                            .toList(),
                        selectedItems: selectedConsultants,
                        onChanged: (newList) {
                          setState(() {
                            selectedConsultants = newList;
                          });
                        },
                      );
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
          if (!isClientLoading && !isConsultantLoading)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xffFF1901)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: handleDelete,
                      child: Text(
                        "Delete Group",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: const Color(0xffFF1901),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: handleSave,
                      child: SvgPicture.asset(
                        'assets/icons/edit_button_finance.svg',
                        width: 36.0,
                        height: 40.0,
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
