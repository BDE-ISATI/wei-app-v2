import 'package:flutter/material.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/src/pages/waiting_solo_validations_page/waiting_solo_validation_proofs_page/waiting_solo_validation_proofs_page.dart';
import 'package:isati_integration/src/providers/solo_challenges_store.dart';
import 'package:isati_integration/src/providers/solo_validation_store.dart';
import 'package:isati_integration/src/providers/solo_validations_store.dart';
import 'package:isati_integration/src/providers/users_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_card.dart';
import 'package:isati_integration/src/shared/widgets/general/is_image_widget.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:provider/provider.dart';

class WaitingValidationCard extends StatelessWidget {
  const WaitingValidationCard({
    Key? key, 
    this.width,
  }) : super(key: key);

  final double? width;
  
  @override
  Widget build(BuildContext context) {
    return Consumer3<SoloValidationStore, UsersStore, SoloChallengesStore>(
      builder: (context, soloValidationStore, usersStore, soloChallengesStore, child) {
        final User user = usersStore.users[soloValidationStore.validation.userId]!;

        return IsCard(
          width: width,
          child: Row(
            children: [
              // The team logo
              SizedBox(
                width: 96,
                height: 96,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  child: Container(
                    color: colorPrimary,
                    child: IsImageWidget(
                      source: user.profilePicture, 
                      defaultPadding: const EdgeInsets.all(16.0),
                      fit: BoxFit.cover,
                      width: 64
                    )
                  ),
                ),
              ),
              const SizedBox(width: 8,),
              // The team infos
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The user name
                    Text(user.fullName, style: Theme.of(context).textTheme.headline3,),
                    const SizedBox(height: 8,),
                    Text(user.team!.name),
                    const SizedBox(height: 8,),
                    Text(
                      soloChallengesStore.challenges[soloValidationStore.validation.challengeId]!.title,
                      style: Theme.of(context).textTheme.headline4,  
                    ),
                    const SizedBox(height: 8,),
                    // The details button
                    const SizedBox(height: 20,),
                    IsButton(
                      text: "Voir les preuves",
                      onPressed: () => _onViewProofClicked(context, soloValidationStore),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }

  Future _onViewProofClicked(BuildContext context, SoloValidationStore soloValidationStore) async {
    final bool shouldRemove = await Navigator.of(context).push<bool?>(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: soloValidationStore,
          builder: (context, child) => WaitingSoloValidationProofsPage(),
        )
      )
    ) ?? false;

    if (shouldRemove) {
      Provider.of<SoloValidationsStore>(context, listen: false).removeValidation(soloValidationStore.validation);
    }
  }
}