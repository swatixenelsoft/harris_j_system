import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_search_dropdown.dart';

import '../../providers/finance_provider.dart';

class FinanceAddGroupScreen extends ConsumerStatefulWidget {
  const FinanceAddGroupScreen({super.key});

  @override
  ConsumerState<FinanceAddGroupScreen> createState() =>
      _FinanceAddGroupScreenState();
}

class _FinanceAddGroupScreenState extends ConsumerState<FinanceAddGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();

  List<Map<String, dynamic>> clientList = [];
  final List<String> consultantList = ['John Doe', 'Jane Smith', 'Alice Patel'];

  String? selectedClientName;
  String? selectedClientId;
  String? selectedConsultant;

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
    ref.read(financeProvider.notifier).setLoading(true);

    print('loading');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('Token: $token'); // Debug: Check if token is retrieved

    final response = await ref.read(financeProvider.notifier).clientList(token);
    print('API Response: $response'); // Debug: Log the full response

    if (response['success'] == true && response['data'] != null) {
      final data = response['data'] as List<dynamic>;
      print('Parsed Client List: $data'); // Debug: Log parsed data
      setState(() {
        clientList = data.map((e) => e as Map<String, dynamic>).toList();

      });
      ref.read(financeProvider.notifier).setLoading(false);
      print('clientList: $clientList');
    } else {
      print('Error Response: ${response['message']}'); // Debug: Log error message
      setState(() {

        error = response['message'] ?? 'Failed to load clients';
      });
      ref.read(financeProvider.notifier).setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final financeState = ref.watch(financeProvider);
    print('financeState $clientList');
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
                  CustomClientDropdown(
                    clients: clientList,
                    initialClientName: null,
                    onChanged: (clientName, clientId) {
                      setState(() {
                        selectedClientName = clientName;
                        selectedClientId = clientId;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: "Group Name*",
                    controller: groupNameController,
                    useUnderlineBorder: false,
                    padding: 0,
                    borderRadius: 12,
                  ),
                  const SizedBox(height: 20),
                  CustomDropdownField(
                    label: "Select Consultants",
                    items: consultantList,
                    value: selectedConsultant,
                    onChanged: (val) => setState(() {
                      selectedConsultant = val;
                    }),
                  ),
                ],
              ),
            ),
          ),
          if (financeState.isLoading)
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
          if (!financeState.isLoading && error == null)
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
                          selectedConsultant = null;
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
                      onTap: () {
                        print(
                            'Save: $selectedClientName, $selectedClientId, ${groupNameController.text}, $selectedConsultant');
                      },
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