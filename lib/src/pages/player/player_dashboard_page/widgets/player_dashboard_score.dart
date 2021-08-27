import 'package:flutter/material.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_card.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:provider/provider.dart';

class PlayerDashboardScore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppUserStore>(
      builder: (context, appUserStore, child) {
        return IsCard(
          child: Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _buildScore(
                  text: "Votre score",
                  score: appUserStore.user!.score,
                  color: const Color(0xfff70c35)
                ),
              _buildScore(
                text: "Score de l'équipe",
                score: appUserStore.user!.team!.score,
                color: colorPrimary,
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildScore({required String text, required int score, required Color color}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 128,
          width: 128,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(
                "assets/images/logo.png",
              ), 
              colorFilter: ColorFilter.mode(Color(0xffdfdfdf), BlendMode.srcATop)
            ),
            borderRadius: BorderRadius.circular(64.0),
            border: Border.all(
              color: color,
              width: 12
            )
          ),
          child: Center(
            child: Text(
              score.toString(), 
              style: TextStyle(
                color: color,
                fontSize: 48,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        const SizedBox(height: 8,),
        Text(text, style: TextStyle(color: color),)
      ],
    );
  }
}