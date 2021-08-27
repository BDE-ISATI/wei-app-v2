import 'package:flutter/material.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_card.dart';
import 'package:isati_integration/src/shared/widgets/general/is_image_widget.dart';
import 'package:provider/provider.dart';

class PlayerWelcomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppUserStore>(
      builder: (context, appUserStore, child) {
        return IsCard(
          child: Row(
            children: [
              SizedBox(
                height: 112,
                width: 112,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(56),
                  child: IsImageWidget(
                    source: appUserStore.user!.profilePicture,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Bonjour ${appUserStore.user!.firstName}", style: Theme.of(context).textTheme.headline1,),
                    const SizedBox(height: 8.0,),
                    Text("Votre équipe : ${appUserStore.user!.team!.name}"),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );  
  }
}