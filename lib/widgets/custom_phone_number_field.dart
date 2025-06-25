import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomPhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onCountryChanged;

  const CustomPhoneNumberField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onCountryChanged,
  });


  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value)) {
      return 'Enter a valid phone number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: (value) => _validatePhoneNumber(controller.text),
        autovalidateMode:AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> fieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntlPhoneField(
              controller: controller,
              showDropdownIcon: false,
              dropdownTextStyle: GoogleFonts.montserrat(
                color: const Color.fromRGBO(0, 0, 0, 0.4),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: "Mobile Number",
                labelStyle: GoogleFonts.montserrat(
                  color: const Color.fromRGBO(0, 0, 0, 0.4),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xffE8E6EA)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xffE8E6EA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xffE8E6EA)),
                ),
                errorText: fieldState.errorText, // Shows the validation error
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              disableLengthCheck: true,
              initialCountryCode: 'US',
              onChanged: (phone) {
                if (onChanged != null) {
                  onChanged!(phone.completeNumber);
                }
                fieldState.didChange(phone.completeNumber); // Update field state
              },
              onCountryChanged: (country) {
                if (onCountryChanged != null) {
                  onCountryChanged!(country.dialCode);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
