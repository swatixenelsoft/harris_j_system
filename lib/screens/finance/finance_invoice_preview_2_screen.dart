import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/finance/invoice_model_screen.dart';
import 'package:harris_j_system/widgets/custom_button.dart'; // Adjust path as needed


class FinanceInvoicePreview2Screen extends StatefulWidget {
  final List<InvoiceItem> initialItems;
  final double initialTaxPercentage;
  final Function(List<InvoiceItem>, double) onSave;

  const FinanceInvoicePreview2Screen({
    super.key,
    required this.initialItems,
    required this.initialTaxPercentage,
    required this.onSave,
  });

  @override
  State<FinanceInvoicePreview2Screen> createState() =>
      _FinanceInvoicePreview2ScreenState();
}

class _FinanceInvoicePreview2ScreenState
    extends State<FinanceInvoicePreview2Screen> {
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
      feeControllers.add(
          TextEditingController(text: item.fee.toStringAsFixed(2)));
    }

    taxController =
        TextEditingController(text: taxPercentage.toStringAsFixed(2));
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
    for (var c in nameControllers) {
      c.dispose();
    }
    for (var c in feeControllers) {
      c.dispose();
    }
    taxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black26),
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
                const SizedBox(height: 16),
                Text(
                  'Invoice',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Date: 01-04-2025',
                        style: GoogleFonts.montserrat(fontSize: 10)),
                    Text('Due Date: 01-04-2025',
                        style: GoogleFonts.montserrat(fontSize: 10)),
                    Text('Invoice#: #EM098789',
                        style: GoogleFonts.montserrat(fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildAddressBlock(
                        title: 'Bill From:',
                        name: 'Encore Films',
                        address:
                        'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India\nX5JX+HX Chennai, Tamil Nadu',
                        color: const Color(0xff007BFF),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildAddressBlock(
                        title: 'Bill To:',
                        name: 'Encore Films',
                        address:
                        'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India\nX5JX+HX Chennai, Tamil Nadu',
                        color: const Color(0xff28A745),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    _buildTableHeader(),
                    for (int i = 0; i < nameControllers.length; i++)
                      _buildEditableRow(i),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSummary(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Billing Amt.',
                        style: GoogleFonts.montserrat(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    'Auto generated by the system',
                    style:
                    GoogleFonts.spaceGrotesk(color: Colors.grey, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                  )
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: CustomButton(
            text: 'Save',
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
            width: 100,
            height: 40,
            borderRadius: 6,
            icon: Icons.save,
            textStyle: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressBlock({
    required String title,
    required String name,
    required String address,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.montserrat(fontSize: 12, color: color)),
        const SizedBox(height: 4),
        Text(name,
            style: GoogleFonts.montserrat(
                fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(address, style: GoogleFonts.montserrat(fontSize: 13)),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text('Name',
                style: GoogleFonts.montserrat(color: Colors.grey)),
          ),
          Expanded(
            flex: 2,
            child: Text('Service Fee',
                style: GoogleFonts.montserrat(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableRow(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: nameControllers[index],
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: feeControllers[index],
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                prefixText: '\$',
              ),
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('Subtotal',
                  style: GoogleFonts.montserrat(color: Colors.grey),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('Tax Deduction %',
                  style: GoogleFonts.montserrat(color: Colors.grey),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              child: Text('Total',
                  style: GoogleFonts.montserrat(color: Colors.grey),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Divider(height: 32, color: Colors.grey),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('\$${subtotal.toStringAsFixed(2)}',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              child: TextField(
                controller: taxController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    taxPercentage = double.tryParse(value) ?? 0.0;
                  });
                },
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  suffixText: '%',
                ),
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text('\$${total.toStringAsFixed(2)}',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
        const Divider(height: 32),
      ],
    );
  }
}