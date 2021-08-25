import 'package:flutter/material.dart';
import 'package:isati_integration/models/page_item.dart';
import 'package:isati_integration/src/pages/administration/admin_solo_challenges_page.dart/admin_solo_challenges_page.dart';
import 'package:isati_integration/src/pages/administration/admin_team_challenges_page.dart/admin_team_challenge_page.dart';
import 'package:isati_integration/src/pages/administration/admin_teams_page/admin_teams_page.dart';
import 'package:isati_integration/src/pages/main_page/main_page.dart';
import 'package:isati_integration/src/pages/team_challenges_page/team_challenges_page.dart';
import 'package:isati_integration/src/pages/waiting_solo_validations_page/waiting_solo_validation_page.dart';
import 'package:isati_integration/utils/app_manager.dart';

class AdminMainPage extends StatelessWidget {
final List<Widget> pages = [
  ClipRect(
      child: Navigator(
        key: AppManager.instance.soloWaitingValidationsKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => WaitingSoloValidationsPage()
        ),
      ),
    ),
    ClipRect(
      child: Navigator(
        key: AppManager.instance.adminSoloChallengesKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => AdminSoloChallengesPage()
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
        key: AppManager.instance.adminTeamChallengesKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => AdminTeamChallengesPage()
        ),
      ),
    ),
    ClipRect(
      child: Navigator(
        key: AppManager.instance.adminTeamsKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => AdminTeamsPage()
        ),
      ),
    ),
  ];

  final List<PageItem> pageItems = const [
    PageItem(
      index: 0,
      title: "Les défis solo à valider",
      icon: Icons.pool
    ),
    PageItem(
      index: 1,
      title: "Modifier les défis solo",
      icon: Icons.edit
    ),
    PageItem(
      index: 2,
      title: "Les défis solo d'équipe",
      icon: Icons.pool
    ),
    PageItem(
      index: 3,
      title: "Modifier les défis d'équipe",
      icon: Icons.edit
    ),
    PageItem(
      index: 4,
      title: "Les équipes",
      icon: Icons.people
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