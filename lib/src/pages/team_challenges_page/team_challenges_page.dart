import 'package:flutter/material.dart';
import 'package:isati_integration/models/team_challenge.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/src/pages/team_challenges_page/team_challenge_details_page/team_challenge_details_page.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/team_challenge_store.dart';
import 'package:isati_integration/src/providers/team_challenges_store.dart';
import 'package:isati_integration/src/providers/team_validations_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/team_challenge_card.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class TeamChallengesPage extends StatelessWidget {
  const TeamChallengesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer3<TeamChallengesStore, TeamValidationsStore, AppUserStore>(
      builder: (context, teamChallengesStore, teamValidationsStore, appUserStore, child) {
        return Scaffold(
          body: Padding(
            padding: ScreenUtils.instance.defaultPadding,
            child: FutureBuilder<void>(
              future: _loadData(
                teamChallengesStore, 
                teamValidationsStore, 
                appUserStore,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return IsStatusMessage(
                      title: "Erreur de chargement",
                      message: "Impossible de charger les défis d'équipe : ${snapshot.error}",
                    );
                  }

                  final List<TeamChallenge> teamChallenges = teamChallengesStore.challengesList;

                  // We want to display a message if their is no challenges
                  if (teamChallenges.isEmpty) {
                    return const IsStatusMessage(
                      type: IsStatusMessageType.info,
                      title: "Pas de défis",
                      message: "Aucun défis n'est disponible pour l'instant. "
                               "N'hésite pas à revenir demain à partir de 8h "
                               "pour vérifier qu'il n'y en a pas de nouveaux.",
                    );
                  }

                  return _buildChallengesList(challenges: teamChallenges);
                }

                return const Center(child: CircularProgressIndicator(),);
              },
            ),
          )
        );
      }
    );
  }

  Widget _buildChallengesList({required List<TeamChallenge> challenges}) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              for (final challenge in challenges)
                ChangeNotifierProvider(
                  create: (context) => TeamChallengeStore(challenge),
                  builder: (context, child) => TeamChallengeCard(
                    width: constraints.maxWidth > 500 ? 250 : constraints.maxWidth,
                    showOverlay: true,
                    buttonText: "Détails",
                    onButtonPressed: () => _onChallengeDetailsPressed(context, Provider.of<TeamChallengeStore>(context, listen: false))
                  ),
                )
            ],
          );
        },
      ),
    );
  }

  Future _loadData(TeamChallengesStore teamChallengesStore, TeamValidationsStore teamValidationsStore, AppUserStore appUserStore) async {
    await teamChallengesStore.getChallenges(appUserStore.authenticationHeader);
    await teamValidationsStore.getValidations(appUserStore.authenticationHeader);

    if (appUserStore.user!.role != UserRoles.admin) {
      teamValidationsStore.updateChallenges(teamChallengesStore);
    }
  }

  Future _onChallengeDetailsPressed(BuildContext context, TeamChallengeStore teamChallengeStore) async {
    final bool isValidated = await Navigator.of(context).push<bool?>(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: teamChallengeStore,
          child: const TeamChallengeDetailsPage(),
        )
      )
    ) ?? false;

    final appUserStore = Provider.of<AppUserStore>(context, listen: false);

    if (isValidated && appUserStore.user!.role != UserRoles.admin) {
      teamChallengeStore.numberOfRepetitions--;
    }
  }
}