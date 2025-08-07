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

class FinanceEditGroupScreen extends ConsumerStatefulWidget {
  final String groupName;
  final Map<String, dynamic> groupData;

  const FinanceEditGroupScreen({
    super.key,
    required this.groupName,
    required this.groupData,
  });

  @override
  ConsumerState<FinanceEditGroupScreen> createState() => _FinanceEditGroupScreenState();
}

class _FinanceEditGroupScreenState extends ConsumerState<FinanceEditGroupScreen> {
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
    debugPrint('Init groupData: ${widget.groupData}');
    groupNameController.text = widget.groupName.isNotEmpty ? widget.groupName : '';
    groupId = widget.groupData['id']?.toString();
    selectedClientId = widget.groupData['client_id']?.toString();
    selectedClientName = widget.groupData['client_name']?.toString() ?? '';
    selectedConsultants = (widget.groupData['consultants'] as List<dynamic>?)?.cast<String>() ?? [];

    if (groupId == null || selectedClientId == null) {
      debugPrint('Error: Missing groupId or clientId');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid group data provided'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
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
    setState(() {
      isClientLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    debugPrint('Fetching clients with token: $token');
    final response = await ref.read(financeProvider.notifier).clientList(token);

    debugPrint('Client response: $response');
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
          selectedClientName = selectedClient['serving_client']?.toString() ?? selectedClientName;
        }
      });
    } else {
      setState(() {
        isClientLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to load clients'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }
    debugPrint('Updated clientList: ${clientList.length}, selectedClientName: $selectedClientName');
  }

  Future<void> fetchConsultantsByClient(String clientId) async {
    setState(() {
      isConsultantLoading = true;
      consultantList = [];
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    debugPrint('Fetching consultants for clientId: $clientId');
    final response = await ref.read(financeProvider.notifier).getConsultantsByClientFinance(clientId, token);

    debugPrint('Consultant response: $response');
    if (response['status'] == true && response['data'] != null) {
      final List<dynamic> consultants = response['data'];
      setState(() {
        consultantList = consultants.map<Map<String, String>>((e) {
          return {
            'id': e['id'].toString(),
            'emp_name': e['emp_name'] ?? '',
          };
        }).toList();
        selectedConsultants = selectedConsultants.where((name) => consultantList.any((c) => c['emp_name'] == name)).toList();
        isConsultantLoading = false;
      });
    } else {
      setState(() {
        consultantList = [];
        isConsultantLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? 'Failed to load consultants'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      });
    }
    debugPrint('Updated consultantList: ${consultantList.length}, selectedConsultants: $selectedConsultants');
  }

  Future<void> handleSave() async {
    final groupName = groupNameController.text.trim();
    if (selectedClientId == null || groupName.isEmpty || selectedConsultants.isEmpty || groupId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    debugPrint('Saving group: clientId=$selectedClientId, groupName=$groupName, consultants=$selectedConsultants, groupId=$groupId');

    setState(() {
      isClientLoading = true;
    });

    final selectedConsultantIds = consultantList
        .where((consultant) => selectedConsultants.contains(consultant['emp_name']))
        .map((e) => e['id']!)
        .toList();

    final response = await ref.read(financeProvider.notifier).editGroupFinance(
      clientId: selectedClientId!,
      groupName: groupName,
      consultantIds: selectedConsultantIds,
      token: token,
      groupId: groupId!,
    );

    debugPrint('Edit group response: $response');
    setState(() {
      isClientLoading = false;
    });

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group updated successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Failed to update group'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> handleDelete() async {
    if (groupId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid group ID'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    debugPrint('Deleting group: groupId=$groupId');

    setState(() {
      isClientLoading = true;
    });

    final response = await ref.read(financeProvider.notifier).deleteGroupFinance(
      token: token,
      groupId: groupId!,
    );

    debugPrint('Delete group response: $response');
    setState(() {
      isClientLoading = false;
    });

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group deleted successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Failed to delete group'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    ref.watch(financeProvider);
    debugPrint('Building UI, isClientLoading: $isClientLoading, isConsultantLoading: $isConsultantLoading, selectedClientName: $selectedClientName, selectedConsultants: $selectedConsultants');

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
                      debugPrint('Client dropdown rebuild, clientList: ${clientList.length}, selectedClientName: $selectedClientName');
                      return isClientLoading
                          ? const Center(child: CustomLoader(color: Color(0xffFF1901), size: 25))
                          : clientList.isEmpty
                          ? const Text(
                        'No clients available',
                        style: TextStyle(color: Colors.grey),
                      )
                          : CustomClientDropdown(
                        key: ValueKey(selectedClientName), // Force rebuild
                        clients: clientList,
                        initialClientName: selectedClientName,
                        onChanged: (clientName, clientId) {
                          debugPrint('Client selected: $clientName, $clientId');
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
                    onChanged: (value) {
                      debugPrint('Group name updated: $value');
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                  Consumer(
                    builder: (context, ref, child) {
                      debugPrint('Consultant dropdown rebuild, consultantList: ${consultantList.length}, selectedConsultants: $selectedConsultants');
                      return isConsultantLoading
                          ? const Center(child: CustomLoader(color: Color(0xffFF1901), size: 25))
                          : consultantList.isEmpty
                          ? const Text(
                        'No consultants available',
                        style: TextStyle(color: Colors.grey),
                      )
                          : SimpleTapMultiSelectDropdown(
                        key: ValueKey(selectedConsultants.join()), // Force rebuild
                        label: 'Consultants',
                        hint: 'Select consultants',
                        items: consultantList.map((e) => e['emp_name']!).toList(),
                        selectedItems: selectedConsultants,
                        onChanged: (newList) {
                          debugPrint('Selected consultants updated: $newList');
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