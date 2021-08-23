import 'package:flutter/material.dart';
import 'package:isati_integration/models/page_item.dart';
import 'package:isati_integration/src/pages/main_page/main_page.dart';
import 'package:isati_integration/src/pages/player/solo_challenges_page/solo_challenges_page.dart';
import 'package:isati_integration/src/pages/player/team_challenges_page/team_challenges_page.dart';

class PlayerMainPage extends StatelessWidget {
  final List<Widget> pages = const [
    SoloChallengesPage(),
    TeamChallengesPage(),
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