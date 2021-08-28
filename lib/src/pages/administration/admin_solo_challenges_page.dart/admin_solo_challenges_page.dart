import 'package:flutter/material.dart';
import 'package:isati_integration/models/is_image.dart';
import 'package:isati_integration/models/solo_challenge.dart';
import 'package:isati_integration/src/pages/administration/admin_solo_challenges_page.dart/solo_challenge_edit_page/solo_challenge_edit_page.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/solo_challenge_store.dart';
import 'package:isati_integration/src/providers/solo_challenges_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/solo_challenge_card.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class AdminSoloChallengesPage extends StatefulWidget {
  @override
  _AdminSoloChallengesPageState createState() => _AdminSoloChallengesPageState();
}

class _AdminSoloChallengesPageState extends State<AdminSoloChallengesPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SoloChallengesStore>(
      builder: (context, soloChallengesStore, child) {
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
                      if (soloChallengesStore.challengesList.isEmpty) {
                        return const IsStatusMessage(
                          type: IsStatusMessageType.info,
                          title: "Pas de de défis",
                          message: "Vous n'avez créé aucun défis. Commencez en appuyant sur le +"
                                  
                        );
                      }

                      return _buildSoloChallengesList(soloChallenges: soloChallengesStore.challengesList);
                    },
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _onAddSoloChallengePressed(context, soloChallengesStore),
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

  Widget _buildSoloChallengesList({required List<SoloChallenge> soloChallenges}) {
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
                for (final soloChallenge in soloChallenges)
                  ChangeNotifierProvider(
                    create: (context) => SoloChallengeStore(soloChallenge),
                    builder: (context, child) => SoloChallengeCard(
                      width: constraints.maxWidth > 500 ? 320 : constraints.maxWidth,
                      buttonText: "Modifier",
                      onButtonPressed: () => _onUpateSoloChallengePressed(context, Provider.of<SoloChallengeStore>(context, listen: false)),
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
    final SoloChallengesStore soloChallengesStore = Provider.of(context, listen: false);

    await soloChallengesStore.getChallenges(appUserStore.authenticationHeader, forceRefresh: forceRefresh);

    if (forceRefresh) {
      setState(() {});
    }
  }

  Future _onUpateSoloChallengePressed(BuildContext context, SoloChallengeStore soloChallengeStore) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: soloChallengeStore,
          builder: (context, child) => SoloChallengeEditPage(),
        ),
      )
    );
  }

  Future _onAddSoloChallengePressed(BuildContext context, SoloChallengesStore soloChallengesStore) async {
    final SoloChallenge? createdSoloChallenge = await Navigator.of(context).push<SoloChallenge?>(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => SoloChallengeStore(
            SoloChallenge(null,
              title: "",
              description: "",
              value: 0,
              numberOfRepetitions: 0,
              startingDate: DateTime.now(),
              endingDate: DateTime.now().add(const Duration(days: 7)),
              challengeImage: IsImage("")
            )
          ),
          builder: (context, child) => SoloChallengeEditPage(),
        ),
      )
    );

    if (createdSoloChallenge != null) {
      soloChallengesStore.addChallenge(createdSoloChallenge);
    }
  }
}