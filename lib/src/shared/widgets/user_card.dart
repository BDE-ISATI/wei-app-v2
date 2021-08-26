import 'package:flutter/material.dart';
import 'package:isati_integration/src/providers/user_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_card.dart';
import 'package:isati_integration/src/shared/widgets/general/is_image_widget.dart';
import 'package:provider/provider.dart';

class UserCard extends StatelessWidget {
  const UserCard({
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
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
        return IsCard(
          width: width,
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
                    defaultPadding: const EdgeInsets.all(12),
                    fit: BoxFit.cover,
                    width: 64,
                  ), 
                ),
              ),
              const SizedBox(width: 8,),
              // The user infos
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // The user name
                    Text(userStore.user.fullName, style: Theme.of(context).textTheme.headline3,),
                    const SizedBox(height: 8,),
                    // The captain name
                    Text(
                     userStore.user.team == null ? 
                      "Pas d'équipe" : 
                      "Equipe ${userStore.user.team!.name}"
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