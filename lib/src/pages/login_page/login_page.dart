import 'package:flutter/material.dart';
import 'package:isati_integration/src/pages/login_page/widgets/login_form.dart';
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
            Center(child: Image.asset("assets/images/logo.png", width: 96,)),
            Text("Connexion", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headline1),
            const SizedBox(height: 20,),
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
          ],
        ),
      ),
    );
  }

  void _onLoginPressed() {

  }
}