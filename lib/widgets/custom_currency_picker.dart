import 'package:flutter/material.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class CurrencyPickerField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onCurrencyChanged;
  final String? Function(String?)? validator;
  final bool readOnly;
  final String? initialCurrencyCode;

  const CurrencyPickerField({
    super.key,
    required this.controller,
    this.onCurrencyChanged,
    this.validator,
    this.readOnly = false,
    this.initialCurrencyCode,
  });

  @override
  State<CurrencyPickerField> createState() => _CurrencyPickerFieldState();
}

class _CurrencyPickerFieldState extends State<CurrencyPickerField> {
  late Currency _selectedCurrency;

  @override
  void initState() {
    super.initState();

    final defaultCode = widget.initialCurrencyCode ?? 'SGD';

    _selectedCurrency = Currency(
      code: defaultCode,
      name: _getCurrencyName(defaultCode),
      symbol: _getCurrencySymbol(defaultCode),
      flag: _getFlagEmoji(defaultCode.substring(0, 2)), // ✅ Dynamic flag
      decimalDigits: 2,
      number: 702,
      namePlural: _getCurrencyName(defaultCode),
      symbolOnLeft: true,
      spaceBetweenAmountAndSymbol: true,
      decimalSeparator: '.',
      thousandsSeparator: ',',
    );
  }

  /// ✅ Convert country code to emoji flag automatically
  String _getFlagEmoji(String countryCode) {
    final code = countryCode.toUpperCase();
    // Convert A-Z into Regional Indicator Symbols
    return code.runes.map((rune) => String.fromCharCode(rune + 127397)).join();
  }

  /// ✅ Get currency name
  String _getCurrencyName(String code) {
    switch (code) {
      case 'USD':
        return 'US Dollar';
      case 'GBP':
        return 'British Pound';
      case 'EUR':
        return 'Euro';
      case 'INR':
        return 'Indian Rupee';
      case 'SGD':
        return 'Singapore Dollar';
      case 'AUD':
        return 'Australian Dollar';
      case 'CAD':
        return 'Canadian Dollar';
      case 'JPY':
        return 'Japanese Yen';
      case 'CNY':
        return 'Chinese Yuan';
      case 'AED':
        return 'UAE Dirham';
      default:
        return code;
    }
  }

  /// ✅ Get currency symbol
  String _getCurrencySymbol(String code) {
    switch (code) {
      case 'USD':
        return '\$';
      case 'GBP':
        return '£';
      case 'EUR':
        return '€';
      case 'INR':
        return '₹';
      case 'SGD':
        return '\$';
      case 'AUD':
        return '\$';
      case 'CAD':
        return '\$';
      case 'JPY':
        return '¥';
      case 'CNY':
        return '¥';
      case 'AED':
        return 'د.إ';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffE8E8E8)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),

          /// 🔹 Amount Input Field
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              validator: widget.validator,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              readOnly: widget.readOnly,
              decoration: InputDecoration(
                hintText: 'Choose Currency',
                hintStyle: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xffA2A2A2),
                ),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.number,
            ),
          ),

          const SizedBox(width: 8),

          /// 🔹 Show selected currency code
          Text(
            _selectedCurrency.code,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),

          const SizedBox(width: 8),

          /// 🔹 Flag + Dropdown Icon
          InkWell(
            onTap: () {
              showCurrencyPicker(
                context: context,
                showFlag: true,
                showCurrencyName: true,
                theme: CurrencyPickerThemeData(
                  backgroundColor: Colors.white
                ),
                showCurrencyCode: true,
                onSelect: (Currency currency) {
                  setState(() {
                    _selectedCurrency = currency;
                    // ✅ Update flag dynamically
                    _selectedCurrency = Currency(
                      code: currency.code,
                      name: currency.name,
                      symbol: currency.symbol,
                      flag: _getFlagEmoji(currency.code.substring(0, 2)),
                      decimalDigits: currency.decimalDigits,
                      number: currency.number,
                      namePlural: currency.namePlural,
                      symbolOnLeft: currency.symbolOnLeft,
                      spaceBetweenAmountAndSymbol:
                      currency.spaceBetweenAmountAndSymbol,
                      decimalSeparator: currency.decimalSeparator,
                      thousandsSeparator: currency.thousandsSeparator,
                    );
                  });

                  if (widget.onCurrencyChanged != null) {
                    widget.onCurrencyChanged!(currency.code);
                  }
                },
              );
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(168, 185, 202, 0.21),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              child: Row(
                children: [
                  /// ✅ Flag emoji
                  Text(
                    _getFlagEmoji(_selectedCurrency.code.substring(0, 2)),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 25,
                    color: Color(0xffA8B9CA),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
