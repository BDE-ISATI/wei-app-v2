import 'package:flutter/material.dart';

class ScreenUtils {
  ScreenUtils._privateConstructor();

  static final ScreenUtils instance = ScreenUtils._privateConstructor();

  double horizontalPadding = 15;

  int breakpointPC = 768;
  int breakpointTablet = 481;
  
  void setValues(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width > breakpointPC) {
      horizontalPadding = 32;
    }
    else if (width > breakpointTablet) {
      horizontalPadding = 24;
    }
  }
  
  EdgeInsets get defaultPadding {
    return EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20);
  }

  int responsiveCrossAxisCount(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    if (width > 1400) {
      return 6;
    }
    if (width > 1200) {
      return 5;
    }
    else if (width > 1000) {
      return 4;
    }
    else if (width > 800) {
      return 3;
    }

    return 2;
  }
}