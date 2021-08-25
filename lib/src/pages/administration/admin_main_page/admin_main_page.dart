import 'package:flutter/material.dart';
import 'package:isati_integration/models/page_item.dart';
import 'package:isati_integration/src/pages/administration/admin_teams_page/admin_teams_page.dart';
import 'package:isati_integration/src/pages/main_page/main_page.dart';
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
      title: "Les défis à valider",
      icon: Icons.pool
    ),
    PageItem(
      index: 1,
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