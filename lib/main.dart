import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/src/pages/administration/admin_main_page/admin_main_page.dart';
import 'package:isati_integration/src/pages/captain/captain_main_page/captain_main_page.dart';
import 'package:isati_integration/src/pages/player/player_main_page/player_main_page.dart';
import 'package:isati_integration/src/pages/register_page/register_page.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/solo_challenges_store.dart';
import 'package:isati_integration/src/providers/solo_validations_store.dart';
import 'package:isati_integration/src/providers/team_challenges_store.dart';
import 'package:isati_integration/src/providers/team_validations_store.dart';
import 'package:isati_integration/src/providers/teams_ranking_store.dart';
import 'package:isati_integration/src/providers/teams_store.dart';
import 'package:isati_integration/src/providers/users_ranking_store.dart';
import 'package:isati_integration/src/providers/users_store.dart';
import 'package:isati_integration/src/shared/splash_screen.dart';
import 'package:isati_integration/utils/app_manager.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

// class DebugHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }

void main() {
  // HttpOverrides.global = DebugHttpOverrides();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: colorPrimaryVariant,
      statusBarBrightness: Brightness.dark,
    )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppUserStore()),
        ChangeNotifierProvider(create: (context) => UsersStore()),
        ChangeNotifierProvider(create: (context) => TeamsStore()),
        ChangeNotifierProvider(create: (context) => SoloChallengesStore()),
        ChangeNotifierProvider(create: (context) => SoloValidationsStore()),
        ChangeNotifierProvider(create: (context) => TeamChallengesStore()),
        ChangeNotifierProvider(create: (context) => TeamValidationsStore()),
        ChangeNotifierProvider(create: (context) => TeamsRankingStore()),
        ChangeNotifierProvider(create: (context) => UsersRankingStore()),
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Integration ISATI',
          navigatorKey: AppManager.instance.appNavigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme:  ColorScheme.fromSwatch(
              primarySwatch: colorSwatch(colorPrimary.value),
              accentColor: colorSecondary,
              cardColor: colorScaffolddWhite,
              backgroundColor: colorScaffoldGrey,
            ),

            primaryColor: colorPrimary,
            accentColor: colorSecondary,

            scaffoldBackgroundColor: colorScaffoldGrey,
            cardColor: colorScaffolddWhite,
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
              titleTextStyle: TextStyle(color: colorBlack, fontSize: 24)
            ),

            dividerTheme: const DividerThemeData(
              color: Color(0xffedf1f7),
              thickness: 1
            ),

            visualDensity: VisualDensity.standard, 
          ),
          home: FutureBuilder(
            future: Provider.of<AppUserStore>(context).loggedUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                ScreenUtils.instance.setValues(context);

                if (snapshot.hasError) {
                  Provider.of<AppUserStore>(context, listen: false).logout();
                  return Center(child: Text("Erreur lors du chargement de l'application : ${snapshot.error.toString()}"),);
                }

                if (!snapshot.hasData) {
                  return SafeArea(child: RegisterPage());
                }

                final User loggedUser = snapshot.data as User;

                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme:  ColorScheme.fromSwatch(
                      primarySwatch: colorSwatch(colorPrimary.value),
                      accentColor: colorSecondary,
                      cardColor: colorScaffolddWhite,
                      backgroundColor: colorScaffoldGrey,
                    ),

                    primaryColor: colorPrimary,
                  ),
                  child: Builder(
                    builder: (context) {
                      if (loggedUser.role == UserRoles.player) {
                        return SafeArea(child: PlayerMainPage());
                      }
                      else if (loggedUser.role == UserRoles.captain) {
                        return SafeArea(child: CaptainMainPage());
                      }
                      else if (loggedUser.role == UserRoles.admin) {
                        return SafeArea(child: AdminMainPage());
                      }
                      
                      Provider.of<AppUserStore>(context, listen: false).logout();
                      return Container();
                    },
                  ),
                );

              }

              return SplashScreen();
            }
          ),
        );
      }
    );
  }
}
