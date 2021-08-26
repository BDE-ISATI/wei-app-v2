import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isati_integration/models/is_form_qa.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/services/authentication_service.dart';
import 'package:isati_integration/services/forms_service.dart';
import 'package:isati_integration/src/pages/register_page/widgets/is_painter.dart';
import 'package:isati_integration/src/pages/register_page/widgets/register_header.dart';
import 'package:isati_integration/src/shared/widgets/general/is_button.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_dropdown.dart';
import 'package:isati_integration/src/shared/widgets/inputs/is_text_input.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:isati_integration/utils/screen_utils.dart';
import 'package:painter/painter.dart';
import 'package:tuple/tuple.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // User related controller
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _passwordConfirmTextController = TextEditingController();
  
  // Questionnaire
  final PainterController _drawing1Controller = PainterController();
  final PainterController _drawing2Controller = PainterController();
  final PainterController _drawing3Controller = PainterController();
  PictureDetails? _drawing1;
  PictureDetails? _drawing2;
  PictureDetails? _drawing3;


  // "Closed" questions
  final String _qMateriauxTI = "Est-tu en matériaux ou en TI ?";
  final List<IsFormQA> _asMateriauxTI = [];
  int _currentMateriauxTI = 0;

  final String _qFisaFise = "Est-tu un FISA ou un FISE";
  final List<IsFormQA> _asFisaFise = [];
  int _currentFisaFise = 0;

  final String _qTenteESIR = "Serais-tu prêt.e à dormir dans une tente devant l’ESIR ?";
  final List<IsFormQA> _asTenteESIR = [];
  int _currentTenteESIR = 0;

  final String _qLoveDrinking = "Sur une échelle de 1 à 10, à quel point aimes-tu boire (de l’alcool pas de l’eau)";
  final List<IsFormQA> _asLoveDrinking = [];
  int _currentLoveDrinking = 0;

  final String _qRicard = "Est-ce que tu aimes le Ricard ?";
  final List<IsFormQA> _asRicard = [];
  int _currentRicard = 0;

  final String _qYourPartyType = "En soirée tu es plutôt du genre à :";
  final List<IsFormQA> _asYourPartyType = [];
  int _currentYourPartyType = 0;

  final String _qBestSunday = "Un dimanche idéale pour moi c’est :";
  final List<IsFormQA> _asBestSunday = [];
  int _currentBestSunday = 0;


  final String _qDifficultSituation = "Dans une situation difficile comment réagis- tu ?";
  final List<IsFormQA> _asDifficultSitaution = [];
  int _currentDifficultSituation = 0;

  final String _qIntroExtraVerti = "T’es plutôt introverti.e ou extraverti.e ?";
  final List<IsFormQA> _asIntroExtraVerti = [];
  int _currentIntroExtraVerti = 0;  

  final String _qAdventurer = "Tu es casanier.e ou aventurier.e ?";
  final List<IsFormQA> _asAdventurer = [];
  int _currentAdventurer = 0; 

  final String _qMoney = "T’es plutôt dépensier.e ou près de tes sous ?";
  final List<IsFormQA> _asMoney = [];
  int _currentMoney = 0;

  final String _qCharo = "Est-ce que tu es un.e charo?";
  final List<IsFormQA> _asCharo = [];
  int _currentCharo = 0;

  final String _qSingle = "Es-tu en couple ou célibataire ? (Dodo la Prez et Babou l’affamé veulent savoir)";
  final List<IsFormQA> _asSingle = [];
  int _currentSingle = 0;

  final String _qVibe = "Répondre à toutes ces questions ça t’a amusé ou c’est pas du tout ta vibe ?";
  final List<IsFormQA> _asVibe = [];
  int _currentVibe = 0;

  // "Open" questions
  final List<Tuple2<String, TextEditingController>> _openQuestions = [
    Tuple2("Comment se détendre après une dure journée de travail ?", TextEditingController()),
    Tuple2("Quelles sont tes séries préférées ?", TextEditingController()),
    Tuple2("Raconte nous une anecdote de tes dernières vacances", TextEditingController()),
    Tuple2("Raconte-nous ta blague la plus drôle ?", TextEditingController()),
    Tuple2("Quelle est THE chanson à passer en soirée ?", TextEditingController()),
    Tuple2("Quelle est la chose la plus folle que tu aies faite ?", TextEditingController()),
    Tuple2("C’est quoi tes hobbies dans la vie ?", TextEditingController()),
    Tuple2("Comment aimes-tu rencontrer des gens (Autour d’un verre, en cours, en club, en voyage…) ?", TextEditingController()),
    Tuple2("Quelle est ta pire rencontre ?", TextEditingController()),
    Tuple2("Un mot qui te décrirait ?", TextEditingController()),
    Tuple2("Pour toi, été rime avec…", TextEditingController()),
    Tuple2("Une chose que peu de personnes savent sur toi ?", TextEditingController()),
    Tuple2("A quel mystère voudrais-tu connaître la réponse ?", TextEditingController()),
    Tuple2("Pour quelle chose es-tu le plus susceptible de devenir célèbre ?", TextEditingController()),
    Tuple2("Quelle serait l’aventure la plus belle à vivre ?", TextEditingController()),
    Tuple2("Sur quoi pourrais-tu faire une présentation de 40 minutes sans préparation ?", TextEditingController()),
    Tuple2("A quoi ressemblerait un miroir montrant le contraire de toi-même ?", TextEditingController()),
    Tuple2("Quelle est la connerie dont tu ne retiens pas la leçon ?", TextEditingController()),
    Tuple2("Quel artiste aimes-tu écouter secrètement ?", TextEditingController()),
  ];

  bool _isLoading = false;
  String _errorMessage = "";
  String _successMessage = "";

  @override
  void initState() {
    super.initState();

    _drawing1Controller.thickness = 2.0;
    _drawing1Controller.drawColor = colorPrimary;
    _drawing1Controller.backgroundColor = colorScaffolddWhite;
    _drawing2Controller.thickness = 2.0;
    _drawing2Controller.drawColor = colorPrimary;
    _drawing2Controller.backgroundColor = colorScaffolddWhite;
    _drawing3Controller.thickness = 2.0;
    _drawing3Controller.drawColor = colorPrimary;
    _drawing3Controller.backgroundColor = colorScaffolddWhite;

    _asMateriauxTI.addAll([
      IsFormQA(_qMateriauxTI, "TI", 0),
      IsFormQA(_qMateriauxTI, "Matériaux", 0),
    ]);

    _asFisaFise.addAll([
      IsFormQA(_qFisaFise, "FISE", 0),
      IsFormQA(_qFisaFise, "FISA", 0),
    ]);

    _asTenteESIR.addAll([
      IsFormQA(_qTenteESIR, "Oui", 5),
      IsFormQA(_qTenteESIR, "Non", 0)
    ]);

    _asLoveDrinking.addAll([
      for (int i = 1; i <= 10; ++i) 
        IsFormQA(_qLoveDrinking, i.toString(), i ~/ 2)
    ]);

    _asRicard.addAll([
      IsFormQA(_qRicard, "Oui", 3),
      IsFormQA(_qRicard, "Non", 0)
    ]);

    _asYourPartyType.addAll([
      IsFormQA(_qYourPartyType, "Danser toute la night", 3),
      IsFormQA(_qYourPartyType, "Finir dans les toilettes à même pas minuit", 2),
      IsFormQA(_qYourPartyType, "Rester sur le canapé sans bouger", -2),
      IsFormQA(_qYourPartyType, "Te goinfrer des gâteaux apéro", 1),
      IsFormQA(_qYourPartyType, "Te lancer dans des discussions profondes sur la vie", 2),
      IsFormQA(_qYourPartyType, "Jouer à la pyramide", 3),
    ]);

    _asBestSunday.addAll([
      IsFormQA(_qBestSunday, "Dormir jusqu’à 18h pour récupérer de ma soirée de samedi", 3),
      IsFormQA(_qBestSunday, "Aller courir un semi marathon", 2),
      IsFormQA(_qBestSunday, "Animer la messe de ma paroisse", 0),
      IsFormQA(_qBestSunday, "Rester dans mon chez moi, réviser et planifier la semaine à veni", -2),
      IsFormQA(_qBestSunday, "Netflix and chill", 0),
      IsFormQA(_qBestSunday, "Voir des potes, boire et recommencer", 3),
      IsFormQA(_qBestSunday, "Développer un projet personnel", 1),
      IsFormQA(_qBestSunday, "Faire une maraude et donner mon temps pour ceux qui en ont besoin", 2),
    ]);

    _asDifficultSitaution.addAll([
      IsFormQA(_qDifficultSituation, "Je chante les lacs du Connemara", 2),
      IsFormQA(_qDifficultSituation, "Je fais trois tours de corde à sauter sans sauter", 2),
      IsFormQA(_qDifficultSituation, "Je pars élever des chèvres en Sibérie", 2),
      IsFormQA(_qDifficultSituation, "J’appelle mon ex avec le bigophone", -2),
      IsFormQA(_qDifficultSituation, "Aucune des réponses précédentes, double joker et je saute dans la Vilaine", 2),
    ]);

    _asIntroExtraVerti.addAll([
      IsFormQA(_qIntroExtraVerti, "Introverti.e", 0),
      IsFormQA(_qIntroExtraVerti, "Extraverti.e", 3)
    ]);

    _asAdventurer.addAll([
      IsFormQA(_qAdventurer, "Casanier.e", 0),
      IsFormQA(_qAdventurer, "Aventurer.e", 3)
    ]);

    _asMoney.addAll([
      IsFormQA(_qMoney, "Dépensier.e", 3),
      IsFormQA(_qMoney, "Près de mes sous", 0)
    ]);

    _asCharo.addAll([
      IsFormQA(_qCharo, "Charo", 3),
      IsFormQA(_qCharo, "Non pas charo", 0)
    ]);

    _asSingle.addAll([
      IsFormQA(_qSingle, "En couple <3", 0),
      IsFormQA(_qSingle, "En couple mais c'est pas grave", 3),
      IsFormQA(_qSingle, "Celibataire <3", 3)
    ]);

    _asVibe.addAll([
      IsFormQA(_qVibe, "Oui ! <3", 5),
      IsFormQA(_qVibe, "Non.", 0)
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= ScreenUtils.instance.breakpointPC) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _buildMainColumn(context)),
                Expanded(child: Image.asset("assets/images/background.jpg", fit: BoxFit.cover,)),
              ],
            );
          }

          return _buildMainColumn(context);
        }
      ),
    );
  }

  Widget _buildMainColumn(BuildContext context) {
    return Padding(
      padding: ScreenUtils.instance.defaultPadding,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: _isLoading ? const Center(child: CircularProgressIndicator(),) : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header part
              Text("Bienvenue à votre mois d'intégration !", style: Theme.of(context).textTheme.headline1),
              const SizedBox(height: 20,),
              RegisterHeader(),
              const SizedBox(height: 20,),
              if (_errorMessage.isNotEmpty) ...{
                IsStatusMessage(
                  title: "Erreur lors de l'inscription",
                  message: "Impossible de vous inscrire : $_errorMessage",
                ),
                const SizedBox(height: 20),
              }
              else if (_successMessage.isNotEmpty) ...{
                IsStatusMessage(
                  type: IsStatusMessageType.success,
                  title: "Bravo",
                  message: _successMessage,
                ),
                const SizedBox(height: 20),
              },
              // The form part
              const Text(
                "Voici un petit questionnaire qui te permettra "
                "de t'inscrire et qui nous permettra de te choisir "
                "une equipe. Répons avec honnêteté." 
              ),
              const SizedBox(height: 10),
              const Text(
                "NB : Pas de soucis à te faire, l'application est très "
                "bien faite, tes données sont sécurisé et seul ton BDE "
                "préféré pourra y avoir accès",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 40,),
              Flexible(
                child: _userFormPart(),
              ),
              const SizedBox(height: 40,),
              Flexible(
                child: _questionsFormPart(),
              ),
              const SizedBox(height: 20,),
              IsButton(
                text: "Envoyer mes réponses",
                onPressed: _submitForm,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _userFormPart() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Information pour l'inscription", style: Theme.of(context).textTheme.headline3,),
        const SizedBox(height: 30,),
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
        const SizedBox(height: 20,),
        IsTextInput(
          controller: _passwordTextController,
          obscureText: true,
          labelText: "Mot de passe",
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
          labelText: "Mot de passe (confirmation)",
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
      ],
    );
  }

  Widget _questionsFormPart() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Le questionnaire", style: Theme.of(context).textTheme.headline3,),
        const SizedBox(height: 30,),
        // Es-tu en matériaux ou en TI
        IsDropdown<int>(
          label: _qMateriauxTI,
          items: {
            for (int i = 0; i < _asMateriauxTI.length; ++i)
              i: _asMateriauxTI[i].answer
          },
          currentValue: _currentMateriauxTI,
          onChanged: (value) {
            setState(() {
              _currentMateriauxTI = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        // Es-tu un FISA ou un FIE ?
        IsDropdown<int>(
          label: _qFisaFise,
          items: {
            for (int i = 0; i < _asFisaFise.length; ++i)
              i: _asFisaFise[i].answer
          },
          currentValue: _currentFisaFise,
          onChanged: (value) {
            setState(() {
              _currentFisaFise = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        // Sertais-tu prêt.e à dormir dans une tente devant l'ESIR ?
        IsDropdown<int>(
          label: _qTenteESIR,
          items: {
            for (int i = 0; i < _asTenteESIR.length; ++i)
              i: _asTenteESIR[i].answer
          },
          currentValue: _currentTenteESIR,
          onChanged: (value) {
            setState(() {
              _currentTenteESIR = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        // Sur une échelle de 1 à 10, à quel point aimes-tu boire (de l’alcool pas de l’eau)
        IsDropdown<int>(
          label: _qLoveDrinking,
          items: {
            for (int i = 0; i < _asLoveDrinking.length; ++i)
              i: _asLoveDrinking[i].answer
          },
          currentValue: _currentLoveDrinking,
          onChanged: (value) {
            setState(() {
              _currentLoveDrinking = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        // Est-ce que tu aimes le Ricard ?
        IsDropdown<int>(
          label: _qRicard,
          items: {
            for (int i = 0; i < _asRicard.length; ++i)
              i: _asRicard[i].answer
          },
          currentValue: _currentRicard,
          onChanged: (value) {
            setState(() {
              _currentRicard = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        // En soirée tu es plutôt du genre à :
        IsDropdown<int>(
          label: _qYourPartyType,
          items: {
            for (int i = 0; i < _asYourPartyType.length; ++i)
              i: _asYourPartyType[i].answer
          },
          currentValue: _currentYourPartyType,
          onChanged: (value) {
            setState(() {
              _currentYourPartyType = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        // Un dimanche idéale pour moi c’est :
        IsDropdown<int>(
          label: _qBestSunday,
          items: {
            for (int i = 0; i < _asBestSunday.length; ++i)
              i: _asBestSunday[i].answer
          },
          currentValue: _currentBestSunday,
          onChanged: (value) {
            setState(() {
              _currentBestSunday = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        // Dans une situation difficile comment réagis- tu ?
        IsDropdown<int>(
          label: _qDifficultSituation,
          items: {
            for (int i = 0; i < _asDifficultSitaution.length; ++i)
              i: _asDifficultSitaution[i].answer
          },
          currentValue: _currentDifficultSituation,
          onChanged: (value) {
            setState(() {
              _currentDifficultSituation = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        // T’es plutôt introverti.e ou extraverti.e ?
        IsDropdown<int>(
          label: _qIntroExtraVerti,
          items: {
            for (int i = 0; i < _asIntroExtraVerti.length; ++i)
              i: _asIntroExtraVerti[i].answer
          },
          currentValue: _currentIntroExtraVerti,
          onChanged: (value) {
            setState(() {
              _currentIntroExtraVerti = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        // Tu es casanier.e ou aventurier.e ? 
        IsDropdown<int>(
          label: _qAdventurer,
          items: {
            for (int i = 0; i < _asAdventurer.length; ++i)
              i: _asAdventurer[i].answer
          },
          currentValue: _currentAdventurer,
          onChanged: (value) {
            setState(() {
              _currentAdventurer = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        // T’es plutôt dépensier.e ou près de tes sous? 
        IsDropdown<int>(
          label: _qMoney,
          items: {
            for (int i = 0; i < _asMoney.length; ++i)
              i: _asMoney[i].answer
          },
          currentValue: _currentMoney,
          onChanged: (value) {
            setState(() {
              _currentMoney = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        // Est-ce que tu es un.e charo?
        IsDropdown<int>(
          label: _qCharo,
          items: {
            for (int i = 0; i < _asCharo.length; ++i)
              i: _asCharo[i].answer
          },
          currentValue: _currentCharo,
          onChanged: (value) {
            setState(() {
              _currentCharo = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        // Es-tu en couple ou célibataire ? (Dodo la Prez et Babou l’affamé veulent savoir)
        IsDropdown<int>(
          label: _qSingle,
          items: {
            for (int i = 0; i < _asSingle.length; ++i)
              i: _asSingle[i].answer
          },
          currentValue: _currentSingle,
          onChanged: (value) {
            setState(() {
              _currentSingle = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        // Répondre à toutes ces questions ça t’a amusé ou c’est pas du tout ta vibe?
        IsDropdown<int>(
          label: _qVibe,
          items: {
            for (int i = 0; i < _asVibe.length; ++i)
              i: _asVibe[i].answer
          },
          currentValue: _currentVibe,
          onChanged: (value) {
            setState(() {
              _currentVibe = value ?? 0;
            });
          },
        ),
        const SizedBox(height: 20,),
        const Text("NB : A partir de là toutes les questions sont facultatives", style: TextStyle(fontStyle: FontStyle.italic),),
        const SizedBox(height: 20,),
        for (final openQuestion in _openQuestions) ...{
          IsTextInput(
            controller: openQuestion.item2,
            labelText: openQuestion.item1,
            hintText: "Une super réponse...",
            inputType: TextInputType.multiline,
            maxLines: 3,
            validator: null,
          ),
          const SizedBox(height: 20,),
        },
        const SizedBox(height: 20,),
        const Text("Dessins et expressions artistiques diverses (si il te reste du temps ou que tu as une âme artistique) :", style: TextStyle(fontStyle: FontStyle.italic),),
        const SizedBox(height: 20,),
        IsButton(
          text: "Premier dessin",
          buttonType: IsButtonType.secondary,
          onPressed: () async {
            final newImage = await showDialog<PictureDetails?>(
              context: context, 
              builder: (context) => 
                IsPainter(
                  controller: _drawing1Controller,
                  title: "Toi en dessin",
                ),
            );

            if (newImage != null) {
              _drawing1 = newImage;
            }
          },
        ),
        const SizedBox(height: 8,),
        IsButton(
          text: "Second dessin",
          buttonType: IsButtonType.secondary,
          onPressed: () async {
            final newImage = await showDialog<PictureDetails?>(
              context: context, 
              builder: (context) => 
                IsPainter(
                  controller: _drawing2Controller,
                  title: "Toi en dessin",
                ),
            );

            if (newImage != null) {
              _drawing2 = newImage;
            }
          },
        ),
        const SizedBox(height: 8,),
        IsButton(
          text: "Troisième dessin",
          buttonType: IsButtonType.secondary,
          onPressed: () async {
            final newImage = await showDialog<PictureDetails?>(
              context: context, 
              builder: (context) => 
                IsPainter(
                  controller: _drawing3Controller,
                  title: "Toi en dessin",
                ),
            );

            if (newImage != null) {
              _drawing3 = newImage;
            }
          },
        ),
      ]
    );
  }

  Future _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = "";
      _successMessage = "";
    });
    
    try {
      final String userId = await _registerUser();

      final formQas = [
        _asMateriauxTI[_currentMateriauxTI],
        _asFisaFise[_currentFisaFise],
        _asTenteESIR[_currentTenteESIR],
        _asRicard[_currentRicard],
        _asYourPartyType[_currentYourPartyType],
        _asBestSunday[_currentBestSunday],
        _asDifficultSitaution[_currentDifficultSituation],
        _asIntroExtraVerti[_currentIntroExtraVerti],
        _asAdventurer[_currentAdventurer],
        _asMoney[_currentMoney],
        _asCharo[_currentCharo],
        _asSingle[_currentSingle],
        _asVibe[_currentVibe],
        for (final openQuestion in _openQuestions)
          if (openQuestion.item2.text.isNotEmpty)
            IsFormQA(openQuestion.item1, openQuestion.item2.text, 0)
      ];

      final String image1 = _drawing1 != null ? base64Encode(await _drawing1!.toPNG()) : "R0lGODlhAQABAIAAAP7//wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==";
      final String image2 = _drawing2 != null ? base64Encode(await _drawing2!.toPNG()) : "R0lGODlhAQABAIAAAP7//wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==";
      final String image3 = _drawing3 != null ? base64Encode(await _drawing3!.toPNG()) : "R0lGODlhAQABAIAAAP7//wAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==";

      await FormsService.instance.submitForm(userId, formQas, image1, image2, image3);

      setState(() {
        _isLoading = false;
        _errorMessage = "";
        _successMessage = "Vous avez bien été enregistré ! Plus qu'a attendre qu'on vous attribue une équipe.";
      });
    }
    on PlatformException catch(e) {
      setState(() {
        _isLoading = false; 
        _errorMessage = "Impossible de faire l'inscription : ${e.code} ; ${e.message}";
        _successMessage = "";
      });
    }
    on Exception catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Une erreur inconnue s'est produite : $e";
        _successMessage = "";
      });
    }
  }

  Future<String> _registerUser() async {
    final User toRegister = User(null, 
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email:  _emailTextController.text,
      role: UserRoles.player
    );

    final String id = await AuthenticationService.instance.register(toRegister, _passwordConfirmTextController.text);

    return id;
  }
}