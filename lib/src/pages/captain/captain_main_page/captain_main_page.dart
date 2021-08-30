import 'package:flutter/material.dart';
import 'package:isati_integration/models/page_item.dart';
import 'package:isati_integration/src/pages/main_page/main_page.dart';
import 'package:isati_integration/src/pages/team_challenges_page/team_challenges_page.dart';
import 'package:isati_integration/src/pages/waiting_solo_validations_page/waiting_solo_validation_page.dart';
import 'package:isati_integration/utils/app_manager.dart';

class CaptainMainPage extends StatelessWidget {
  final List<Widget> pages = [
    ClipRect(
      child: Navigator(
        key: AppManager.instance.soloWaitingValidationsKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => const WaitingSoloValidationsPage()
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
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MainPage(
      pageItems: pageItems,
      pages: pages
    );
  }
}