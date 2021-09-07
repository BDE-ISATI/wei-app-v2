import 'package:flutter/material.dart';
import 'package:isati_integration/src/providers/teams_store.dart';
import 'package:isati_integration/src/providers/user_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_card.dart';
import 'package:isati_integration/src/shared/widgets/general/is_image_widget.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:provider/provider.dart';

class UserRankingCard extends StatelessWidget {
  const UserRankingCard({
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
    return Consumer2<UserStore, TeamsStore>(
      builder: (context, userStore, teamsStore, child) {
        return IsCard(
          width: width,
          borderColor: highlight ? colorPrimary : colorScaffolddWhite,
          borderWidth: 5.0,
          child: Row(
            children: [
              // The user logo
              SizedBox(
                width: 96,
                height: 96,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  child: IsImageWidget(
                    source: userStore.user.profilePicture,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16,),
              // The user infos
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The user name
                    Text(userStore.user.fullName, style: Theme.of(context).textTheme.headline3,),
                    const SizedBox(height: 8,),
                    Text("Score : ${userStore.user.score}", style: Theme.of(context).textTheme.headline5,),
                    const SizedBox(height: 12,),
                    // The captain name
                    Text(
                      userStore.user.team == null ? 
                      "Pas d'équipe" : 
                      "Equipe : ${userStore.user.team!.name}"
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
          )
        );
      }
    );
  }
}