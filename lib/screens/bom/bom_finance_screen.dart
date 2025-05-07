import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/bom/bom_add_consultancy_screen.dart';
import 'package:harris_j_system/screens/bom/widget/finance_popup.dart';
import 'package:harris_j_system/screens/bom/widget/import_export.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
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
      appBar: const CustomAppBar(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Encore Films',
                              style: GoogleFonts.montserrat(
                                  fontSize: 18, fontWeight: FontWeight.w800),
                            ),
                            Text(
                              'Invoice Number: EM098789',
                              style: GoogleFonts.montserrat(
                                  fontSize: 10, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const SizedBox(width: 13),
                        CustomButton(
                          text: 'Terms And Conditions',
                          onPressed: () async {
                          },
                          height: 39,
                          width: 140,
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          key: _menuIconKey,
                          onTap: () => _showImportExportPopupBelow(
                              context, _menuIconKey),
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
                            // height: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _contactCard(
                      label: 'Primary Contact Person',
                      name: 'Alfonso Mango',
                      phone: '+65 7863 4563',
                      email: 'sales877@gmail.com',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _contactCard(
                      label: 'Secondary Contact Person',
                      name: 'Abram Culhane',
                      phone: '+65 8963 9863',
                      email: 'sales98@gmail.com',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _addressCard(),
                  ),
                  const SizedBox(height: 12),
                  _buildRemarksSection(),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 20),
                    child: CustomButton(
                      text: 'View Invoice',
                      onPressed: () {
                        _showPopup(context);
                      },
                      borderRadius: 12,
                      textStyle: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
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
                                      color: Color.fromRGBO(0, 0, 0,
                                          0.25), // Adjust opacity as needed
                                      blurRadius: 7, // Controls the blur effect
                                      spreadRadius:
                                          1, // Controls the size of the shadow
                                      offset: Offset(
                                          0, 0), // Moves the shadow downward
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
                                          color: const Color(
                                              0xff767676))), // Reduce space
                                  TextSpan(
                                      text: '#EM098789',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)), // Reduce space
                                  // Reduce space further
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
                                          color: const Color(
                                              0xff767676))), // Reduce space
                                  TextSpan(
                                      text: '01-04-2025',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)), // Reduce space
                                  // Reduce space further
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
                                          color: const Color(
                                              0xff767676))), // Reduce space
                                  TextSpan(
                                      text: '01-04-2025',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black)), // Reduce space
                                  // Reduce space further
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
    required String label,
    required String name,
    required String phone,
    required String email,
  }) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25), // Adjust opacity as needed
            blurRadius: 7, // Controls the blur effect
            spreadRadius: 1, // Controls the size of the shadow
            offset: Offset(0, 0), // Moves the shadow downward
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 160,
              height: 30,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xffFF1901),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    topLeft: Radius.circular(6)),
              ),
              child: Text(
                label,
                style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              name,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/phone_icon.svg'),
                    const SizedBox(width: 4),
                    Text(
                      phone,
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/mail_icon.svg'),
                    const SizedBox(width: 4),
                    Text(
                      email,
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressCard() {
    return Container(
      height: 140,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25), // Adjust opacity as needed
            blurRadius: 7, // Controls the blur effect
            spreadRadius: 1, // Controls the size of the shadow
            offset: Offset(0, 0), // Moves the shadow downward
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 160,
              height: 30,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xffFF1901),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    topLeft: Radius.circular(6)),
              ),
              child: Text(
                "Address Information",
                style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xffE5F1FF), // Adjust opacity as needed
                        blurRadius: 4, // Controls the blur effect
                        spreadRadius: 0, // Controls the size of the shadow
                        offset: Offset(0, 0), // Moves the shadow downward
                      ),
                    ],
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/icons/location_marker.svg',
                    height: 20,
                    width: 20,
                  )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "No.22,Abcd Street,RR Nager,Chennai-600016,Tamil Nadu,India",
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: const Color(0xff181818),
                    ),
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xffE5F1FF), // Adjust opacity as needed
                        blurRadius: 4, // Controls the blur effect
                        spreadRadius: 0, // Controls the size of the shadow
                        offset: Offset(0, 0), // Moves the shadow downward
                      ),
                    ],
                  ),
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/icons/google_code.svg',
                    height: 20,
                    width: 20,
                    color: const Color(0xffFF1901),
                  )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "No.22,Abcd Street,RR Nager,Chennai-600016,Tamil Nadu,India",
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: const Color(0xff181818),
                    ),
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemarksSection() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color:
            Colors.white, // If color is null, it will be transparent (default)
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
