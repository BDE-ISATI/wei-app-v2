import 'package:flutter/material.dart';
import 'package:isati_integration/models/page_item.dart';
import 'package:isati_integration/src/pages/administration/admin_forms_page/admin_forms_page.dart';
import 'package:isati_integration/src/pages/administration/admin_solo_challenges_page.dart/admin_solo_challenges_page.dart';
import 'package:isati_integration/src/pages/administration/admin_team_challenges_page.dart/admin_team_challenge_page.dart';
import 'package:isati_integration/src/pages/administration/admin_teams_page/admin_teams_page.dart';
import 'package:isati_integration/src/pages/administration/admin_users_page/admin_users_page.dart';
import 'package:isati_integration/src/pages/main_page/main_page.dart';
import 'package:isati_integration/src/pages/team_challenges_page/team_challenges_page.dart';
import 'package:isati_integration/src/pages/teams_rank_page/teams_ranking_page.dart';
import 'package:isati_integration/src/pages/users_ranking_page/users_ranking_page.dart';
import 'package:isati_integration/src/pages/waiting_solo_validations_page/waiting_solo_validation_page.dart';
import 'package:isati_integration/utils/app_manager.dart';

class AdminMainPage extends StatelessWidget {
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
        key: AppManager.instance.adminSoloChallengesKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => const AdminSoloChallengesPage()
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
          builder: (context) => const AdminTeamChallengesPage()
        ),
      ),
    ),
    const UsersRankingPage(),
    const TeamsRankingPage(),
    ClipRect(
      child: Navigator(
        key: AppManager.instance.adminTeamsKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => const AdminTeamsPage()
        ),
      ),
    ),
    ClipRect(
      child: Navigator(
        key: AppManager.instance.adminUsersKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => const AdminUsersPage()
        ),
      ),
    ),
    ClipRect(
      child: Navigator(
        key: AppManager.instance.adminFormsKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => const AdminFormsPage()
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
      title: "Les défis d'équipe",
      icon: Icons.people
    ),
    PageItem(
      index: 3,
      title: "Modifier les défis d'équipe",
      icon: Icons.edit
    ),
    PageItem(
      index: 4,
      title: "Classement des joueurs",
      icon: Icons.emoji_events
    ),
    PageItem(
      index: 5,
      title: "Classement des équipes",
      icon: Icons.emoji_events
    ),
    PageItem(
      index: 6,
      title: "Les équipes",
      icon: Icons.people
    ),
    PageItem(
      index: 7,
      title: "Les utilisateurs",
      icon: Icons.account_circle
    ),
    PageItem(
      index: 8,
      title: "Les questionnaires",
      icon: Icons.question_answer
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