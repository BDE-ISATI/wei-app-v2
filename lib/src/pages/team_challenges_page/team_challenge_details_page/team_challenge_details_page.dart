import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:isati_integration/models/team_challenge.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/services/team_validations_service.dart';
import 'package:isati_integration/src/providers/app_user_store.dart';
import 'package:isati_integration/src/providers/team_challenge_store.dart';
import 'package:isati_integration/src/providers/teams_store.dart';
import 'package:isati_integration/src/shared/widgets/general/is_app_bar.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_dropdown.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_text_input.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:provider/provider.dart';

class TeamChallengeDetailsPage extends StatefulWidget {
  const TeamChallengeDetailsPage({
    Key? key, 
    this.showButton = true
  }) : super(key: key);

  final bool showButton;

  @override
  State<TeamChallengeDetailsPage> createState() => _TeamChallengeDetailsPageState();
}

class _TeamChallengeDetailsPageState extends State<TeamChallengeDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _extraPointsTextController = TextEditingController();
  final TextEditingController _membersCountTextController = TextEditingController();
  String? _teamToValidated;

  bool _isLoading = false;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Consumer3<TeamChallengeStore, TeamsStore, AppUserStore>(
      builder: (context, teamChallengeStore, teamsStore, appUserStore, child) {
        final TeamChallenge challenge = teamChallengeStore.challenge;

        return Scaffold(
          appBar: IsAppBar(
            title: Text(challenge.title),
          ),
          body: FutureBuilder(
            future: teamsStore.getTeams(Provider.of<AppUserStore>(context, listen: false).authenticationHeader),
            builder: (contex, snapshott) {
              if (snapshott.connectionState == ConnectionState.done) {
                if (snapshott.hasError) {
                  return IsStatusMessage(
                    title: "Erreur de chargement",
                    message: "Une erreur est survenue : ${snapshott.error}",
                  );
                }

                if (_teamToValidated == null) {
                  _membersCountTextController.text = "1";
                  if (appUserStore.user!.role == UserRoles.captain) {
                    _teamToValidated = appUserStore.user!.team!.id!;
                  }
                  else {
                    _teamToValidated = teamsStore.teamsList.first.id!;
                  }
                }

                return Padding(
                  padding: ScreenUtils.instance.defaultPadding,
                  child: _isLoading ? const Center(child: CircularProgressIndicator(),) : LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_errorMessage.isNotEmpty)
                              IsStatusMessage(
                                title: "Erreur",
                                message: "Impossible de valider ce défis : $_errorMessage",
                              ),
                            Flexible(
                              child: (constraints.maxWidth < ScreenUtils.instance.breakpointPC) ?
                                _buildSmallHeader(context, teamChallengeStore, teamsStore) :
                                _buildBigHeader(context, teamChallengeStore, teamsStore)
                            ),
                            const SizedBox(height: 20,),
                            Text(challenge.description)
                          ],
                        ),
                      );
                    },
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator(),);
            }
          )
        );
      }
    );
  }

  Widget _buildSmallHeader(BuildContext context, TeamChallengeStore teamChallengeStore, TeamsStore teamsStore) {
    final TeamChallenge challenge = teamChallengeStore.challenge;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildChallengeImage(challenge, maxHeight: 200),
        const SizedBox(height: 20),
        Flexible(
          child: _buildChallengeInfoWrap(challenge),
        ),
        const SizedBox(height: 20,),
        Flexible(child: _buildForm(context, teamChallengeStore, teamsStore))
      ],
    );
  }

  Widget _buildBigHeader(BuildContext context, TeamChallengeStore teamChallengeStore, TeamsStore teamsStore) {
    final TeamChallenge challenge = teamChallengeStore.challenge;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The challenge image
        SizedBox(
          width: 300,
          child: _buildChallengeImage(challenge), 
        ),
        const SizedBox(width: 20,),
        // The challenge title and informations
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(challenge.title, style: Theme.of(context).textTheme.headline2,),
              const SizedBox(height: 8),
              // The informations
              Flexible(
                child: _buildChallengeInfoWrap(challenge), 
              ),
              const SizedBox(height: 20,),
              Flexible(child: _buildForm(context, teamChallengeStore, teamsStore))
            ],
          ),
        )
      ],
    );
  }

  Widget _buildForm(BuildContext context, TeamChallengeStore teamChallengeStore, TeamsStore teamsStore) {
    if (!widget.showButton || teamChallengeStore.challenge.numberOfRepetitions <= 0) {
      return Container();
    }

    final appUser = Provider.of<AppUserStore>(context, listen: false);

    if (appUser.user!.role != UserRoles.player) {
      return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (appUser.user!.role == UserRoles.admin) ...{
              IsDropdown<String>(
                label: "Equipe à qui donner les points",
                items: {
                  for (final team in teamsStore.teamsList)
                    team.id!: team.name
                }, 
                currentValue: _teamToValidated!, 
                onChanged: (value) {
                  setState(() {
                    _teamToValidated = value;
                  });
                } 
              ),
              const SizedBox(height: 8)
            },
            IsTextInput(
              labelText: "Points supplémentaires (peut être négatif)",
              hintText: "0",
              controller: _extraPointsTextController,
              inputType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  value = "0";
                  _extraPointsTextController.text = "0";
                }

                if (int.tryParse(value) == null) {
                  return "Vous devez rentrer un nombre valide";
                }

                return null;
              },
            ),
            if (teamChallengeStore.challenge.shouldCountMembers) 
              IsTextInput(
                labelText: "Membres aillant complété le défis",
                hintText: "1",
                controller: _membersCountTextController,
                inputType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    value = "1";
                    _membersCountTextController.text = "1";
                  }

                  if (int.tryParse(value) == null) {
                    return "Vous devez rentrer un nombre valide";
                  }

                  return null;
                },
              ),
            const SizedBox(height: 8.0,),
            IsButton(
              text: "Valider le défis",
              onPressed: () => _onValidatedPressed(context, teamChallengeStore)
            )
          ],
        ),
      );
    }

    return Container();
  }

  Widget _buildChallengeImage(TeamChallenge challenge, { double maxHeight = 500 }) {
    return  Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            offset: Offset(0.0, 10.0),
            blurRadius: 12.0,
            spreadRadius: -5.0
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset("assets/images/background.jpg", fit: BoxFit.cover,)
      )
    );
  }

  Widget _buildChallengeInfoWrap(TeamChallenge challenge) {
    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        _buildChallengeInfoWidget(icon: Icons.calendar_today, text: "Fini le ${DateFormat('dd/MM/yyyy').format(challenge.endingDate)}"),
        _buildChallengeInfoWidget(icon: Icons.military_tech, text: "Rapporte ${challenge.value} point(s)"),
        _buildChallengeInfoWidget(icon: Icons.loop, text: "Doit être fait ${challenge.numberOfRepetitions} fois"),
      ],
    );
  }

  Widget _buildChallengeInfoWidget({required IconData icon, required String text}) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8,),
          Flexible(child: Text(text, style: const TextStyle(fontStyle: FontStyle.italic),))
        ],
      ),
    );
  }

  Future _onValidatedPressed(BuildContext context, TeamChallengeStore teamChallengeStore) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    try {
      final appUserStore = Provider.of<AppUserStore>(context, listen: false);

      await TeamValidationsService.instance.submiValidation(
        teamChallengeStore.challenge.id!,
        _teamToValidated!,
        int.parse(_membersCountTextController.text),
        int.parse(_extraPointsTextController.text), 
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
}