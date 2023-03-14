import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BabyTextFormField extends StatelessWidget {
  final String? initialValue;
  final String? hintText;
  final Color? hintTextColor;
  final int? maxLines;
  final bool? enabled;
  final TextAlign? textAlign;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final FocusNode? focusNode;

  const BabyTextFormField({
    Key? key,
    this.initialValue,
    this.hintText,
    this.hintTextColor,
    this.maxLines,
    this.textAlign,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
    this.enabled,
    this.controller,
    this.validator,
    this.onTap,
    this.onSaved,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      initialValue: initialValue,
      enabled: enabled,
      onTap: onTap,
      textAlign: textAlign ?? TextAlign.start,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintTextColor ?? Colors.grey[400],
        ),
        // filled: true,
        // fillColor: Colors.grey[100],
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFE0E0E0),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFE0E0E0),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
        suffixIcon: suffixIcon,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      controller: controller,
      onSaved: onSaved,
    );
  }
}
