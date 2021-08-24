import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isati_integration/src/providers/solo_challenge_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_card.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:provider/provider.dart';

class SoloChallengeCard extends StatelessWidget {
  const SoloChallengeCard({
    Key? key, 
    this.width,
    this.isCompletedByUser = false,
  }) : super(key: key);

  final double? width;
  final bool isCompletedByUser;

  @override
  Widget build(BuildContext context) {
    return Consumer<SoloChallengeStore>(
      builder: (context, soloChallengeStore, child) {
        final String challengeTitle = soloChallengeStore.challenge.title;
        final String challengeDescription = soloChallengeStore.challenge.description;

        return IsCard(
          padding: EdgeInsets.zero,
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // The challenge picture
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Image.asset("assets/images/background.jpg", height: 180, fit: BoxFit.cover,),
              ),
              // Container(
              //   color: colorPrimary,
              //   height: 12,
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The challenge title
                    Text(challengeTitle, style: Theme.of(context).textTheme.headline2,),
                    const SizedBox(height: 8,),
                    // The challenge description
                    Text("${challengeDescription.substring(0, min(challengeDescription.length, 100))}..."),
                    const SizedBox(height: 8,),
                    IsButton(
                      text: "Détails",
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}