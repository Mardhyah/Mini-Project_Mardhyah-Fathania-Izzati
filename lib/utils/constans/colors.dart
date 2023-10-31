import 'package:flutter/material.dart';

const appPurple = Color(0xFFB0578D);

const appWhite = Color(0xFFFAF8FC);
const appPurpleDark = Color(0xFFB0578D);

const appPurpleLight1 = Color(0xFFD988B9);
const appPurpleLight2 = Color(0xFFB9A2D8);

const text = Color.fromARGB(255, 70, 32, 55);

ThemeData appLight = ThemeData(
  primaryColor: appPurpleDark,
  scaffoldBackgroundColor: appWhite,
  appBarTheme: const AppBarTheme(
    backgroundColor: appPurple,
  ),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: text,
      ),
      bodyMedium: TextStyle(
        color: text,
      )),
);
