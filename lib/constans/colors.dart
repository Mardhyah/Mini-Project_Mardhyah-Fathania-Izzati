import 'package:flutter/material.dart';

const appPurple = Color(0xFF431AA1);

const appWhite = Color(0xFFFAF8FC);
const appPurpleDark = Color(0xFF1e0771);

const appPurpleLight1 = Color(0xFF9345F2);
const appPurpleLight2 = Color(0xFFB9A2D8);
const appOrange = Color(0xFFE6704A);

ThemeData appLight = ThemeData(
  primaryColor: appPurple,
  scaffoldBackgroundColor: appWhite,
  appBarTheme: const AppBarTheme(
    backgroundColor: appPurple,
  ),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: appPurpleDark,
      ),
      bodyMedium: TextStyle(
        color: appPurpleDark,
      )),
);

ThemeData appDark = ThemeData(
  primaryColor: appPurple,
  scaffoldBackgroundColor: appPurpleDark,
  appBarTheme: const AppBarTheme(
    backgroundColor: appPurpleDark,
  ),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: appWhite,
      ),
      bodyMedium: TextStyle(
        color: appWhite,
      )),
);
