import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppTheme {
  static const TextStyle descriptionTextForSpecialistStyle = TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(42, 42, 42, 1),
      fontFamily: 'Plus Jakarta Sans',
      fontWeight: FontWeight.w600);
  static const TextStyle descriptionTextForInitalPage = TextStyle(
      fontSize: 24,
      color: Color.fromRGBO(42, 42, 42, 1),
      fontFamily: 'Plus Jakarta Sans',
      fontWeight: FontWeight.w800);
  static const TextStyle helperTextForUserStyle = TextStyle(
      fontSize: 14,
      color: Color.fromRGBO(42, 42, 42, 0.5),
      fontFamily: 'Plus Jakarta Sans',
      fontWeight: FontWeight.w400);
  static const TextStyle helperTextForInitialStyle = TextStyle(
      fontSize: 16,
      color: Color.fromRGBO(42, 42, 42, 0.5),
      fontFamily: 'Plus Jakarta Sans',
      fontWeight: FontWeight.w400);
  static const TextStyle homePageUserNameTextStyle = TextStyle(
    fontSize: 16,
    color: Color.fromRGBO(0, 0, 0, 1),
    fontFamily: 'Plus Jakarta Sans',
  );
  static const TextStyle homePageOverviewResultTextStyle = TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(0, 0, 0, 1),
      fontFamily: 'Plus Jakarta Sans',
      fontWeight: FontWeight.w500);
  static const TextStyle homePageOverviewUnitTextStyle = TextStyle(
    fontSize: 12,
    color: Color.fromRGBO(0, 0, 0, 1),
    fontFamily: 'Plus Jakarta Sans',
  );
  static const TextStyle floatingActionButtonAlertText = TextStyle(
    fontSize: 10,
    color: Color.fromRGBO(0, 0, 0, 1),
    fontFamily: 'Plus Jakarta Sans',
  );
  static const TextStyle blogDescriptionForBlogReccomdation = TextStyle(
    fontSize: 12,
    color: Color.fromRGBO(0, 0, 0, 0.5),
    fontFamily: 'Plus Jakarta Sans',
  );
  // static const TextStyle buttomNavBarTextStyle = TextStyle(
  //   fontSize: 14,
  //   fontWeight: ,
  //   color: Color.fromRGBO(0, 0, 0, 1),
  //   fontFamily: 'Manrope',
  // );
  static const ButtonStyle buttonStyleForAppBarBackButto = ButtonStyle(
      iconColor: MaterialStatePropertyAll(Color.fromRGBO(110, 182, 255, 1)),
      backgroundColor:
          MaterialStatePropertyAll(Color.fromRGBO(219, 237, 255, 1)));
  static const FloatingActionButtonThemeData buttonStyleForFloatingActionBtn =
      FloatingActionButtonThemeData(
    foregroundColor: Color.fromRGBO(219, 237, 255, 1),
    backgroundColor: Color.fromRGBO(110, 182, 255, 1),
  );

  static const CardTheme cardThemeForDevs =
      CardTheme(color: Color.fromRGBO(219, 237, 255, 1));
  static const BoxDecoration cardThemeForHomeScreenOverview = BoxDecoration(
      gradient: LinearGradient(
    colors: [
      Color.fromRGBO(183, 216, 249, 0.786),
      Color.fromRGBO(255, 255, 255, 1)
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ));
  static const SvgTheme svgThemeForBottomNavBar = SvgTheme(
    currentColor: Color.fromRGBO(110, 182, 255, 1),
  );
}
