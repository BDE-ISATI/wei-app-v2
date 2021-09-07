import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isati_integration/models/solo_challenge.dart';
import 'package:isati_integration/services/solo_validations_service.dart';
import 'package:isati_integration/src/pages/waiting_solo_validations_page/waiting_solo_validation_proofs_page/widgets/proof_button.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/solo_challenges_store.dart';
import 'package:isati_integration/src/providers/solo_validation_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_app_bar.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_text_input.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class WaitingSoloValidationProofsPage extends StatefulWidget {
  @override
  State<WaitingSoloValidationProofsPage> createState() => _WaitingSoloValidationProofsPageState();
}

class _WaitingSoloValidationProofsPageState extends State<WaitingSoloValidationProofsPage> {
  bool _isLoading = false;
  String _errorMessage = "";

  final GlobalKey<FormState> _extraPointsState = GlobalKey<FormState>();
  final TextEditingController _extraPointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer3<SoloValidationStore, SoloChallengesStore, AppUserStore>(
      builder: (context, soloValidationStore, soloChallengesStore, appUserStore, child) {
        final SoloChallenge challenge = soloChallengesStore.challenges[soloValidationStore.validation.challengeId]!;

        return Scaffold(
          appBar: const IsAppBar(
            title: Text("Preuves"),
          ),
          body: Padding(
            padding: ScreenUtils.instance.defaultPadding,
            child: Column(
              mainAxisAlignment: _isLoading ? MainAxisAlignment.center : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_isLoading) ...{
                  const Center(child: CircularProgressIndicator(),),
                  const SizedBox(height: 8.0,),
                }
                else ...{
                  if (_errorMessage.isNotEmpty) ... {
                    IsStatusMessage(
                      title: "Erreur lors de l'envoie",
                      message: "Impossible de valider les preuves : $_errorMessage. N'hésite pas à contacter un administrateur si le problème persiste.",
                    )
                  },
                  Text("Objectifs du défis : ${challenge.description}"),
                  const SizedBox(height: 8,),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: ScreenUtils.instance.responsiveCrossAxisCount(context),
                      children: [
                        for (final fileId in soloValidationStore.validation.filesIds!) 
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FutureBuilder(
                              future: SoloValidationsService.instance.getValidationImage(fileId, authorization: appUserStore.authenticationHeader),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  if (snapshot.hasError) {
                                    return Text("Erreur ${snapshot.error}");
                                  }

                                  return ProofButton(media: snapshot.data as String);
                                }

                                return Container(
                                  decoration: BoxDecoration(
                                    color: colorScaffolddWhite,
                                    borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  height: 200,
                                  width: 200,
                                  child: const Center(child: CircularProgressIndicator(),),
                                );
                              },
                            ),
                          ),
                      ], 
                    ),
                  ),
                  Text("Score de base donné : ${challenge.value} point(s)", style: Theme.of(context).textTheme.headline6,),
                  // ignore: equal_elements_in_set
                  const SizedBox(height: 8,),
                  Form(
                    key: _extraPointsState,
                    child: IsTextInput(
                      labelText: "Points supplémentaires (peut être négatif)",
                      hintText: "0",
                      controller: _extraPointsController,
                      inputType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          value = "0";
                          _extraPointsController.text = "0";
                        }

                        if (int.tryParse(value) == null) {
                          return "Vous devez rentrer un nombre valide";
                        }

                        return null;
                      }
                    ),
                  ),
                  const SizedBox(height: 8,),
                  IsButton(
                    text: "Valider",
                    onPressed: () => _onAcceptValidation(soloValidationStore),
                  ),
                  // ignore: equal_elements_in_set
                  const SizedBox(height: 8,),
                  IsButton(
                    buttonType: IsButtonType.secondary,
                    text: "Rejeter",
                    onPressed: () => _onRejectValidation(soloValidationStore),
                  )
                }
              ],
            ),
          ),
        );
      }
    );
  }

  Future _onAcceptValidation(SoloValidationStore soloValidationStore) async {
    if (!_extraPointsState.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final appUserStore = Provider.of<AppUserStore>(context, listen: false);

      await SoloValidationsService.instance.acceptValidation(
        soloValidationStore.validation.id!, 
        int.parse(_extraPointsController.text), 
        authorization: appUserStore.authenticationHeader
      );

      Navigator.of(context).pop(true);
    }
    on PlatformException catch(e) {
      setState(() {
        _isLoading = false; 
        _errorMessage = "Impossible de valider : ${e.code} ; ${e.message}";
      });
    }
    on Exception catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Une erreur inconnue s'est produite : $e";
      });
    }
  }
  
  Future _onRejectValidation(SoloValidationStore soloValidationStore) async {
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final appUserStore = Provider.of<AppUserStore>(context, listen: false);

      await SoloValidationsService.instance.rejectValidation(
        soloValidationStore.validation.id!, 
        authorization: appUserStore.authenticationHeader
      );

      Navigator.of(context).pop(true);
    }
    on PlatformException catch(e) {
      setState(() {
        _isLoading = false; 
        _errorMessage = "Impossible de rejeter : ${e.code} ; ${e.message}";
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