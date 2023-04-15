import 'package:flutter/material.dart';

class Palette {
  static const Color bottomSelectedColor = Color.fromRGBO(63, 66, 72, 1);
  static const Color bottomUnselectedColor = Color.fromRGBO(204, 210, 223, 1);
  static const Color boxContainerColor = Color.fromRGBO(238, 241, 244, 0.729);
}

class TextStyles {
  static const TextStyle underlineTextStyle = TextStyle(
    color: Color(0xFFC3C3C3),
    decoration: TextDecoration.underline,
    decorationThickness: 1.5,
  );
  static const TextStyle appbarTextStyle = TextStyle(
      color: Colors.black54, fontSize: 20, fontStyle: FontStyle.italic);

  static const splashScreenTextStyle = TextStyle(
      color: Color.fromARGB(196, 0, 0, 0),
      fontSize: 33,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      letterSpacing: 1.4);

  static const TextStyle homeTitleTextStyle =
      TextStyle(color: Colors.black87, fontSize: 17);

  static const TextStyle editProfileTitleTextStyle = TextStyle(
      color: Color.fromARGB(221, 26, 26, 26),
      fontSize: 14,
      fontWeight: FontWeight.w600);

  static const TextStyle appbarIconTextStyle =
      TextStyle(color: Colors.blue, fontSize: 17, fontWeight: FontWeight.w500);
}
