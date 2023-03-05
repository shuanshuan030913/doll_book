import 'package:flutter/material.dart';

/// 主色
const primaryColorInt = 0xFFFA9EB3;
const primaryColor = Color(primaryColorInt);

/// 線條色
const borderColor = Color.fromARGB(255, 254, 176, 195);

MaterialColor customColor = const MaterialColor(
  primaryColorInt, // Primary color value
  <int, Color>{
    50: Color(0xFFE8F1F5),
    100: Color(0xFFC5D8E3),
    200: Color(0xFF9FBED1),
    300: Color(0xFF79A4BF),
    400: Color(0xFF5E93B2),
    500: Color(primaryColorInt),
    600: Color(0xFF3C769B),
    700: Color(0xFF346C91),
    800: Color(0xFF2C6287),
    900: Color(0xFF1F516E),
  },
);

final customThemeData = ThemeData(
  primaryColor: primaryColor,
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
    ),
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: customColor)
      .copyWith(secondary: const Color(primaryColorInt)),
  splashColor: Colors.grey[300],
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
      color: Colors.white,
    )),
  ),
);
