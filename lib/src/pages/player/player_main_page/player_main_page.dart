import 'package:flutter/material.dart';
import 'package:isati_integration/models/page_item.dart';
import 'package:isati_integration/src/pages/app_user_edit_profile_page/app_user_edit_profile_page.dart';
import 'package:isati_integration/src/pages/main_page/main_page.dart';
import 'package:isati_integration/src/pages/player/player_dashboard_page/player_dashboard_page.dart';
import 'package:isati_integration/src/pages/player/solo_challenges_page/solo_challenges_page.dart';
import 'package:isati_integration/src/pages/team_challenges_page/team_challenges_page.dart';
import 'package:isati_integration/src/pages/teams_rank_page/teams_ranking_page.dart';
import 'package:isati_integration/src/pages/users_ranking_page/users_ranking_page.dart';
import 'package:isati_integration/utils/app_manager.dart';

class PlayerMainPage extends StatelessWidget {
  final List<Widget> pages = [
    const PlayerDashboardPage(),
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
    const UsersRankingPage(),
    const TeamsRankingPage(),
    ClipRect(
      child: Navigator(
        key: AppManager.instance.profileKey,
        onGenerateRoute: (route) => MaterialPageRoute<dynamic>(
          settings: route,
          builder: (context) => const AppUserEditProfilePage()
        ),
      ),
    ),
  ];

  final List<PageItem> pageItems = const [
    PageItem(
      index: 0,
      title: "Tableau de bord",
      icon: Icons.home
    ),
    PageItem(
      index: 1,
      title: "Défis solo",
      icon: Icons.pool
    ),
    PageItem(
      index: 2,
      title: "Défis d'équipe",
      icon: Icons.people
    ),
    PageItem(
      index: 3,
      title: "Classement des joueurs",
      icon: Icons.emoji_events
    ),
    PageItem(
      index: 4,
      title: "Classement des équipes",
      icon: Icons.emoji_events
    ),
    PageItem(
      index: 5,
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