import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/finance/finance_schedular_screen.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_search_dropdown.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FinanceStaticSettingScreen extends StatefulWidget {
  const FinanceStaticSettingScreen({super.key});

  @override
  State<FinanceStaticSettingScreen> createState() => _FinanceStaticSettingScreenState();
}

class _FinanceStaticSettingScreenState extends State<FinanceStaticSettingScreen> {
  final Color brandRed = const Color(0xFFFF1901);
  final PageController _pageController = PageController();
  int _selectedTab = 0;

  final List<Map<String, dynamic>> dummyClients = [
    {
      "serving_client": "Client A",
      "id": "1",
      "initials": "CA",
      "inactive": 1,
      "active": 3,
      "notice": 2,
      "all": 6,
    },
    {
      "serving_client": "Client B",
      "id": "2",
      "initials": "CB",
      "inactive": 0,
      "active": 5,
      "notice": 1,
      "all": 6,
    },
  ];

  void _onTabSelected(int index) {
    setState(() => _selectedTab = index);
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(color: Color(0xffE8E8E8)),
            left: BorderSide(color: Color(0xffE8E8E8)),
            right: BorderSide(color: Color(0xffE8E8E8)),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: SvgPicture.asset('assets/icons/back.svg', height: 15),
                      ),
                      const SizedBox(width: 120),
                      Text(
                        "Settings",
                        style: GoogleFonts.montserrat(
                          color: brandRed,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomClientDropdown(
                    clients: dummyClients,
                    initialClientName: null,
                    onChanged: (clientName, clientId) {
                      print('Selected: $clientName ($clientId)');
                    },
                  ),
                ],
              ),
            ),

            // Tabs + dividers
            Column(
              children: [
                const Divider(height: 1, thickness: 1, color: Color(0xffE8E8E8)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 20),
                      _buildTab(0, 'assets/icons/invoice.svg', 'Invoicing'),
                      const SizedBox(width: 20),
                      _buildTab(1, 'assets/icons/shedule.svg', 'Scheduler'),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Color(0xffE8E8E8)),
              ],
            ),
            // Page Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _selectedTab = index);
                },
                children: [
                  _invoicingPage(),
                  const SchedulerScreen(), // Use SchedulerScreen for Scheduler tab
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, String icon, String label) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: isSelected ? brandRed : Colors.transparent, width: 2),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 18,
              color: isSelected ? brandRed : Colors.grey,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: isSelected ? brandRed : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: brandRed),
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: brandRed, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              color: brandRed,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _invoicingPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              const Text("Finance Reports", style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              SvgPicture.asset('assets/icons/downloadd.svg', height: 30,),
              const SizedBox(width: 10),
              SvgPicture.asset('assets/icons/email.svg', height: 30),
            ],
          ),
        ),

        // Grey header row - full width
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xffF5F5F5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Report Name",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
              Text(
                "Actions",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),

        // Report rows
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            children: [
              _reportRow("Finance report 1"),
              _reportRow("Finance report 2"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _reportRow(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(name)),
          SvgPicture.asset('assets/icons/dustbin.svg', height: 20),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: brandRed,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Text(
              "Download Excel",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}