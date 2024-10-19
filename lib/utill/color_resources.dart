import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/theme/controllers/theme_controller.dart';

class ColorResources {
  static const Color colorGrey = Color(0xFFA0A4A8);
  static const Color colorBlack = Color(0xFF000000);
  static const Color colorNero = Color(0xFF1F1F1F);
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorHint = Color(0xFF52575C);
  static const Color searchBg = Color(0xFFF4F7FC);
  static const Color colorGreyWhite = Color(0xFFCACCCF);
  static const Color colorGray = Color(0xff6E6E6E);
  static const Color colorOxfordBlue = Color(0xff282F39);
  static const Color colorGainsB = Color(0xffE8E8E8);
  static const Color colorNigherRider = Color(0xff303030);
  static const Color backgroundColor = Color(0xffF4F7FC);
  static const Color colorGreyBunker = Color(0xff25282B);
  static const Color colorGreyChateau = Color(0xffA0A4A8);
  static const Color borderColor = Color(0xFFDCDCDC);
  static const Color disableColor = Color(0xFF979797);

  static Color getPrimary(BuildContext context) {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFF1B7FED) : Theme.of(context).primaryColor;
  }

  static Color getTextColor(BuildContext context) {
    return Get.find<ThemeController>().darkTheme ? const Color(0xFFE4E8EC) : const Color(0xFF4B566B);
  }

  static const Map<int, Color> colorMap = {
    50: Color(0x101455AC),
    100: Color(0x201455AC),
    200: Color(0x301455AC),
    300: Color(0x401455AC),
    400: Color(0x501455AC),
    500: Color(0x601455AC),
    600: Color(0x701455AC),
    700: Color(0x801455AC),
    800: Color(0x901455AC),
    900: Color(0xff1455AC),
  };

}
