import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isati_integration/models/solo_challenge.dart';
import 'package:isati_integration/services/solo_challenges_service.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/solo_challenge_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_app_bar.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_date_form_field.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_image_picker.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_text_input.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class SoloChallengeEditPage extends StatefulWidget {
  @override
  State<SoloChallengeEditPage> createState() => _SoloChallengeEditPageState();
}

class _SoloChallengeEditPageState extends State<SoloChallengeEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _descriptionTextController = TextEditingController();
  final TextEditingController _valueTextController = TextEditingController();
  final TextEditingController _numberOfRepetitionsTextController = TextEditingController();
  
  DateTime? _startDate = DateTime.now();
  DateTime? _endDate = DateTime.now();

  String _newImageString = "";

  bool _initialized = false;
  bool _isLoading = false;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Consumer<SoloChallengeStore>(
      builder: (context, soloChallengeStore, child) {
        if (!_initialized) {
          _titleTextController.text = soloChallengeStore.challenge.title;
          _descriptionTextController.text = soloChallengeStore.challenge.description;
          _valueTextController.text = soloChallengeStore.challenge.value.toString();
          _numberOfRepetitionsTextController.text = soloChallengeStore.challenge.numberOfRepetitions.toString();

          _startDate = soloChallengeStore.challenge.startingDate;
          _endDate = soloChallengeStore.challenge.endingDate;

          _initialized = true;
        }

        return Scaffold(
          appBar: IsAppBar(
            title: Text(soloChallengeStore.challenge.id == null ? 
              "Création d'un défis" : 
              "Modification du défis ${soloChallengeStore.challenge.title}"
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          height: 200,
                          child: IsImagePicker(
                            initialImage: soloChallengeStore.challenge.challengeImage.image,
                            onUpdated: (value) {
                              _newImageString = value;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
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
                      // ignore: equal_elements_in_set
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
                        onPressed: () => _onSavePressed(soloChallengeStore),
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

  Future _onSavePressed(SoloChallengeStore soloChallengeStore) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    soloChallengeStore.title = _titleTextController.text;
    soloChallengeStore.description = _descriptionTextController.text;
    soloChallengeStore.value = int.parse(_valueTextController.text);
    soloChallengeStore.numberOfRepetitions = int.parse(_numberOfRepetitionsTextController.text);
    soloChallengeStore.startingDate = _startDate!;
    soloChallengeStore.endingDate = _endDate!;

    try {
      final appUserStore = Provider.of<AppUserStore>(context, listen: false);

      if (soloChallengeStore.challenge.id == null) {
        final String id = await SoloChallengesService.instance.createChallenge(soloChallengeStore.challenge, _newImageString, authorization: appUserStore.authenticationHeader); 

        Navigator.of(context).pop(
          SoloChallenge(id, 
            title: soloChallengeStore.title,
            description: soloChallengeStore.description,
            value: soloChallengeStore.value,
            numberOfRepetitions: soloChallengeStore.numberOfRepetitions,
            startingDate: soloChallengeStore.startingDate,
            endingDate: soloChallengeStore.endingDate 
          )
        );
      }
      else {
        await SoloChallengesService.instance.updateChallenge(soloChallengeStore.challenge, _newImageString, authorization: appUserStore.authenticationHeader);

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