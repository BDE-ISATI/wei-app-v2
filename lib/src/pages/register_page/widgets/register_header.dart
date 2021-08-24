import 'package:flutter/material.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/src/pages/login_page/login_page.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:provider/provider.dart';

class RegisterHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.celebration, size: 96,),
        const SizedBox(width: 8,),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Questionnaire d'inscription", style: Theme.of(context).textTheme.headline2),
              IsButton(text: "Déjà inscrit ?", onPressed: () => _onLoginClicked(context)),
            ],
          ),
        ),
      ],
    );
  }

  Future _onLoginClicked(BuildContext context) async {
    final loggedUser = await Navigator.of(context).push<User?>(
      MaterialPageRoute(builder: (context) => LoginPage())
    );

    if (loggedUser != null) {
      Provider.of<AppUserStore>(context, listen: false).loginUser(loggedUser);
    }
  }
}