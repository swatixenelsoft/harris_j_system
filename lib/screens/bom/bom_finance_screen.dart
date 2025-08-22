import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/bom/bom_add_consultancy_screen.dart';
import 'package:harris_j_system/screens/bom/widget/finance_popup.dart';
import 'package:harris_j_system/screens/bom/widget/import_export.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_app_bar2.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/remark_section.dart';

class BomFinanceScreen extends StatefulWidget {
  const BomFinanceScreen({super.key});

  @override
  State<BomFinanceScreen> createState() => _BomFinanceScreenState();
}

class _BomFinanceScreenState extends State<BomFinanceScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _menuIconKey = GlobalKey();
  bool _isPrimarySelected = true; // State managed at the State level

  final List<Map<String, String>> consultancyData = [
    {
      'count': '200',
      'label': 'Total Consultants',
      'iconPath': 'assets/icons/total_consultants.svg',
    },
    {
      'count': '\$500',
      'label': 'Total Amount',
      'iconPath': 'assets/icons/total_amount.svg',
    },
    {
      'count': '4%',
      'label': 'Tax %',
      'iconPath': 'assets/icons/tax.svg',
    },
    {
      'count': '\$500',
      'label': 'Total Billing Amt.',
      'iconPath': 'assets/icons/total_billing.svg',
    },
  ];
  OverlayEntry? _overlayEntry;

  void _showImportExportPopupBelow(BuildContext context, GlobalKey key) {
    final RenderBox renderBox =
    key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive left position
    double leftPosition = screenWidth * 0.60;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background blur with dismiss
          GestureDetector(
            onTap: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.1), // Light overlay
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),

          // Positioned popup
          Positioned(
            left: leftPosition,
            top: position.dy + size.height + 10,
            child: FinancePopupMenu(
              onClose: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
floatingActionButton:Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
  child: SizedBox(
    height: 42, // ✅ Reduced button height
    width: 160, // ✅ Optional: make button compact in width too
    child: CustomButton(
      text: 'View Invoice',
      onPressed: () {
        _showPopup(context);
      },
      borderRadius: 8, // ✅ Slightly smaller corners
      textStyle: GoogleFonts.montserrat(
        fontSize: 14, // ✅ Smaller font size
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
),
      appBar: const CustomAppBar2(
        showBackButton: false,
        image: 'assets/images/bom/bom_logo.png',
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderContent(),
                  const SizedBox(height: 16),
                  // Client Info
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Encore Films',
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Invoice Number: EM098789',
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          key: _menuIconKey,
                          onTap: () => _showImportExportPopupBelow(context, _menuIconKey),
                          behavior: HitTestBehavior.translucent,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              'assets/icons/menu.svg',
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 16),
                  // Metrics Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio:
                        2.0, // Controls width-to-height ratio (e.g., 180/90 = 2.0)
                      ),
                      itemCount: consultancyData.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = consultancyData[index];
                        return consultancyCard(
                          count: item['count']!,
                          label: item['label']!,
                          iconPath: item['iconPath']!,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Contact & Address Information',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFF1901),
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Color(0xff8D91A0),
                            thickness: 1,
                            endIndent: 3,
                            indent: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Single Contact Card with Tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _contactCard(
                      onTabChanged: (isPrimary) {
                        setState(() {
                          _isPrimarySelected = isPrimary;
                        });
                      },
                      primaryName: 'Alfonso Mango',
                      primaryPhone: '+65 7863 4563',
                      primaryEmail: 'sales877@gmail.com',
                      primaryAddress1:
                      'No.22, Abcd Street, RR Nagar, Chennai-600016, Tamil Nadu, India',
                      primaryAddress2: 'X5JX+HX Chennai, Tamil Nadu',
                      secondaryName: 'Jane Doe',
                      secondaryPhone: '+65 1234 5678',
                      secondaryEmail: 'jane.doe@example.com',
                      secondaryAddress1:
                      'No.10, XYZ Street, Bangalore-560001, Karnataka, India',
                      secondaryAddress2: 'P5QX+MW Bangalore, Karnataka',
                      isPrimarySelected: _isPrimarySelected,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //   child: _addressCard(),
                  // ),
                  const SizedBox(height: 12),
                  _buildRemarksSection(),


                ],
              ),
            ),
          ),
          // if (isLoading)
          //   Positioned.fill(
          //     child: BackdropFilter(
          //       filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
          //       child: Container(
          //         color: Colors.black.withOpacity(0.2),
          //         alignment: Alignment.center,
          //         child: const CustomLoader(
          //           color: Color(0xffFF1901),
          //           size: 35,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              // Blur background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.black.withOpacity(0.2), // Optional dim effect
                ),
              ),
              // Center popup
              Center(
                child: StatefulBuilder(builder: (context, setState) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.8,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    const BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.25),
                                      blurRadius: 7,
                                      spreadRadius: 1,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(Icons.close_outlined, size: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.circle,
                                      color: Color(0xFFFF1901), size: 15),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Invoice Preview',
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: const Color(0xFFFF1901),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomButton(
                              text: 'Export',
                              onPressed: () {},
                              width: 95,
                              height: 34,
                            )
                          ],
                        ),

                        Image.asset(
                          'assets/images/bom/bom_logo.png',
                          height: 22,
                          width: 68,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Invoice",
                              style: GoogleFonts.montserrat(
                                fontSize: 22,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: GoogleFonts.montserrat(
                                  color: const Color(0xffD1D1D6),
                                  fontSize: 10,
                                ),
                                children: [
                                  TextSpan(
                                      text: 'Invoice# : ',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff767676))),
                                  TextSpan(
                                      text: '#EM098789',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: GoogleFonts.montserrat(
                                  color: const Color(0xffD1D1D6),
                                  fontSize: 10,
                                ),
                                children: [
                                  TextSpan(
                                      text: 'Date: ',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff767676))),
                                  TextSpan(
                                      text: '01-04-2025',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: GoogleFonts.montserrat(
                                  color: const Color(0xffD1D1D6),
                                  fontSize: 10,
                                ),
                                children: [
                                  TextSpan(
                                      text: 'Due Date: ',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff767676))),
                                  TextSpan(
                                      text: '01-04-2025',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text("Bill From:",
                            style: GoogleFonts.montserrat(
                                color: const Color(0xff0369D7),
                                fontSize: 10,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 4),
                        Text("Harris J. System",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            )),
                        const SizedBox(height: 4),
                        Text(
                          "No.22,Abcd Street,RR Nagar,Chennai-600016,Tamil Nadu,India X5JX+HX Chennai, Tamil Nadu",
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff181818)),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20),
                        Text("Bill To:",
                            style: GoogleFonts.montserrat(
                                color: const Color(0xff1F9254),
                                fontSize: 10,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(height: 4),
                        Text("Encore Films",
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            )),
                        const SizedBox(height: 4),
                        Text(
                          "No.22,Abcd Street,RR Nagar,Chennai-600016,Tamil Nadu,India X5JX+HX Chennai, Tamil Nadu",
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff181818)),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20),

                        /// Table Headers
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Total Amount",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10,
                                    color: const Color(0xffA7A7A7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Tax %",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10,
                                    color: const Color(0xffA7A7A7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Total Consultants",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10,
                                    color: const Color(0xffA7A7A7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(thickness: 1, color: Color(0xffE1E1E1)),
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "\$500",
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14,
                                    color: const Color(0xff181818),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "4%",
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14,
                                    color: const Color(0xff181818),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "200",
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14,
                                    color: const Color(0xff181818),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xffE1E1E1),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Text("Total Billing Amt.",
                              style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xffA7A7A7))),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 120.0),
                            child: Text("\$500",
                                style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff181818))),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: Color(0xffE8E8E8)),
          left: BorderSide(color: Color(0xffE8E8E8)),
          right: BorderSide(color: Color(0xffE8E8E8)),
          bottom: BorderSide.none, // 👈 removes bottom border
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child:
                    SvgPicture.asset('assets/icons/back.svg', height: 15)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BILLING STATUS:',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff5A5A5A),
                      ),
                    ),
                    Text(
                      '90/100',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: const Color(0xff5A5A5A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          CustomTextField(
            hintText: 'Start typing or click to see clients/consultant',
            label: 'Start typing or click to see clients/consultant',
            controller: _searchController,
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 30,
              color: Color(0xff8D91A0),
            ),
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
          ),
        ],
      ),
    );
  }

  Widget consultancyCard({
    required String count,
    required String label,
    required String iconPath,
  }) {
    return Container(
      height: 90,
      width: 180,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(iconPath, height: 40, width: 40),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 26,
                  color: Colors.black,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  color: const Color(0xffA7A7A7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactCard({
    required Function(bool) onTabChanged,
    required String primaryName,
    required String primaryPhone,
    required String primaryEmail,
    required String primaryAddress1,
    required String primaryAddress2,
    required String secondaryName,
    required String secondaryPhone,
    required String secondaryEmail,
    required String secondaryAddress1,
    required String secondaryAddress2,
    required bool isPrimarySelected,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA), // Updated background color
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          // Top Tabs Header
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onTabChanged(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isPrimarySelected
                          ? const Color(0xFFFF1901)
                          : const Color(0xffDADADA),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Primary Contact',
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isPrimarySelected
                              ? Colors.white
                              : const Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onTabChanged(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: !isPrimarySelected
                          ? const Color(0xFFFF1901)
                          : const Color(0xffDADADA),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Secondary Contact',
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: !isPrimarySelected
                              ? Colors.white
                              : const Color(0xff000000),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  isPrimarySelected ? primaryName : secondaryName,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),

                // Phone + Email + Google icon
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/phone_icon.svg',
                      height: 16,
                      width: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isPrimarySelected ? primaryPhone : secondaryPhone,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 20),
                    SvgPicture.asset(
                      'assets/icons/mail_icon.svg',
                      height: 16,
                      width: 16,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        isPrimarySelected ? primaryEmail : secondaryEmail,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                const SizedBox(height: 30),

                // Address with location icon + Google icon near second line
                // Address with location + Google code icon
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Row → Location icon + First address line
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/location_marker.svg',
                          height: 16,
                          width: 16,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            isPrimarySelected ? primaryAddress1 : secondaryAddress1,
                            style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: const Color(0xff181818),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Second Row → Google icon + Second address line
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 18), // To align Google icon under address text
                        SvgPicture.asset(
                          'assets/icons/google_code2.svg',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            isPrimarySelected ? primaryAddress2 : secondaryAddress2,
                            style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: const Color(0xff181818),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                )


              ],
            ),
          ),
        ],
      ),
    );
  }
  // Widget _addressCard() {
  //   return Container(
  //     height: 140,
  //     width: MediaQuery.of(context).size.width,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(6),
  //       boxShadow: const [
  //         BoxShadow(
  //           color: Color.fromRGBO(0, 0, 0, 0.25),
  //           blurRadius: 7,
  //           spreadRadius: 1,
  //           offset: Offset(0, 0),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Container(
  //             width: 160,
  //             height: 30,
  //             alignment: Alignment.center,
  //             decoration: const BoxDecoration(
  //               color: Color(0xffFF1901),
  //               borderRadius: BorderRadius.only(
  //                   bottomRight: Radius.circular(12),
  //                   topLeft: Radius.circular(6)),
  //             ),
  //             child: Text(
  //               "Address Information",
  //               style: GoogleFonts.montserrat(
  //                   fontSize: 10,
  //                   fontWeight: FontWeight.w600,
  //                   color: Colors.white),
  //             )),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //           child: Row(
  //             children: [
  //               Container(
  //                 height: 30,
  //                 width: 30,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(15),
  //                   boxShadow: const [
  //                     BoxShadow(
  //                       color: Color(0xffE5F1FF),
  //                       blurRadius: 4,
  //                       spreadRadius: 0,
  //                       offset: Offset(0, 0),
  //                     ),
  //                   ],
  //                 ),
  //                 child: Center(
  //                     child: SvgPicture.asset(
  //                       'assets/icons/location_marker.svg',
  //                       height: 20,
  //                       width: 20,
  //                     )),
  //               ),
  //               const SizedBox(width: 10),
  //               Expanded(
  //                 child: Text(
  //                   "No.22,Abcd Street,RR Nagar,Chennai-600016,Tamil Nadu,India X5JX+HX Chennai, Tamil Nadu",
  //                   style: GoogleFonts.spaceGrotesk(
  //                     fontWeight: FontWeight.w400,
  //                     fontSize: 12,
  //                     color: const Color(0xff181818),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //           child: Row(
  //             children: [
  //               Container(
  //                 height: 30,
  //                 width: 30,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(15),
  //                   boxShadow: const [
  //                     BoxShadow(
  //                       color: Color(0xffE5F1FF),
  //                       blurRadius: 4,
  //                       spreadRadius: 0,
  //                       offset: Offset(0, 0),
  //                     ),
  //                   ],
  //                 ),
  //                 child: Center(
  //                     child: SvgPicture.asset(
  //                       'assets/icons/google_code2.svg',
  //                       height: 20,
  //                       width: 20,
  //                     )),
  //               ),
  //               const SizedBox(width: 10),
  //               Expanded(
  //                 child: Text(
  //                   "X5JX+HX Chennai, Tamil Nadu",
  //                   style: GoogleFonts.spaceGrotesk(
  //                     fontWeight: FontWeight.w400,
  //                     fontSize: 12,
  //                     color: const Color(0xff181818),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildRemarksSection() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: RemarksSection(),
    );
  }
}