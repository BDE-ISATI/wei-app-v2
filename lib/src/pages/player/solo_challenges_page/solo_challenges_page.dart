import 'package:flutter/material.dart';
import 'package:isati_integration/models/solo_challenge.dart';
import 'package:isati_integration/src/pages/player/solo_challenges_page/solo_challenge_details_page/solo_challenge_details_page.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/solo_challenge_store.dart';
import 'package:isati_integration/src/providers/solo_challenges_store.dart';
import 'package:isati_integration/src/providers/solo_validations_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/solo_challenge_card.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class SoloChallengesPage extends StatefulWidget {
  const SoloChallengesPage({Key? key}) : super(key: key);

  @override
  _SoloChallengesPageState createState() => _SoloChallengesPageState();
}

class _SoloChallengesPageState extends State<SoloChallengesPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SoloChallengesStore>(
      builder: (context, soloChallengesStore, child) {
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
                      message: "Impossible de charger les défis solo : ${snapshot.error}",
                      
                    );
                  }

                  final List<SoloChallenge> soloChallenges = soloChallengesStore.challengesList;

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
    return RefreshIndicator(
      onRefresh: () => _loadData(forceRefresh: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
                      showOverlay: true,
                      buttonText: "Détails",
                      onButtonPressed: () => _onChallengeDetailsPressed(context, Provider.of<SoloChallengeStore>(context, listen: false))
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  Future _loadData({bool forceRefresh = false}) async {
    final AppUserStore appUserStore = Provider.of<AppUserStore>(context, listen: false);

    final SoloChallengesStore soloChallengesStore = Provider.of<SoloChallengesStore>(context, listen: false);
    final SoloValidationsStore soloValidationsStore = Provider.of<SoloValidationsStore>(context, listen: false);

    await soloChallengesStore.getChallenges(appUserStore.authenticationHeader, forceRefresh: forceRefresh);
    await soloValidationsStore.getValidations(appUserStore.authenticationHeader, forceRefresh: forceRefresh);

    soloValidationsStore.updateChallenges(soloChallengesStore);

    if (forceRefresh) {
      setState(() {});
    }
  }

  Future _onChallengeDetailsPressed(BuildContext context, SoloChallengeStore soloChallengeStore) async {
     await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: soloChallengeStore,
          child: const SoloChallengeDetailsPage(),
        )
      )
    );
  }
}