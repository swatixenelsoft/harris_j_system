import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class CountryCodePhoneField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onCountryCodeChanged;
  final String? Function(String?)? validator;
  final bool readOnly;


  const CountryCodePhoneField({
    super.key,
    required this.controller,
    this.onCountryCodeChanged,
    this.validator,
    this.readOnly = false,
  });

  @override
  State<CountryCodePhoneField> createState() => _CountryCodePhoneFieldState();
}

class _CountryCodePhoneFieldState extends State<CountryCodePhoneField> {
  Country _selectedCountry = Country(
    phoneCode: '65',
    countryCode: 'SG',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Singapore',
    example: '12345678',
    displayName: 'Singapore',
    displayNameNoCountryCode: 'Singapore',
    e164Key: '',
  );

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
          InkWell(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (Country country) {
                  setState(() {
                    _selectedCountry = country;
                  });
                  if (widget.onCountryCodeChanged != null) {
                    widget.onCountryCodeChanged!('+${country.phoneCode}');
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
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    _selectedCountry.flagEmoji,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 25,color: Color(0xffA8B9CA),),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextFormField(

              controller: widget.controller,
              validator: widget.validator,
              style:  GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xff000000),
              ),
              readOnly: widget.readOnly,
              decoration: InputDecoration(
                prefixText: '+${_selectedCountry.phoneCode} ', // show country code
                prefixStyle: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff000000),
                ),

                hintText: ''
                    'Mobile Number',
                hintStyle: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xffA2A2A2),
                ),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.phone,
            ),
          ),
        ],
      ),
    );
  }
}
