import 'package:flutter/material.dart';
import 'package:isati_integration/src/pages/register_page/widgets/register_header.dart';
import 'package:isati_integration/utils/screen_utils.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= ScreenUtils.instance.breakpointPC) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildMainColumn(context)),
                Expanded(child: Image.asset("assets/images/background.jpg", fit: BoxFit.cover,)),
              ],
            );
          }

          return _buildMainColumn(context);
        }
      ),
    );
  }

  Widget _buildMainColumn(BuildContext context) {
    return Padding(
      padding: ScreenUtils.instance.defaultPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header part
          Text("Bienvenue à votre mois d'intégration !", style: Theme.of(context).textTheme.headline1),
          const SizedBox(height: 20,),
          RegisterHeader(),
          const SizedBox(height: 20,),
          // The form part
          const Text(
            "Voici un petit questionnaire qui te permettra "
            "de t'inscrire et qui nous permettra de te choisir "
            "une equipe. Répons avec honnêteté." 
          ),
          const SizedBox(height: 10),
          const Text(
            "NB : Pas de soucis à te faire, 'application est très "
            "bien faite, tes données sont sécurisé et seul ton BDE "
            "préféré pourra y avoir accès",
            style: TextStyle(fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }
}