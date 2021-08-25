import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isati_integration/models/team_challenge.dart';
import 'package:isati_integration/services/team_challenges_service.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/team_challenge_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_app_bar.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_check_box.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_date_form_field.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_text_input.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class TeamChallengeEditPage extends StatefulWidget {
  @override
  State<TeamChallengeEditPage> createState() => _TeamChallengeEditPageState();
}

class _TeamChallengeEditPageState extends State<TeamChallengeEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController = TextEditingController();
  final TextEditingController _valueTextController = TextEditingController();
  final TextEditingController _numberOfRepetitionsTextController = TextEditingController();
  
  bool _shouldCountMembers = false;
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();

  bool _initialized = false;
  bool _isLoading = false;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<TeamChallengeStore>(
      builder: (context, teamChallengeStore, child) {
        if (!_initialized) {
          _titleTextController.text = teamChallengeStore.challenge.title;
          _descriptionTextController.text = teamChallengeStore.challenge.description;
          _valueTextController.text = teamChallengeStore.challenge.value.toString();
          _numberOfRepetitionsTextController.text = teamChallengeStore.challenge.numberOfRepetitions.toString();

          _shouldCountMembers = teamChallengeStore.challenge.shouldCountMembers;
          _startDate = teamChallengeStore.challenge.startingDate;
          _endDate = teamChallengeStore.challenge.endingDate;

          _initialized = true;
        }

        return Scaffold(
          appBar: IsAppBar(
            title: Text(teamChallengeStore.challenge.id == null ? 
              "Création d'un défis" : 
              "Modification du défis ${teamChallengeStore.challenge.title}"
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
                          message: "Nous n'avont pas pu sauvegarder le défis : $_errorMessage",
                        ),
                        const SizedBox(height: 20,)
                      },
                      IsTextInput(
                        controller: _titleTextController, 
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Le défis doit avoir un nom !";
                          }
              
                          return null;
                        }, 
                        labelText: "Nom du défis" ,
                        hintText: "La poulette russe",
                      ),
                      const SizedBox(height: 20,),
                       IsTextInput(
                        controller: _descriptionTextController, 
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Le défis doit avoir une description !";
                          }
              
                          return null;
                        }, 
                        labelText: "Déscription du défis" ,
                        hintText: "Vous devez tous donner 50€ à Alexandro...",
                        inputType: TextInputType.multiline,
                        maxLines: 5,
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20,),
                       IsTextInput(
                        controller: _valueTextController, 
                        validator: (value) {
                          if (value.isEmpty || int.tryParse(value) == null) {
                            return "Le défis doit avoir une valeur valide !";
                          }
              
                          return null;
                        }, 
                        labelText: "Valeur du défis" ,
                        hintText: "15",
                        inputType: TextInputType.number,
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20,),
                      IsCheckBox(
                        text: "Doit pouvoir compter les membres",
                        value: _shouldCountMembers,
                        onChanged: (value) {
                          setState(() {
                            _shouldCountMembers = value ?? false;
                          });
                        },
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20,),
                       IsTextInput(
                        controller: _numberOfRepetitionsTextController, 
                        validator: (value) {
                          if (value.isEmpty || int.tryParse(value) == null) {
                            return "Le défis doit avoir une nombre de répétitions valide !";
                          }
              
                          return null;
                        }, 
                        labelText: "Nombre de répétitions du défis" ,
                        hintText: "4",
                        inputType: TextInputType.number,
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20,),
                      IsDateFormField(
                        context: context,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialValue: _startDate,
                        validator: (value) {
                          if (value == null) {
                            return "Une date est obligatoire";
                          }

                          return null;
                        },
                        onChanged: (value) {
                          _startDate = value;
                        },
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20,),
                      IsDateFormField(
                        context: context,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialValue: _endDate,
                        validator: (value) {
                          if (value == null) {
                            return "Une date est obligatoire";
                          }

                          return null;
                        },
                        onChanged: (value) {
                          _endDate = value;
                        },
                      ),
                      // ignore: equal_elements_in_set
                      const SizedBox(height: 20),
                      IsButton(
                        text: "Sauvegarder",
                        onPressed: () => _onSavePressed(teamChallengeStore),
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

  Future _onSavePressed(TeamChallengeStore teamChallengeStore) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    teamChallengeStore.title = _titleTextController.text;
    teamChallengeStore.description = _descriptionTextController.text;
    teamChallengeStore.value = int.parse(_valueTextController.text);
    teamChallengeStore.shouldCountMembers = _shouldCountMembers;
    teamChallengeStore.numberOfRepetitions = int.parse(_numberOfRepetitionsTextController.text);
    teamChallengeStore.startingDate = _startDate!;
    teamChallengeStore.endingDate = _endDate!;

    try {
      final appUserStore = Provider.of<AppUserStore>(context, listen: false);

      if (teamChallengeStore.challenge.id == null) {
        final String id = await TeamChallengesService.instance.createChallenge(teamChallengeStore.challenge, authorization: appUserStore.authenticationHeader); 

        Navigator.of(context).pop(
          TeamChallenge(id, 
            title: teamChallengeStore.title,
            description: teamChallengeStore.description,
            value: teamChallengeStore.value,
            shouldCountMembers: teamChallengeStore.shouldCountMembers,
            numberOfRepetitions: teamChallengeStore.numberOfRepetitions,
            startingDate: teamChallengeStore.startingDate,
            endingDate: teamChallengeStore.endingDate 
          )
        );
      }
      else {
        await TeamChallengesService.instance.updateChallenge(teamChallengeStore.challenge, authorization: appUserStore.authenticationHeader);

        Navigator.of(context).pop();
      }
    }
    on PlatformException catch(e) {
      setState(() {
        _isLoading = false; 
        _errorMessage = "Impossible de sauvegarder le défis : ${e.code} ; ${e.message}";
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