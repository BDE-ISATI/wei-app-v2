import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/services/users_service.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/teams_store.dart';
import 'package:isati_integration/src/providers/user_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_app_bar.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_dropdown.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_image_picker.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_text_input.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class UserEditProfilePage extends StatefulWidget {
  const UserEditProfilePage({Key? key, this.shouldPopOnSave = true}) : super(key: key);

  final bool shouldPopOnSave;

  @override
  State<UserEditProfilePage> createState() => _UserEditProfilePageState();
}

class _UserEditProfilePageState extends State<UserEditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _scoreTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _passwordConfirmTextController = TextEditingController();
  
  String _newImageString = "";
  String _role = UserRoles.player;
  String _teamId = "";

  bool _initialized = false;
  bool _isLoading = false;
  String _errorMessage = "";
  String _sucessMessage  = "";

  @override
  Widget build(BuildContext context) {
    return Consumer3<UserStore, TeamsStore, AppUserStore>(
      builder: (context, userStore, teamsStore, appUserStore, child) {
        final User userToUse = userStore.user;

        if (!_initialized) {
          _firstNameController.text = userToUse.firstName;
          _lastNameController.text = userToUse.lastName;
          _emailTextController.text = userToUse.email;
          _scoreTextController.text = userToUse.score.toString();

          _role = userToUse.role;
          _teamId = userToUse.team != null ? userToUse.team!.id! : "";

          _initialized = true;
        }

        return Scaffold(
          appBar: IsAppBar(
            title: Text("Modification du profile de ${userToUse.fullName}"),
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
                          message: "Nous n'avont pas pu sauvegarder le profile : $_errorMessage",
                        ),
                        const SizedBox(height: 20,)
                      }
                      else if (_sucessMessage.isNotEmpty) ...{
                        IsStatusMessage(
                          type: IsStatusMessageType.success,
                          title: "Bravo",
                          message: _sucessMessage
                        ),
                        const SizedBox(height: 20,),
                      },
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              width: 96,
                              height: 96,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(48),
                                child: IsImagePicker(
                                  initialImage: userToUse.profilePicture.image,
                                  onUpdated: (value) {
                                    _newImageString = value;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ]
                      ),
                      const SizedBox(height: 20,),
                      IsTextInput(
                        controller: _firstNameController, 
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Vous devez rentrer un prénom";
                          }
              
                          return null;
                        }, 
                        labelText: "Prénom" ,
                        hintText: "Victor...",
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20,),
                      IsTextInput(
                        controller: _lastNameController, 
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Vous devez rentrer un nom";
                          }
              
                          return null;
                        }, 
                        labelText: "Nom" ,
                        hintText: "DENIS...",
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20,),
                      IsTextInput(
                        controller: _emailTextController, 
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Vous devez rentrer une email";
                          }

                          final bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);

                          if (!emailValid) {
                            return "L'email semble invalide...";
                          }

                          return null;
                        }, 
                        labelText: "Adresse email" ,
                        hintText: "contact@felrise.com...",
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20,),
                      if (appUserStore.user!.role == UserRoles.admin) ...{
                        IsTextInput(
                          controller: _scoreTextController, 
                          validator: (value) {
                            if (value.isEmpty || int.tryParse(value) == null) {
                              return "L'utilisateur doit avoir un score valide !";
                            }
                
                            return null;
                          }, 
                          labelText: "Score du joueur" ,
                          hintText: "15",
                          inputType: TextInputType.number,
                        ),
                        // ignore: equal_elements_in_set
                        const SizedBox(height: 20,),
                        IsDropdown<String>(
                          currentValue: _role,
                          items: UserRoles.detailled,
                          label: "Role de l'utilisateur",
                          onChanged: (value) {
                            setState(() {
                              _role = value ?? UserRoles.player;
                            });
                          },
                        ),
                        // ignore: equal_elements_in_set
                        const SizedBox(height: 20,),
                        IsDropdown<String>(
                          currentValue: _teamId,
                          items: {
                            "": "Pas d'équipe",
                            for (final team in teamsStore.teamsList) 
                              team.id!: team.name
                          },
                          label: "Equipe de l'utilisateur",
                          onChanged: (value) {
                            _teamId = value ?? "";
                          },
                        )
                      },
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20),
                      IsTextInput(
                        controller: _passwordTextController,
                        obscureText: true,
                        labelText: "Nouveau mot de passe",
                        hintText: "Mot de passe",
                        validator: (value) {
                          if (_passwordConfirmTextController.text.isNotEmpty &&
                              _passwordConfirmTextController.text != value) {
                            return "Le mot de passe et la confirmation ne correspondent pas";
                          }

                          return null;
                        },
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20,),
                      IsTextInput(
                        controller: _passwordConfirmTextController,
                        obscureText: true,
                        labelText: "Nouveau mot de passe (confirmation)",
                        hintText: "Mot de passe",
                        validator: (value) {
                          if (value.isEmpty && _passwordTextController.text.isNotEmpty) {
                            return "La confirmation ne peut pas être vide";
                          }

                          if (value != _passwordTextController.text) {
                            return "Le mot de passe et la confirmation ne correspondent pas";
                          }

                          return null;
                        },
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20,),
                      IsButton(
                        text: "Sauvegarder",
                        onPressed: () => _onSavePressed(userStore, teamsStore),
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

  Future _onSavePressed(UserStore userStore, TeamsStore teamsStore) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = "";
      _sucessMessage = "";
    });
    
    userStore.user.firstName = _firstNameController.text;
    userStore.user.lastName = _lastNameController.text;
    userStore.user.email = _emailTextController.text;
    userStore.user.score = int.tryParse(_scoreTextController.text) ?? userStore.user.score;
    userStore.user.role = _role;
    userStore.user.team = _teamId.isNotEmpty ? teamsStore.teams[_teamId] : null;


    if (_newImageString.isNotEmpty) {
      userStore.user.profilePicture.image = MemoryImage(base64Decode(_newImageString));
    }

    userStore.hasBeenUpdated();

    final appUserStore = Provider.of<AppUserStore>(context, listen: false);

    if (appUserStore.id == userStore.user.id) {
      appUserStore.hasBeenUpdated();
    }

    try {
      final appUserStore = Provider.of<AppUserStore>(context, listen: false);

      await UsersService.instance.updateUser(
        userStore.user,
        _newImageString, 
        newPassword: _passwordConfirmTextController.text.isNotEmpty ? _passwordConfirmTextController.text : null,
        authorization: appUserStore.authenticationHeader
      );

      setState(() {
        _isLoading = false;
        _errorMessage = "";
        _sucessMessage = "Bravo, votre profile à bien été mise à jour";
      });

      if (widget.shouldPopOnSave) {
        Navigator.of(context).pop(true);
      }
    }
    on PlatformException catch(e) {
      setState(() {
        _isLoading = false; 
        _errorMessage = "Impossible de sauvegarder l'utilisateur : ${e.code} ; ${e.message}";
        _sucessMessage = "";
      });
    }
    on Exception catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Une erreur inconnue s'est produite : $e";
        _sucessMessage = "";
      });
    }
  }
}