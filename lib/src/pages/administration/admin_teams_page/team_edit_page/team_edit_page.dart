import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isati_integration/models/team.dart';
import 'package:isati_integration/services/teams_service.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/team_store.dart';
import 'package:isati_integration/src/providers/users_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_app_bar.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_dropdown.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_text_input.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class TeamEditPage extends StatefulWidget {
  @override
  State<TeamEditPage> createState() => _TeamEditPageState();
}

class _TeamEditPageState extends State<TeamEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _colorTextController = TextEditingController();

  String? _captainId;

  bool _initialized = false;
  bool _isLoading = false;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Consumer2<TeamStore, UsersStore>(
      builder: (context, teamStore, usersStore, child) {
        if (!_initialized) {
          _nameTextController.text = teamStore.name;
          _colorTextController.text = teamStore.teamColor;
          _captainId = teamStore.team.captainId ?? "";

          _initialized = true;
        }

        return Scaffold(
          appBar: IsAppBar(
            title: Text(teamStore.team.id == null ? 
              "Création d'une équipe" : 
              "Modification de l'équipe ${teamStore.team.name}"
            ),
          ),
          body: Padding(
            padding: ScreenUtils.instance.defaultPadding,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator(),)
                    else ...{
                      if (_errorMessage.isNotEmpty) ...{
                        IsStatusMessage(
                          title: "Une erreur s'est produite",
                          message: "Nous n'avont pas pu sauvegarder l'équipe : $_errorMessage",
                        ),
                        const SizedBox(height: 20,)
                      },
                      IsTextInput(
                        controller: _nameTextController, 
                        validator: (value) {
                          if (value.isEmpty) {
                            return "L'équipe doit avoir un nom !";
                          }
              
                          return null;
                        }, 
                        labelText: "Nom de l'équipe" ,
                        hintText: "Isatirebouchon",
                      ),
                      const SizedBox(height: 20,),
                      IsDropdown<String?>(
                        items: {
                          "": "Pas de capitaine",
                          for (final user in usersStore.usersList)
                            user.id: user.fullName
                        },
                        currentValue: _captainId, 
                        onChanged: (value) {
                          setState(() {
                            _captainId = value;
                          });
                        }
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20),
                      IsTextInput(
                        controller: _colorTextController, 
                        validator: (value) {
                          if (value.isEmpty) {
                            return "L'équipe doit avoir une couleur";
                          }
              
                          return null;
                        }, 
                        labelText: "Couleur de l'équipe (au format #rrggbb)",
                        hintText: "#47a234",
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20),
                      IsButton(
                        text: "Sauvegarder",
                        onPressed: () => _onSavePressed(teamStore),
                      )
                    }
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Future _onSavePressed(TeamStore teamStore) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    teamStore.captainId = _captainId!.isEmpty ? null : _captainId;
    teamStore.name = _nameTextController.text;
    teamStore.teamColor = _colorTextController.text;

    try {
      final appUserStore = Provider.of<AppUserStore>(context, listen: false);

      if (teamStore.team.id == null) {
        final String id = await TeamsService.instance.createTeam(teamStore.team, authorization: appUserStore.authenticationHeader); 

        Navigator.of(context).pop(
          Team(id, 
            captainId: teamStore.captainId,
            name: teamStore.name, 
            teamColor: teamStore.teamColor
          )
        );
      }
      else {
        await TeamsService.instance.updateTeam(teamStore.team, authorization: appUserStore.authenticationHeader);

        Navigator.of(context).pop();
      }
    }
    on PlatformException catch(e) {
      setState(() {
        _isLoading = false; 
        _errorMessage = "Impossible de sauvegarder l'équipe : ${e.code} ; ${e.message}";
      });
    }
    on Exception catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Une erreur inconnue s'est produite : $e";
      });
    }
  }
}