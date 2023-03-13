import 'package:doll_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ListSwitch extends StatelessWidget {
  final String activeText;
  final String inactiveText;
  final bool value;
  final Function(bool) onToggle;

  const ListSwitch({
    super.key,
    required this.value,
    required this.onToggle,
    required this.activeText,
    required this.inactiveText,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 86,
      height: 26,
      padding: 3,
      value: value,
      onToggle: onToggle,
      showOnOff: true,
      activeText: activeText,
      inactiveText: inactiveText,
      activeTextColor: Colors.white,
      inactiveTextColor: Colors.white,
      activeTextFontWeight: FontWeight.normal,
      inactiveTextFontWeight: FontWeight.normal,
      valueFontSize: 12,
      activeColor: primaryColor,
      inactiveColor: Colors.grey,
    );
  }
}
