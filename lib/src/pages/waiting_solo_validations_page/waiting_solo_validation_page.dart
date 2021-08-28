import 'package:flutter/material.dart';
import 'package:isati_integration/models/solo_validation.dart';
import 'package:isati_integration/src/pages/waiting_solo_validations_page/widgets/waiting_validation_card.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/solo_challenges_store.dart';
import 'package:isati_integration/src/providers/solo_validation_store.dart';
import 'package:isati_integration/src/providers/solo_validations_store.dart';
import 'package:isati_integration/src/providers/users_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class WaitingSoloValidationsPage extends StatefulWidget {
  @override
  _WaitingSoloValidationsPageState createState() => _WaitingSoloValidationsPageState();
}

class _WaitingSoloValidationsPageState extends State<WaitingSoloValidationsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SoloValidationsStore>(
      builder: (context, soloValidationsStore, child) {
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
                          message: "Impossible de charger les demandes de validations : ${snapshot.error}",
                          
                        );
                      }

                      // We want to display a message if their is no challenges
                      if (soloValidationsStore.validations.isEmpty) {
                        return const IsStatusMessage(
                          type: IsStatusMessageType.info,
                          title: "Pas de de validation",
                          message: "Personne n'a besoin de valider ses défis pour l'instant !"
                                  
                        );
                      }

                      return _buildSoloValidationsList(validations: soloValidationsStore.validations);
                    },
                  ),
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

  Widget _buildSoloValidationsList({required List<SoloValidation> validations}) {
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
                for (final validation in validations)
                  ChangeNotifierProvider(
                    create: (context) => SoloValidationStore(validation),
                    builder: (context, child) => WaitingValidationCard(
                      width: constraints.maxWidth > 640 ? 320 : constraints.maxWidth,
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

    final SoloChallengesStore soloChallengesStore = Provider.of<SoloChallengesStore>(context, listen: false);
    final SoloValidationsStore soloValidationsStore = Provider.of<SoloValidationsStore>(context, listen: false);
    final UsersStore usersStore = Provider.of<UsersStore>(context, listen: false);

    await soloChallengesStore.getChallenges(appUserStore.authenticationHeader, forceRefresh: forceRefresh);
    await soloValidationsStore.getValidations(appUserStore.authenticationHeader, forceRefresh: forceRefresh);
    await usersStore.getUsers(appUserStore.authenticationHeader, forceRefresh: forceRefresh);

    if (forceRefresh) {
      setState(() {});
    }
  }
}