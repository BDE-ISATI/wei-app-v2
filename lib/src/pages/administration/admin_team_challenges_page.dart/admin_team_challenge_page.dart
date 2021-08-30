import 'package:flutter/material.dart';
import 'package:isati_integration/models/is_image.dart';
import 'package:isati_integration/models/team_challenge.dart';
import 'package:isati_integration/src/pages/administration/admin_team_challenges_page.dart/team_challenge_edit_page/team_challenge_edit_page.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/team_challenge_store.dart';
import 'package:isati_integration/src/providers/team_challenges_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/team_challenge_card.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class AdminTeamChallengesPage extends StatefulWidget {
  const AdminTeamChallengesPage({Key? key}) : super(key: key);
  
  @override
  _AdminTeamChallengesPageState createState() => _AdminTeamChallengesPageState();
}

class _AdminTeamChallengesPageState extends State<AdminTeamChallengesPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TeamChallengesStore>(
      builder: (context, teamChallengesStore, child) {
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
                          message: "Impossible de charger les défis : ${snapshot.error}",
                          
                        );
                      }

                      // We want to display a message if their is no challenges
                      if (teamChallengesStore.challengesList.isEmpty) {
                        return const IsStatusMessage(
                          type: IsStatusMessageType.info,
                          title: "Pas de de défis",
                          message: "Vous n'avez créé aucun défis. Commencez en appuyant sur le +"
                                  
                        );
                      }

                      return _buildTeamChallengesList(teamChallenges: teamChallengesStore.challengesList);
                    },
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _onAddTeamChallengePressed(context, teamChallengesStore),
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

  Widget _buildTeamChallengesList({required List<TeamChallenge> teamChallenges}) {
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
                for (final teamChallenge in teamChallenges)
                  ChangeNotifierProvider(
                    create: (context) => TeamChallengeStore(teamChallenge),
                    builder: (context, child) => TeamChallengeCard(
                      width: constraints.maxWidth > 500 ? 320 : constraints.maxWidth,
                      buttonText: "Modifier",
                      onButtonPressed: () => _onUpateTeamChallengePressed(context, Provider.of<TeamChallengeStore>(context, listen: false)),
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
    final AppUserStore appUserStore = Provider.of<AppUserStore>(context, listen: false);
    final TeamChallengesStore teamChallengesStore = Provider.of<TeamChallengesStore>(context, listen: false);

    await teamChallengesStore.getChallenges(appUserStore.authenticationHeader, forceRefresh: forceRefresh);

    if (forceRefresh) {
      setState(() {});
    }
  }

  Future _onUpateTeamChallengePressed(BuildContext context, TeamChallengeStore teamChallengeStore) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: teamChallengeStore,
          builder: (context, child) => TeamChallengeEditPage(),
        ),
      )
    );
  }

  Future _onAddTeamChallengePressed(BuildContext context, TeamChallengesStore teamChallengesStore) async {
    final TeamChallenge? createdTeamChallenge = await Navigator.of(context).push<TeamChallenge?>(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => TeamChallengeStore(
            TeamChallenge(null,
              title: "",
              description: "",
              value: 0,
              shouldCountMembers: false,
              numberOfRepetitions: 0,
              startingDate: DateTime.now(),
              endingDate: DateTime.now().add(const Duration(days: 7)),
              challengeImage: IsImage(""),
            )
          ),
          builder: (context, child) => TeamChallengeEditPage(),
        ),
      )
    );

    if (createdTeamChallenge != null) {
      teamChallengesStore.addChallenge(createdTeamChallenge);
    }
  }
}