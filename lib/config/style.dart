import 'package:flutter/material.dart';

class Palette {
  static const Color bottomSelectedColor = Color.fromRGBO(63, 66, 72, 1);
  static const Color bottomUnselectedColor = Color.fromRGBO(204, 210, 223, 1);
}

class TextStyles {
  static const TextStyle underlineTextStyle = TextStyle(
    color: Color(0xFFC3C3C3),
    decoration: TextDecoration.underline,
    decorationThickness: 1.5,
  );
  static const TextStyle appbarTextStyle =
      TextStyle(color: Colors.black54, fontSize: 20);

  static const TextStyle homeTitleTextStyle = TextStyle(
      color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600);
}
