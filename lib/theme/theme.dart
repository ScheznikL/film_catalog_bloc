import 'package:flutter/material.dart';

ThemeData themeIndigo () {
  return ThemeData(
//Segoe UI
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo.shade900),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: 15,
        fontFamily: "Tw Cen MT",
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    ),
    useMaterial3: true,
  );
}