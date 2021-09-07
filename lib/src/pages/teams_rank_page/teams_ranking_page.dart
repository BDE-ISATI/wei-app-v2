
import 'package:flutter/material.dart';
import 'package:isati_integration/models/team.dart';
import 'package:isati_integration/src/pages/teams_rank_page/widgets/team_ranking_card.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/team_store.dart';
import 'package:isati_integration/src/providers/teams_ranking_store.dart';
import 'package:isati_integration/src/providers/users_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class TeamsRankingPage extends StatefulWidget {
  const TeamsRankingPage({Key? key}) : super(key: key);

  @override
  _TeamsRankingPageState createState() => _TeamsRankingPageState();
}

class _TeamsRankingPageState extends State<TeamsRankingPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeamsRankingStore>(
      builder: (context, teamsRankingStore, child) {
        return Scaffold(
          body: Padding(
            padding: ScreenUtils.instance.defaultPadding,
            child: FutureBuilder<void>(
              future: _loadData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return IsStatusMessage(
                      title: "Erreur de chargement",
                      message: "Impossible de charger les équipe : ${snapshot.error}",
                      
                    );
                  }

                  final List<Team> teams = teamsRankingStore.teamsList;

                  // We want to display a message if their is no challenges
                  if (teams.isEmpty) {
                    return const IsStatusMessage(
                      type: IsStatusMessageType.info,
                      title: "Tout est caché !",
                      message: "Le classement a été caché aux yeux de tous... Dernier ? "
                               "Premier ? Personne ne le sais alors force à toi pour être "
                               "en haut de la liste quand elle réaparaîtera !" 
                    );
                  }

                  return _buildTeamsList(teams: teams);
                }

                return const Center(child: CircularProgressIndicator(),);
              },
            ),
          )
        );
      }
    );
  }

  Widget _buildTeamsList({required List<Team> teams}) {
    return Consumer<AppUserStore>(
      builder: (context, appUserStore, child) {
        return RefreshIndicator(
          onRefresh: () => _loadData(forceRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < teams.length; ++i) ...{
                  ChangeNotifierProvider(
                    create: (context) => TeamStore(teams[i]),
                    builder: (context, child) => TeamRankingCard(
                      rank: i + 1,
                      highlight: appUserStore.user!.team?.id == teams[i].id,
                    ),
                  ),
                  const SizedBox(height: 16,),
                }
              ],
            ),
          ),
        );
      }
    );
  }

  Future _loadData({bool forceRefresh = false}) async {
    final AppUserStore appUserStore = Provider.of<AppUserStore>(context, listen: false);

    final UsersStore usersStore = Provider.of<UsersStore>(context, listen: false);
    final TeamsRankingStore teamsRankingStore = Provider.of<TeamsRankingStore>(context, listen: false);

    await usersStore.getUsers(appUserStore.authenticationHeader, forceRefresh: forceRefresh);
    await teamsRankingStore.getTeams(appUserStore.authenticationHeader, forceRefresh: forceRefresh);

    if (forceRefresh) {
      setState(() {});
    }
  }
}