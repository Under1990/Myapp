import 'package:flutter/material.dart';

///สีที่ต้องการ
class ColorManager {
  Color primaryColor = const Color(0xFF59ceb1);
  Color backgroundPrimaryColor = Color(0xFF31c5a3);
  Color secondaryColor = Colors.white;
  Color backgroundColor = Colors.white;
  Color textColor = Colors.black;
  Color borderColor = Color(0xFFA90000);
  Color textColorBlack700 = Color(0xFF333333);
  Color textColorAnnotation = Color(0xFFec1313);
  Color lineSeparate = Color(0xFFe6e6e6);
  Color cardbackgroundColor = Color(0xffF0FFFA);
  Color textColorGrey = Color(0xFF808080);
  Color bgColorTakePic = Color(0xFFF5F5F5);
  Color bgColorIconSuccess = Color(0xFFE0FFF4);

  //status order
  Color statusActivateColor = Color(0xFFe99a00);
  Color bgActivateColor = Color(0xFFFCFEF2);
  Color starColorGradient = Color(0xFFFFE600);
  Color starColorGradient2 = Color(0xFFFFB800);


  static Color messageColor(bool isMe) {
    return isMe ? Colors.white : Colors.black;
  }
}

class FontSizeManager {
  double headerSize = 24;
  double defaultSize = 18;
  double textLSize = 16;
  double textMSize = 14;
  double textSSize = 12;
}