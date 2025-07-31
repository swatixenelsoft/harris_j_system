import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/finance/finance_attached_files_screen.dart';
import 'package:harris_j_system/screens/finance/finance_customized_template_screen.dart';
import 'package:harris_j_system/screens/finance/finance_invoice_preview_2_screen.dart';
import 'package:harris_j_system/screens/finance/finance_schedule_screen.dart';
import 'package:harris_j_system/screens/finance/finance_terms_and_condition_screen.dart';
import 'package:harris_j_system/screens/finance/invoice_model_screen.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_invoice_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComposeButtonScreen extends StatefulWidget {
  const ComposeButtonScreen({super.key});

  @override
  _ComposeButtonScreenState createState() => _ComposeButtonScreenState();
}

class _ComposeButtonScreenState extends State<ComposeButtonScreen> {

  double taxPercentage = 4.0; // Default tax percentage
  late TextEditingController taxController;
  String selectedTemplate = 'Template1';

  @override
  void initState() {
    super.initState();
    taxController =
        TextEditingController(text: taxPercentage.toStringAsFixed(2));
  }

  List<InvoiceItem> invoiceItems = [
    InvoiceItem(name: 'Resource 1', fee: 100.0),
    InvoiceItem(name: 'Resource 2', fee: 100.0),
    InvoiceItem(name: 'Resource 3', fee: 100.0),
    InvoiceItem(name: 'Resource 4', fee: 100.0),
    InvoiceItem(name: 'Resource 5', fee: 100.0),
  ];



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
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderContent(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: Color(0xffE8E8E8)),
          left: BorderSide(color: Color(0xffE8E8E8)),
          right: BorderSide(color: Color(0xffE8E8E8)),
          bottom: BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back + Icons (unchanged)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: SvgPicture.asset('assets/icons/back.svg', height: 15),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/fullgood.svg', height: 29),
                    const SizedBox(width: 5),
                    SvgPicture.asset('assets/icons/fullhold.svg', height: 29),
                    const SizedBox(width: 5),
                    SvgPicture.asset('assets/icons/reject.svg', height: 29),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          // Email Fields (unchanged)
          _buildLineField(label: 'From:', showPen: false),
          _buildLineField(label: 'To:', showPen: true),
          _buildLineField(label: 'CC:', showPen: true),
          _buildLineField(label: 'Subject:', showPen: true),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffFFEEDA),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    'assets/icons/attach.svg',
                    height: 10,
                    colorFilter: null,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Text(
                      'Attached Files',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFFFF1901),
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color(0xFFFF1901),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45),
            child: Text(
              'Maximum allowed file size is 512 MB',
              style: GoogleFonts.montserrat(
                fontSize: 10,
                color: const Color(0xFF5A5A5A),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 18,top:13,bottom: 13,right: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(width: 1,   color: Colors.white,),      // add top border
                bottom: BorderSide(width: 1,   color:Colors.white),   // add bottom border
              ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  spreadRadius: 0,
                  blurRadius: 3,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return Dialog(
                          insetPadding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1),
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 900),
                            child: CustomInvoiceView(
                              selecteTemplate: selectedTemplate,
                              isEditable:false,
                              initialItems: invoiceItems,
                              initialTaxPercentage: taxPercentage,
                              onSave: (updatedItems, updatedTax) {
                                setState(() {
                                  invoiceItems = updatedItems;
                                  taxPercentage = updatedTax;
                                  taxController.text =
                                      taxPercentage.toStringAsFixed(2);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Invoice Preview',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFFF1901),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFFFF1901),
                    ),
                  ),
                ),
                const SizedBox(width: 70),

                GestureDetector(
                  onTap: ()async{
                    final selectedTemplateData = await showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (BuildContext context) {
                        return const CustomizeTemplateDialog();
                      },
                    );


                    if (selectedTemplateData != null) {
                      print('User selected: $selectedTemplate');
                      setState(() {
                        selectedTemplate=selectedTemplateData;
                      });
                      // TODO: Update your state, send API call, show toast, etc.
                    }                  },
                  child: Text(
                    'Customize Template',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFFF1901),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFFFF1901),
                    ),
                  ),
                ),

                const SizedBox(width: 5),
                SvgPicture.asset(
                  'assets/icons/fullscreen.svg',
                  height: 20,
                ),
              ],
            ),
          ),
          // Invoice Section (Modified to be Non-Editable)
          const SizedBox(height: 20),
          CustomInvoiceView(
            selecteTemplate :selectedTemplate,
            isEditable:true,
            initialItems: invoiceItems,
            initialTaxPercentage: taxPercentage,
            onSave: (updatedItems, updatedTax) {
              setState(() {
                invoiceItems = updatedItems;
                taxPercentage = updatedTax;
                taxController.text =
                    taxPercentage.toStringAsFixed(2);
              });
            },
          ),
          // Terms and Conditions Checkbox (unchanged)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 0.9, // shrink checkbox size a bit
                  child: Checkbox(
                    value: true,
                    onChanged: (bool? value) {},
                    activeColor: const Color(0xFFFF1901),
                    visualDensity: VisualDensity.compact, // reduce extra padding
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text:
                          'By sending this invoice further you are agreeing to the ',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        color: const Color(0xff9D9D9D),
                        fontWeight: FontWeight.w400,
                        height: 1.8,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11,
                            color: const Color(0xff007BFF),
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (BuildContext context) {
                                  return const TermsConditionsDialog();
                                },
                              );
                            },
                        ),
                        TextSpan(
                          text: ' of Encore Films.',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons (unchanged)

          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, ),
            child: Row(

              children: [
                CustomButton(isOutlined:true,text: 'Donwload', onPressed: (){},svgAsset:
                    'assets/icons/download2.svg',width: 100,height: 30,leftPadding: 0,
                 ),
                SizedBox(width: 30),
                CustomButton(isOutlined:true,text: 'Email', onPressed: (){},svgAsset:
                'assets/icons/mail_report.svg',width: 70,height: 30,leftPadding: 0,
                ),
                SizedBox(width: 30),
                CustomButton(isOutlined:true,text: 'Schedule', onPressed: (){
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (BuildContext context) {
                      return const ScheduleInvoiceDialog();
                    },
                  );
                },width: 80,height: 30,leftPadding: 0,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildLineField({required String label, required bool showPen}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 18, right: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              if (showPen)
                SvgPicture.asset(
                  'assets/icons/editor.svg',
                  height: 18,
                ),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(
            color: Color(0xFFE1E1E1),
            thickness: 1,
            height: 1,
          ),
        ],
      ),
    );
  }
}
