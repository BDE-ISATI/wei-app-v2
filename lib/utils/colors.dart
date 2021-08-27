import 'package:flutter/material.dart';

MaterialColor colorSwatch(int value) {
  final color50 = Color(value).withOpacity(0.1);
  final color100 = Color(value).withOpacity(0.2);
  final color200 = Color(value).withOpacity(0.3);
  final color300 = Color(value).withOpacity(0.4);
  final color400 = Color(value).withOpacity(0.5);
  final color500 = Color(value).withOpacity(0.6);
  final color600 = Color(value).withOpacity(0.7);
  final color700 = Color(value).withOpacity(0.8);
  final color800 = Color(value).withOpacity(0.8);
  final color900 = Color(value).withOpacity(1);

  return MaterialColor(value, <int, Color>{
    50:color50,
    100:color100,
    200:color200,
    300:color300,
    400:color400,
    500:color500,
    600:color600,
    700:color700,
    800:color800,
    900:color900,
  });
}

Color colorPrimary = const Color(0xfff70c35);
const Color colorPrimaryVariant = Color(0xffaa0824);
const Color colorSecondary = Color(0xff0078ab);
const Color colorSecondaryVariant = Color(0xff3a6c88);
const Color colorScaffolddWhite = Color(0xffffffff);
const Color colorScaffoldGrey = Color(0xfff5f5f6);

const Color colorBlack = Color(0xff2c3e50);
const Color colorWhite = Color(0xffffffff);
const Color colorYellow = Color(0xfff4bd2a);

const Color colorSuccess = Color(0xffd4edda);
const Color colorBorderSuccess = Color(0xffc2e5ca);
const Color colorTextSuccess = Color(0xff155724);

const Color colorError = Color(0xfff8d7da);
const Color colorBorderError = Color(0xfff4c2c7);
const Color colorTextError = Color(0xff721c24);

const Color colorInfo = Color(0xffd1ecf1);
const Color colorBorderInfo = Color(0xffbde4eb);
const Color colorTextInfo = Color(0xff0c5460);

const Color colorGreyBackground = Color(0xffebeced);
const Color colorGreyText = Color(0xff949c9e);
const Color colorBlueGrey = Color(0xff6e8faf);

Color darkenColor(Color c, {int percent = 10}) {
    assert(1 <= percent && percent <= 100);
    
    final f = 1 - percent / 100;
    
    return Color.fromARGB(
        c.alpha,
        (c.red * f).round(),
        (c.green  * f).round(),
        (c.blue * f).round()
    );
}

Color brightenColor(Color c, {int percent = 10}) {
    assert(1 <= percent && percent <= 100);
    
    final  p = percent / 100;
    
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round()
    );
}

/// See https://api.flutter.dev/flutter/material/ThemeData/estimateBrightnessForColor.html
bool colorIsDark(Color color) {
  final double relativeLuminance = color.computeLuminance();

  // See <https://www.w3.org/TR/WCAG20/#contrast-ratiodef>
  // The spec says to use kThreshold=0.0525, but Material Design appears to bias
  // more towards using light text than WCAG20 recommends. Material Design spec
  // doesn't say what value to use, but 0.15 seemed close to what the Material
  // Design spec shows for its color palette on
  // <https://material.io/go/design-theming#color-color-palette>.
  const double kThreshold = 0.15;
  if ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) > kThreshold) {
    return false;
  }

  return true;
}

extension ColorExtension on String {
  Color toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }

    return const Color(0xfff70c35);
  }
}