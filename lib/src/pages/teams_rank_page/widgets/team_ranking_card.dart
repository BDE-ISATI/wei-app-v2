import 'package:flutter/material.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/src/providers/team_store.dart';
import 'package:isati_integration/src/providers/users_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_card.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:provider/provider.dart';

class TeamRankingCard extends StatelessWidget {
  const TeamRankingCard({
    Key? key, 
    this.width,
    required this.rank,
    this.highlight = false,
  }) : super(key: key);

  final double? width;
  final int rank;

  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Consumer2<TeamStore, UsersStore>(
      builder: (context, teamStore, usersStore, child) {
        final User? captain = usersStore.users[teamStore.captainId];

        return IsCard(
          width: width,
          borderColor: highlight ? colorPrimary : colorScaffolddWhite,
          borderWidth: 5.0,
          child: Row(
            children: [
              // The team logo
              SizedBox(
                width: 96,
                height: 96,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  child: Container(
                    color: teamStore.teamColor.toColor(),
                    child: Image.asset("assets/images/logo_white.png", width: 64),
                  ),
                ),
              ),
              const SizedBox(width: 16,),
              // The team infos
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The team name
                    Text(teamStore.name, style: Theme.of(context).textTheme.headline3,),
                    const SizedBox(height: 8,),
                    Text("Score : ${teamStore.score}", style: Theme.of(context).textTheme.headline5,),
                    const SizedBox(height: 12,),
                    // The captain name
                    Text(
                     captain == null ? 
                      "Pas de capitaine" : 
                      "Capitaine : ${captain.fullName}"
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
              const SizedBox(width: 16,),
              SizedBox(
                width: 96,
                height: 96,
                child: Text("#$rank", style: Theme.of(context).textTheme.headline1,),
              ),
            ],
          ),
        );
      }
    );
  }
}