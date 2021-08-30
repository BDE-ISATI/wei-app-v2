import 'package:flutter/material.dart';
import 'package:isati_integration/models/team.dart';
import 'package:isati_integration/src/pages/administration/admin_teams_page/team_edit_page/team_edit_page.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/team_store.dart';
import 'package:isati_integration/src/providers/teams_store.dart';
import 'package:isati_integration/src/providers/users_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/team_card.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class AdminTeamsPage extends StatefulWidget {
  const AdminTeamsPage({Key? key}) : super(key: key);
  
  @override
  _AdminTeamsPageState createState() => _AdminTeamsPageState();
}

class _AdminTeamsPageState extends State<AdminTeamsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeamsStore>(
      builder: (context, teamsStore, child) {
        return FutureBuilder<void>(
          future: _loadAppData(),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.done) {
              return Scaffold(
                body: Padding(
                  padding: ScreenUtils.instance.defaultPadding,
                  child: Builder(
                    builder: (context) {
                      if (snapshot.hasError) {
                        return IsStatusMessage(
                          title: "Erreur de chargement",
                          message: "Impossible de charger les équipes : ${snapshot.error}",
                          
                        );
                      }

                      // We want to display a message if their is no challenges
                      if (teamsStore.teamsList.isEmpty) {
                        return const IsStatusMessage(
                          type: IsStatusMessageType.info,
                          title: "Pas de d'équipe",
                          message: "Vous n'avez créé aucune équipe. Commencez en appuyant sur le +"
                                  
                        );
                      }

                      return _buildTeamsList(teams: teamsStore.teamsList);
                    },
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _onAddTeamPressed(context, teamsStore),
                  child: const Icon(Icons.add),
                ),
              );
            }

            return const Scaffold(
              body: Center(child: CircularProgressIndicator(),),
            );
          }
        );
      }
    );
  }

  Widget _buildTeamsList({required List<Team> teams}) {
    return RefreshIndicator(
      onRefresh: () => _loadAppData(forceRefresh: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                for (final team in teams)
                  ChangeNotifierProvider(
                    create: (context) => TeamStore(team),
                    builder: (context, child) => TeamCard(
                      width: constraints.maxWidth > 500 ? 320 : constraints.maxWidth,
                      buttonText: "Modifier",
                      onButtonPressed: () => _onUpateTeamPressed(context, Provider.of<TeamStore>(context, listen: false)),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  Future _loadAppData({bool forceRefresh = false}) async {
    final UsersStore usersStore = Provider.of<UsersStore>(context, listen: false);
    final TeamsStore teamsStore = Provider.of<TeamsStore>(context, listen: false);

    final AppUserStore appUserStore = Provider.of<AppUserStore>(context, listen: false);

    await usersStore.getUsers(appUserStore.authenticationHeader, forceRefresh: forceRefresh);
    await teamsStore.getTeams(appUserStore.authenticationHeader, forceRefresh: forceRefresh);

    if (forceRefresh) {
      setState(() {});
    }
  }

  Future _onUpateTeamPressed(BuildContext context, TeamStore teamStore) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: teamStore,
          builder: (context, child) => TeamEditPage(),
        ),
      )
    );
  }

  Future _onAddTeamPressed(BuildContext context, TeamsStore teamsStore) async {
    final Team? createdTeam = await Navigator.of(context).push<Team?>(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => TeamStore(Team(null, name: "", teamColor: "")),
          builder: (context, child) => TeamEditPage(),
        ),
      )
    );

    if (createdTeam != null) {
      teamsStore.addTeam(createdTeam);
    }
  }
}