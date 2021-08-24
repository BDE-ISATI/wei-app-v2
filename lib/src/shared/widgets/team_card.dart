import 'package:flutter/material.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/src/providers/team_store.dart';
import 'package:isati_integration/src/providers/users_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_card.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:provider/provider.dart';

class TeamCard extends StatelessWidget {
  const TeamCard({
    Key? key, 
    this.width,
    this.buttonText,
    this.onButtonPressed,
  }) : super(key: key);

  final double? width;
  
  final String? buttonText;
  final Function()? onButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Consumer2<TeamStore, UsersStore>(
      builder: (context, teamStore, usersStore, child) {
        final User? captain = usersStore.users[teamStore.captainId];

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
                    color: teamStore.teamColor.toColor(),
                    child: Image.asset("assets/images/logo_white.png", width: 64),
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
                    // The team name
                    Text(teamStore.name, style: Theme.of(context).textTheme.headline3,),
                    const SizedBox(height: 8,),
                    // The captain name
                    Text(
                     captain == null ? 
                      "Pas de capitaine" : 
                      captain.fullName
                    ),
                    const SizedBox(height: 20,),
                    if (buttonText != null)
                      IsButton(
                        text: buttonText!,
                        onPressed: onButtonPressed,
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
}