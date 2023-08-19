import 'package:flutter/material.dart';

class AppTheme {
  static const TextStyle descriptionTextForSpecialistStyle = TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(42, 42, 42, 1),
      fontFamily: 'Plus Jakarta Sans',
      fontWeight: FontWeight.w600);
  static const TextStyle helperTextForUserStyle = TextStyle(
      fontSize: 14,
      color: Color.fromRGBO(42, 42, 42, 0.5),
      fontFamily: 'Plus Jakarta Sans',
      fontWeight: FontWeight.w400);
  static const ButtonStyle buttonStyleForAppBarBackButto = ButtonStyle(
      iconColor: MaterialStatePropertyAll(Color.fromRGBO(110, 182, 255, 1)),
      backgroundColor:
          MaterialStatePropertyAll(Color.fromRGBO(219, 237, 255, 1)));
  static const CardTheme cardThemeForDevs =
      CardTheme(color: Color.fromRGBO(219, 237, 255, 1));
}
