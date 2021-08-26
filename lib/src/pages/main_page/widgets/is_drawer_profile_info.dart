import 'package:flutter/material.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_icon_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_image_widget.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:provider/provider.dart';

class IsDrawerProfileInfo extends StatelessWidget {
  const IsDrawerProfileInfo({
    Key? key,
    this.isMinimified = false
  }) : super(key: key);
  
  final bool isMinimified;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppUserStore>(
      builder: (context, appUserStore, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor
              )
            )
          ),
          child: Row(
            children: [
              // The profile picture
              SizedBox(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    color: colorPrimary,
                    child: IsImageWidget(
                      source: appUserStore.user!.profilePicture,
                      defaultPadding: const EdgeInsets.all(4.0),
                      fit: BoxFit.cover,
                      width: 20,
                    )
                  ),
                ),
              ),
              // We only show the rest on minimified
              if (!isMinimified) ...{
                const SizedBox(width: 15,),
                Expanded(
                  child: _buildDescription(context, appUserStore),
                ),
                // ignore: equal_elements_in_set
                const SizedBox(width: 15,),
                IsIconButton(
                  backgroundColor: Colors.white,
                  iconSize: 24,
                  icon: Icons.logout,
                  onPressed: () => _logout(appUserStore),
                )
              }
            ],
          ),
        );
      },
    );
  }

  Widget _buildDescription(BuildContext context, AppUserStore appUserStore) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(appUserStore.user!.fullName, style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 2,),
        if (appUserStore.user!.role == UserRoles.player) 
          Text(appUserStore.user!.team!.name, style: const TextStyle(fontSize: 12, color: Color(0xff8f9bb3)),)
        else
          Text(UserRoles.detailled[appUserStore.user!.role] ?? "Inconnue", style: const TextStyle(fontSize: 12, color: Color(0xff8f9bb3)),)
      ],
    );
  }

  Future _logout(AppUserStore appUserStore) async {
    await appUserStore.logout();
  }
}