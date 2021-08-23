import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isati_integration/src/pages/register_page/register_page.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:isati_integration/utils/screen_utils.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: colorPrimary,
          primaryVariant: colorPrimaryVariant,
          onPrimary: colorWhite,
          secondary: colorSecondary,
          secondaryVariant: colorSecondaryVariant,
          onSecondary: colorWhite,
          background: colorScaffolddWhite,
          onBackground: colorBlack,
          error: colorError,
          onError: colorWhite,
          surface: colorScaffolddWhite,
          onSurface: colorBlack
        ),

        scaffoldBackgroundColor: colorScaffolddWhite,
        dividerColor: const Color(0xffefefef),

        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 36, color: colorBlack),
          headline2: TextStyle(fontSize: 32, color: colorBlack),
          headline3: TextStyle(fontSize: 28, color: colorBlack),
          headline4: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: colorBlack),
          headline5: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: colorBlack),
          headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: colorBlack),
          bodyText2: TextStyle(fontSize: 16),
          button: TextStyle(fontSize: 16)
        ),

        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          color: colorScaffolddWhite,
          elevation: 0,
          iconTheme: IconThemeData(color: colorBlack),
          titleTextStyle: TextStyle(color: colorBlack, fontSize: 40)
        ),

        dividerTheme: const DividerThemeData(
          color: Color(0xffedf1f7),
          thickness: 1
        ),

        visualDensity: VisualDensity.standard, 
      ),
      home: Builder(
        builder: (context) {
          ScreenUtils.instance.setValues(context);

          return SafeArea(child: RegisterPage());
        }
      ),
    );
  }
}
