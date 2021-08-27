import 'package:flutter/material.dart';
import 'package:isati_integration/src/pages/player/player_dashboard_page/widgets/player_dashboard_score.dart';
import 'package:isati_integration/src/pages/player/player_dashboard_page/widgets/player_dashboard_solo_challenges.dart';
import 'package:isati_integration/src/pages/player/player_dashboard_page/widgets/player_welcome_widget.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/solo_challenges_store.dart';
import 'package:isati_integration/src/providers/solo_validations_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class PlayerDashboardPage extends StatefulWidget {
  @override
  _PlayerDashboardPageState createState() => _PlayerDashboardPageState();
}

class _PlayerDashboardPageState extends State<PlayerDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: ScreenUtils.instance.defaultPadding,
        child: FutureBuilder<void>(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return IsStatusMessage(
                  title: "Erreur de chargement",
                  message: "Impossible de charger les données du tableau de bord : ${snapshot.error}",
                );
              }        

              return _buildDashboard();
            }
    
            return const Center(child: CircularProgressIndicator(),);
          }
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return RefreshIndicator(
      onRefresh: () => _loadData(forceRefresh: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth >= ScreenUtils.instance.breakpointPC) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _dashboardCards(),
                    );
                  }
    
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _dashboardCards(),
                  );
                },
              ),
            ),
            const SizedBox(height: 20,),
            Flexible(
              child: PlayerDashboardSoloChallenges(),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _dashboardCards() {
    return <Widget>[
      Flexible(child: PlayerWelcomeWidget()),
      const SizedBox(width: 20, height: 20,),
      Flexible(child: PlayerDashboardScore()),
    ];
  }

  Future _loadData({bool forceRefresh = false}) async {
    final AppUserStore appUserStore = Provider.of<AppUserStore>(context, listen: false);
    final SoloValidationsStore validationsStore = Provider.of<SoloValidationsStore>(context, listen: false);
    final SoloChallengesStore challengesStore = Provider.of<SoloChallengesStore>(context, listen: false);

    await validationsStore.getValidations(appUserStore.authenticationHeader, forceRefresh: forceRefresh);
    await challengesStore.getChallenges(appUserStore.authenticationHeader, forceRefresh: forceRefresh);

    if (forceRefresh) {
      await appUserStore.refresh();
      setState(() {});
    }
  }
}