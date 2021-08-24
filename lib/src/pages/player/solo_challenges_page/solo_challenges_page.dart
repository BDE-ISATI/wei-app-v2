import 'package:flutter/material.dart';
import 'package:isati_integration/models/solo_challenge.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/solo_challenge_store.dart';
import 'package:isati_integration/src/providers/solo_challenges_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/solo_challenge_card.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class SoloChallengesPage extends StatelessWidget {
  const SoloChallengesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<SoloChallengesStore, AppUserStore>(
      builder: (context, soloChallengesStore, appUserStore, child) {
        return Scaffold(
          body: Padding(
            padding: ScreenUtils.instance.defaultPadding,
            child: FutureBuilder(
              future: soloChallengesStore.getChallenges(appUserStore.authenticationHeader),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return IsStatusMessage(
                      title: "Erreur de chargement",
                      message: "Impossible de charger les défis solo : ${snapshot.error}",
                      
                    );
                  }

                  final List<SoloChallenge> soloChallenges = snapshot.data as List<SoloChallenge>;

                  // We want to display a message if their is no challenges
                  if (soloChallenges.isEmpty) {
                    return const IsStatusMessage(
                      type: IsStatusMessageType.info,
                      title: "Pas de défis",
                      message: "Aucun défis n'est disponible pour l'instant. "
                               "N'hésite pas à revenir demain à partir de 8h "
                               "pour vérifier qu'il n'y en a pas de nouveaux.",
                    );
                  }

                  return _buildChallengesList(challenges: soloChallenges);
                }

                return const Center(child: CircularProgressIndicator(),);
              },
            ),
          )
        );
      }
    );
  }

  Widget _buildChallengesList({required List<SoloChallenge> challenges}) {
    return SingleChildScrollView(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              for (final challenge in challenges)
                ChangeNotifierProvider(
                  create: (context) => SoloChallengeStore(challenge),
                  builder: (context, child) => SoloChallengeCard(
                    width: constraints.maxWidth > 500 ? 250 : constraints.maxWidth,
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}