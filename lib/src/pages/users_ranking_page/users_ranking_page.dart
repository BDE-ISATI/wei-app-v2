import 'package:flutter/material.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/src/pages/users_ranking_page/widgets/users_ranking_card.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/teams_store.dart';
import 'package:isati_integration/src/providers/user_store.dart';
import 'package:isati_integration/src/providers/users_ranking_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class UsersRankingPage extends StatefulWidget {
  const UsersRankingPage({Key? key}) : super(key: key);

  @override
  _UsersRankingPageState createState() => _UsersRankingPageState();
}

class _UsersRankingPageState extends State<UsersRankingPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UsersRankingStore>(
      builder: (context, usersRankingStore, child) {
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
                      message: "Impossible de charger les joueurs : ${snapshot.error}",
                      
                    );
                  }

                  final List<User> users = usersRankingStore.usersList;

                  // We want to display a message if their is no challenges
                  if (users.isEmpty) {
                    return const IsStatusMessage(
                      type: IsStatusMessageType.info,
                      title: "Tout est caché !",
                      message: "Le classement a été caché aux yeux de tous... Dernier ? "
                               "Premier ? Personne ne le sais alors force à toi pour être "
                               "en haut de la liste quand elle réaparaîtera !" 
                    );
                  }

                  return _buildUsersList(users: users);
                }

                return const Center(child: CircularProgressIndicator(),);
              },
            ),
          )
        );
      }
    );
  }

  Widget _buildUsersList({required List<User> users}) {
    return Consumer<AppUserStore>(
      builder: (context, appUserStore, child) {
        return RefreshIndicator(
          onRefresh: () => _loadData(forceRefresh: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < users.length; ++i) ...{
                  ChangeNotifierProvider(
                    create: (context) => UserStore(users[i]),
                    builder: (context, child) => UserRankingCard(
                      rank: i + 1,
                      highlight: users[i].id == appUserStore.id
                    ),
                  ),
                  const SizedBox(height: 16,),
                }
              ],
            ),
          ),
        );
      }
    );
  }

  Future _loadData({bool forceRefresh = false}) async {
    final AppUserStore appUserStore = Provider.of<AppUserStore>(context, listen: false);

    final TeamsStore teamsStore = Provider.of<TeamsStore>(context, listen: false);
    final UsersRankingStore usersRankingStore = Provider.of<UsersRankingStore>(context, listen: false);

    await teamsStore.getTeams(appUserStore.authenticationHeader, forceRefresh: forceRefresh);
    await usersRankingStore.getUsers(appUserStore.authenticationHeader, forceRefresh: forceRefresh);

    if (forceRefresh) {
      setState(() {});
    }
  }
}