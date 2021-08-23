import 'package:flutter/material.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/src/providers/user_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_icon_button.dart';
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
    return Consumer<UserStore>(
      builder: (context, userStore, child) {
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
                    child: Image.asset("assets/images/logo_white.png", width: 20,)
                  ),
                ),
              ),
              // We only show the rest on minimified
              if (!isMinimified) ...{
                const SizedBox(width: 15,),
                Expanded(
                  child: _buildDescription(context, userStore),
                ),
                // ignore: equal_elements_in_set
                const SizedBox(width: 15,),
                IsIconButton(
                  backgroundColor: Colors.white,
                  iconSize: 24,
                  icon: Icons.logout,
                  onPressed: () => _logout(userStore),
                )
              }
            ],
          ),
        );
      },
    );
  }

  Widget _buildDescription(BuildContext context, UserStore userStore) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(userStore.user!.fullName, style: Theme.of(context).textTheme.headline6),
        const SizedBox(height: 2,),
        Text(UserRoles.detailled[userStore.user!.role] ?? "Inconnue", style: const TextStyle(fontSize: 12, color: Color(0xff8f9bb3)),)
      ],
    );
  }

  Future _logout(UserStore userStore) async {
    await userStore.logout();
  }
}