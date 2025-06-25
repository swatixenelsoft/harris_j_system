import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final AutovalidateMode autoValidateMode;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final bool enableInteractiveSelection;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final int? maxLines;
  final bool useUnderlineBorder;
  final double padding;
  final double borderRadius;

  const CustomTextField({
    super.key,
    this.label = "",
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.validator,
    this.focusNode,
    this.onChanged,
    this.readOnly = false,
    this.enableInteractiveSelection = true,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.maxLines = 1,
    this.useUnderlineBorder = false,
    this.padding = 0,
    this.borderRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: TextFormField(
        maxLines: maxLines,
        readOnly: readOnly,
        enableInteractiveSelection: enableInteractiveSelection,
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        autovalidateMode: autoValidateMode,
        focusNode: focusNode,
        onTap: onTap,
        onChanged: (value) {
          final trimmedValue = value.trimLeft();
          if (value != trimmedValue) {
            controller.value = controller.value.copyWith(
              text: trimmedValue,
              selection: TextSelection.collapsed(offset: trimmedValue.length),
            );
          }
          if (onChanged != null) {
            onChanged!(trimmedValue);
          }
        },
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xff000000),
        ),
        decoration: InputDecoration(
          contentPadding: useUnderlineBorder
              ? null
              : const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          floatingLabelStyle: GoogleFonts.montserrat(
            color: useUnderlineBorder
                ? const Color(0xff1D212D)
                : const Color.fromRGBO(0, 0, 0, 0.4),
            fontSize: 12,
            fontWeight: useUnderlineBorder ? FontWeight.w600 : FontWeight.w400,
          ),
          labelStyle: GoogleFonts.montserrat(
            color: useUnderlineBorder
                ? const Color(0xff1D212D)
                : const Color.fromRGBO(0, 0, 0, 0.4),
            fontSize: 12,
            fontWeight: useUnderlineBorder ? FontWeight.w600 : FontWeight.w400,
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xff000000),
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          border: useUnderlineBorder
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff000000)),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Color(0xffE8E6EA)),
                ),
          focusedBorder: useUnderlineBorder
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff000000)),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Color(0xffE8E6EA)),
                ),
          enabledBorder: useUnderlineBorder
              ? const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff000000)),
                )
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                  borderSide: const BorderSide(color: Color(0xffE8E6EA)),
                ),
        ),
      ),
    );
  }
}
