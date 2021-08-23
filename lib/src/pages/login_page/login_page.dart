import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isati_integration/models/user.dart';
import 'package:isati_integration/services/authentication_service.dart';
import 'package:isati_integration/src/pages/login_page/widgets/login_form.dart';
import 'package:isati_integration/src/shared/widgets/general/is_status_message.dart';
import 'package:isati_integration/src/shared/widgets/is_button.dart';
import 'package:isati_integration/utils/screen_utils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: ScreenUtils.instance.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The header with ISATI logo and title
            Center(child: Image.asset("assets/images/logo.png", width: 96,)),
            Text("Connexion", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline1),
            const SizedBox(height: 20,),
            // A potential error message
            if (_errorMessage.isNotEmpty) ...{
              IsStatusMessage(
                title: "Erreur lors de la connexion",
                message: _errorMessage,
              ),
              const SizedBox(height: 20,),
            },
            // The actual login form
            // NB We show a progress indicator on loading
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator(),))
            else ...{
              Expanded(
                child: LoginForm(
                  formKey: _loginFormKey,
                  emailTextController: _emailTextController,
                  passwordTextController: _passwordTextController,
                ),
              ),
              const SizedBox(height: 20,),
              IsButton(
                text: "Se connecter",
                onPressed: _onLoginPressed,
              )
            }
          ],
        ),
      ),
    );
  }

  Future _onLoginPressed() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    try {
      // We need block the login form
      // to avoid multiple request
      setState(() {
        _isLoading = true;
        _errorMessage = "";
      });

      final User loggedUser = await AuthenticationService.instance.login(
        _emailTextController.text, 
        _passwordTextController.text
      );

      Navigator.of(context).pop(loggedUser);     
    }
    on PlatformException catch(e) {
      setState(() {
        _isLoading = false; 
        _errorMessage = "Impossible de se connecter : ${e.code} ; ${e.message}";
        _passwordTextController.text = "";
      });
    }
    on Exception catch(e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Une erreur inconnue s'est produite : $e";
        _passwordTextController.text = "";
      });
    }
  }
}