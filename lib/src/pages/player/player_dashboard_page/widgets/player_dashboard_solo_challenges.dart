import 'package:flutter/material.dart';
import 'package:isati_integration/models/solo_validation.dart';
import 'package:isati_integration/src/providers/solo_challenge_store.dart';
import 'package:isati_integration/src/providers/solo_challenges_store.dart';
import 'package:isati_integration/src/providers/solo_validations_store.dart';
import 'package:isati_integration/src/shared/widgets/solo_challenge_card.dart';
import 'package:provider/provider.dart';

class PlayerDashboardSoloChallenges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<SoloValidationsStore, SoloChallengesStore>(
      builder: (context, validationsStore, challengesStore, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Les défis réalisés", style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: 20,),
            Flexible(child: _buildChallengesList(validationsStore, challengesStore))
          ],
        );
      }
    );
  }

  Widget _buildChallengesList(SoloValidationsStore validationsStore, SoloChallengesStore challengesStore) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            for (final validation in validationsStore.validations)
              if (validation.status == SoloValidationStatus.validated)
                ChangeNotifierProvider(
                  create: (context) => SoloChallengeStore(challengesStore.challenges[validation.challengeId]!),
                  builder: (context, child) => SoloChallengeCard(
                    width: constraints.maxWidth > 500 ? 250 : constraints.maxWidth,
                  ),
                )
          ],
        );
      },
    );
  }
}