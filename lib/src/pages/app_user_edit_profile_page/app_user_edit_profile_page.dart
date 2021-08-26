import 'package:flutter/material.dart';
import 'package:isati_integration/src/pages/user_edit_profile_page.dart/user_edit_profile_page.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/teams_store.dart';
import 'package:isati_integration/src/providers/user_store.dart';
import 'package:provider/provider.dart';

class AppUserEditProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AppUserStore, TeamsStore>(
      builder: (context, appUserStore, teamsStore, child) {
        return FutureBuilder(
          future: teamsStore.getTeams(appUserStore.authenticationHeader),
          builder: (context, snapshot) {
            return ChangeNotifierProvider(
              create: (context) => UserStore(appUserStore.user!),
              builder: (context, child) {
                return const UserEditProfilePage(shouldPopOnSave: false,);
              },
            );
          }
        );
      },
    );
  }
}