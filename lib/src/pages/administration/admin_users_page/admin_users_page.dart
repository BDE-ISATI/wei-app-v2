import 'package:flutter/material.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/src/pages/user_edit_profile_page.dart/user_edit_profile_page.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/teams_store.dart';
import 'package:isati_integration/src/providers/user_store.dart';
import 'package:isati_integration/src/providers/users_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_text_field.dart';
import 'package:isati_integration/src/shared/widgets/user_card.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class AdminUsersPage extends StatefulWidget {
  @override
  _AdminUsersPageState createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  String _usreNameFilter = "";

  final TextEditingController _filterTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Padding(
      padding: ScreenUtils.instance.defaultPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IsTextField(
            controller: _filterTextController,
            labelText: "Filtrer les utilisateurs",
            hintText: "Victor DENIS...",
            onChanged: (value) {
              setState(() {
                _usreNameFilter = value;
              });
            },
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: Consumer<UsersStore>(
              builder: (context, usersStore, child) {
                return  FutureBuilder<void>(
                    future: _loadAppData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return IsStatusMessage(
                            title: "Erreur de chargement",
                            message: "Impossible de charger les utilisateurs : ${snapshot.error}",
                            
                          );
                        }
                  
                        // We want to display a message if their is no challenges
                        if (usersStore.usersList.isEmpty) {
                          return const IsStatusMessage(
                            type: IsStatusMessageType.info,
                            title: "Pas de d'utilisateur",
                            message: "Je me demande comment vous avez fait pour en arriver là...",
                                    
                          );
                        }
                  
                        return _buildUsersList(users: usersStore.usersList);
                      }
                  
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  );
                }
              ),
          )
          ]
        )
      )
    );
  }

  Widget _buildUsersList({required List<User> users}) {
    return RefreshIndicator(
      onRefresh: () => _loadAppData(forceRefresh: true),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                for (final user in users)
                  if (_usreNameFilter.isEmpty || user.fullName.toLowerCase().contains(_usreNameFilter.toLowerCase()))
                    ChangeNotifierProvider(
                      create: (context) => UserStore(user),
                      builder: (context, child) => UserCard(
                        width: constraints.maxWidth > 500 ? 320 : constraints.maxWidth,
                        buttonText: "Modifier",
                        onButtonPressed: () => _onUpateUserPressed(context, Provider.of<UserStore>(context, listen: false)),
                      ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  Future _loadAppData({bool forceRefresh = false}) async {
    final UsersStore usersStore = Provider.of<UsersStore>(context, listen: false);
    final TeamsStore teamsStore = Provider.of<TeamsStore>(context, listen: false);

    final AppUserStore appUserStore = Provider.of<AppUserStore>(context, listen: false);

    await usersStore.getUsers(appUserStore.authenticationHeader, forceRefresh: forceRefresh);
    await teamsStore.getTeams(appUserStore.authenticationHeader, forceRefresh: forceRefresh);

    if (forceRefresh) {
      setState(() {});
    }
  }

  Future _onUpateUserPressed(BuildContext context, UserStore userStore) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: userStore,
          builder: (context, child) => const UserEditProfilePage(),
        ),
      )
    );
  }
}