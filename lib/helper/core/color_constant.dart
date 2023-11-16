import 'package:flutter/material.dart';

class AppColoring {
  static MaterialColor primaryApp = const MaterialColor(
    0xff0000FF,
    <int, Color>{
      50: kAppColor,
      100: kAppColor,
      200: kAppColor,
      300: kAppColor,
      400: kAppColor,
      500: kAppColor,
      600: kAppColor,
      700: kAppColor,
      800: kAppColor,
      900: kAppColor,
    },
  );
  static const kAppColor = Color(0xff0000FF);
  static const kAppSecondaryColor = Color(0xff6ac5fe);
  static const kAppBlueColor = Color(0xffF1F9FE);
  static const kAppWhiteColor = Colors.white;
  static const primeryBorder = Color(0xff6ac5fe);

  //text color

  static const Color textDark = Color(0xFF191919);
  static const Color textLight = Color(0xFF434343);
  static const Color textDim = Color(0xFF7D7D7D);
  static const Color textRed = Color(0xFFFC2424);
  static const Color textGreen = Color.fromARGB(255, 36, 166, 49);
  static const Color dimLight = Color.fromARGB(255, 202, 203, 199);

  static const Color textwhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xffFAAC30);

  //popUpcolors
  static const Color successPopup = Colors.green;
  static const Color errorPopUp = Colors.red;
  static const Color black = Colors.black;
  static const lightBg = Color.fromARGB(255, 248, 251, 255);
}
