import 'package:flutter/material.dart';
import 'package:isati_integration/models/page_item.dart';
import 'package:isati_integration/src/pages/app_user_edit_profile_page/app_user_edit_profile_page.dart';
import 'package:isati_integration/src/pages/main_page/main_page.dart';
import 'package:isati_integration/src/pages/player/solo_challenges_page/solo_challenges_page.dart';
import 'package:isati_integration/src/pages/team_challenges_page/team_challenges_page.dart';
import 'package:isati_integration/utils/app_manager.dart';

class PlayerMainPage extends StatelessWidget {
  final List<Widget> pages = [
    ClipRect(
      child: Navigator(
        key: AppManager.instance.playerSoloChallengesKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => const SoloChallengesPage()
        ),
      ),
    ),
    ClipRect(
      child: Navigator(
        key: AppManager.instance.teamChallengesKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => const TeamChallengesPage()
        ),
      ),
    ),
    ClipRect(
      child: Navigator(
        key: AppManager.instance.profileKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => AppUserEditProfilePage()
        ),
      ),
    ),
  ];

  final List<PageItem> pageItems = const [
    PageItem(
      index: 0,
      title: "Défis solo",
      icon: Icons.pool
    ),
    PageItem(
      index: 1,
      title: "Défis d'équipe",
      icon: Icons.people
    ),
    PageItem(
      index: 2,
      title: "Mon profil",
      icon: Icons.account_circle
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MainPage(
      pageItems: pageItems,
      pages: pages
    );
  }
}