import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isati_integration/src/pages/main_page/main_page.dart';
import 'package:isati_integration/src/pages/register_page/register_page.dart';
import 'package:isati_integration/src/providers/user_store.dart';
import 'package:isati_integration/src/shared/splash_screen.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class DebugHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() {
  HttpOverrides.global = DebugHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserStore()),
      ],
      builder: (context, child) {
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
          home: FutureBuilder(
            future: Provider.of<UserStore>(context).loggedUser,
            builder: (context, snapshot) {
              ScreenUtils.instance.setValues(context);

              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return SafeArea(child: RegisterPage());
                }

                return SafeArea(child: MainPage());
              }

              return SplashScreen();
            }
          ),
        );
      }
    );
  }
}
