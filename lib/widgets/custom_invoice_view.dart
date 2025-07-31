import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/finance/invoice_model_screen.dart';
import 'package:harris_j_system/widgets/custom_button.dart'; // Adjust path as needed

class CustomInvoiceView extends StatefulWidget {
  final String selecteTemplate;
  final bool isEditable;
  final List<InvoiceItem> initialItems;
  final double initialTaxPercentage;
  final Function(List<InvoiceItem>, double) onSave;

  const CustomInvoiceView({
    super.key,
    required this.selecteTemplate,
    required this.isEditable,
    required this.initialItems,
    required this.initialTaxPercentage,
    required this.onSave,
  });

  @override
  State<CustomInvoiceView> createState() =>
      _CustomInvoiceViewState();
}

class _CustomInvoiceViewState
    extends State<CustomInvoiceView> {
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> feeControllers = [];
  late TextEditingController taxController;
  late double taxPercentage;

  @override
  void initState() {
    super.initState();
    taxPercentage = widget.initialTaxPercentage;

    for (var item in widget.initialItems) {
      nameControllers.add(TextEditingController(text: item.name));
      feeControllers.add(TextEditingController(text: item.fee.toStringAsFixed(2)));
    }
    taxController = TextEditingController(text: taxPercentage.toStringAsFixed(2));
  }

  double get subtotal {
    double sum = 0.0;
    for (var controller in feeControllers) {
      sum += double.tryParse(controller.text) ?? 0.0;
    }
    return sum;
  }

  double get taxAmount => subtotal * (taxPercentage / 100);
  double get total => subtotal - taxAmount;

  @override
  void dispose() {
    for (var c in nameControllers) c.dispose();
    for (var c in feeControllers) c.dispose();
    taxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          margin:  EdgeInsets.symmetric(horizontal: 20, vertical: widget.isEditable?0:35),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.25)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Image.asset(
                      'assets/icons/cons_logo.png',
                      height: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Invoice',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.montserrat(fontSize: 8, color: Colors.black),
                    children: [
                      TextSpan(text: 'Date: ', style: TextStyle(color: Color(0xff767676))),
                      const TextSpan(text: '01-04-2025'),
                      const WidgetSpan(child: SizedBox(width: 16)),
                      TextSpan(text: 'Due Date: ', style: TextStyle(color: Color(0xff767676))),
                      const TextSpan(text: '01-04-2025'),
                      const WidgetSpan(child: SizedBox(width: 16)),
                      TextSpan(text: 'Invoice#: ', style: TextStyle(color: Color(0xff767676))),
                      const TextSpan(text: '#EM098789'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                widget.selecteTemplate=="Template1"?Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    billFromWidget(
                      title: 'Bill From:',
                      companyName: 'Encore Films',
                      address: 'No.22,Abcd Street,RR Nager,Chennai-600016,Tamil Nadu,India',
                      location: 'X5JX+HX Chennai, Tamil Nadu',
                    ),
                    const SizedBox(width: 40),
                    billFromWidget(
                      title: 'Bill To:',
                      companyName: 'Encore Films',
                      address: 'No.22,Abcd Street,RR Nager,Chennai-600016,Tamil Nadu,India',
                      location: 'X5JX+HX Chennai, Tamil Nadu',
                    ),
                  ],
                ):
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    billTemp2Widget(
                      title: 'Bill From:',
                      companyName: 'Harris J System',
                      address: 'No.22,Abcd Street,RR Nager,Chennai-600016,Tamil Nadu,India',
                      code: 'X5JX+HX Chennai, Tamil Nadu',
                      color: Color.fromRGBO(255, 150, 27, 0.3),
                      textColor: Color(0xff0369D7),
                    ),
                    SizedBox(height: 10),
                    billTemp2Widget(
                      title: 'Bill To:',
                      companyName: 'Encore Films',
                      address: 'No.22,Abcd Street,RR Nager,Chennai-600016,Tamil Nadu,India',
                      code: 'X5JX+HX Chennai, Tamil Nadu',
                      color: Colors.grey.shade200,
                      textColor: Color(0xff1F9254),
                    ),
                  ],
                ),


                Container(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text('Name',
                            style: GoogleFonts.montserrat(
                                color: const Color(0xffA7A7A7), fontSize: 10, fontWeight: FontWeight.w500)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('Service Fee',
                            style: GoogleFonts.montserrat(
                                color: const Color(0xffA7A7A7), fontSize: 10, fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),

                // Editable rows
                for (int i = 0; i < nameControllers.length; i++)
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xffE1E1E1))),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            readOnly: widget.isEditable?true:false,
                            controller: nameControllers[i],
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff181818)),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            readOnly: widget.isEditable?true:false,
                            controller: feeControllers[i],
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              prefixText: '\$',
                            ),
                            style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xff181818)),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // Summary
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('Total Amount',
                              style: GoogleFonts.montserrat(color: const Color(0xffA7A7A7), fontSize: 10, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: Text('Tax %',
                              style: GoogleFonts.montserrat(color: const Color(0xffA7A7A7), fontSize: 10, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: Text('Total',
                              style: GoogleFonts.montserrat(color: const Color(0xffA7A7A7), fontSize: 10, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Divider(height: 1, color: Color(0xffE1E1E1)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text('\$${subtotal.toStringAsFixed(2)}',
                              style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ),
                        Expanded(
                          child: TextField(
                            readOnly: widget.isEditable?true:false,
                            controller: taxController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            onChanged: (v) => setState(() {
                              taxPercentage = double.tryParse(v) ?? 0.0;
                            }),
                            decoration: const InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              suffixText: '%',
                            ),
                            style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                        ),
                        Expanded(
                          child: Text('\$${total.toStringAsFixed(2)}',
                              style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Divider(height: 1, color: Color(0xffE1E1E1)),
                  ],
                ),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Billing Amt.',
                          style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w500, color: const Color(0xffA7A7A7))),
                      Text('\$${total.toStringAsFixed(2)}',
                          style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.w400)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Auto generated by the system',
                  style: GoogleFonts.spaceGrotesk(color: const Color(0xff9D9D9D), fontSize: 10, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),

        // Close button
    if(!widget.isEditable)    Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2)],
              ),
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.close, color: Colors.red, size: 14),
            ),
          ),
        ),

        // Save button
      if(!widget.isEditable)  Positioned(
          bottom: 0,
          right: 16,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff0369D7),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              List<InvoiceItem> updatedItems = [];
              for (int i = 0; i < nameControllers.length; i++) {
                updatedItems.add(InvoiceItem(
                  name: nameControllers[i].text,
                  fee: double.tryParse(feeControllers[i].text) ?? 0.0,
                ));
              }
              widget.onSave(updatedItems, taxPercentage);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.save, size: 14),
            label: const Text('Save'),
          ),
        ),
      ],
    );
  }

  Widget billFromWidget({title, companyName, address, location}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: title == 'Bill From:' ? const Color(0xff0369D7) : const Color(0xff1F9254),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            companyName,
            style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            address,
            style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 5),
          Text(
            location,
            style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget billTemp2Widget({
    required String title,
    required String companyName,
    required String address,
    required String code,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
        color:color,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 8,                // fixed font size
              color:textColor,   // fixed color
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                companyName,
                style: GoogleFonts.montserrat(
                  fontSize: 11,                // fixed font size
                  fontWeight: FontWeight.w600, // fixed weight
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Address row with location icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/location_marker.svg',
                            height: 5,
                            width: 5,
                            color: Color(0xffFF1901),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            address,
                            style: GoogleFonts.montserrat(
                              fontSize: 7, // fixed font size
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Code row with google_code icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/google_code.svg',
                            height: 5,
                            width: 5,
                            color: Color(0xffFF1901),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            code,
                            style: GoogleFonts.montserrat(
                              fontSize: 7, // fixed font size
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}