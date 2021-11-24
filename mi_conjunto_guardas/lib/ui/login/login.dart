import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/provider_models/residential_block_provider.dart';
import 'package:mi_conjunto_guardas/ui/common/alert_dialog.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_elevated_button.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors.dart' as AppColors;
import '../../constants/strings.dart' as AppStrings;
import 'package:provider/provider.dart';

/// Página de login del conjunto residencial
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool passwordHidden = true;
  bool isLoading = false;
  String errorPasswordCredentialsText = "";

  @override
  Widget build(BuildContext context) {
    final _residentialBlockData = context.watch<ResidentialBlockProvider>();
    return Scaffold(
        body: ListView(children: [
      _buildAppLogo(),
      SizedBox(
        height: 100,
      ),
      _buildEmailTextField(),
      _buildPasswordTextField(),
      SizedBox(
        height: 20,
      ),
      _buildLoginButton(_residentialBlockData)
    ]));
  }

  _doLoginAttempt(ResidentialBlockProvider residentialBlockData) async {
    setState(() {
      errorPasswordCredentialsText = "";
      isLoading = true;
    });
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      String email = emailController.text;
      String password = passwordController.text;

      bool isLoggedIn =
          await residentialBlockData.loginResidentialBlock(email, password);

      if (isLoggedIn) {
        await _saveLoginCredentials(email, password);
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamed(context, AppStrings.profilePageRoute);
      } else {
        setState(() {
          errorPasswordCredentialsText =
              "Contraseña mal introducida / Usuario no existe";
          isLoading = false;
        });
      }
    } else {
      _showEmptyCredentialsAlertDialog("Credenciales vacias",
          "Introduzca las credenciales que se piden, por favor.");
    }
  }

  _buildLoginButton(ResidentialBlockProvider residentialBlockData) {
    return (isLoading)
        ? Center(child: ProgressLoader())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: CustomElevatedButton(
              buttonText: "INICIAR SESIÓN",
              onPress: () async => await _doLoginAttempt(residentialBlockData),
            ));
  }

  _buildPasswordTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: TextFormField(
        controller: passwordController,
        cursorColor: Colors.black,
        obscureText: passwordHidden,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          labelText: "Password",
          errorStyle:
              TextStyle(color: AppColors.darkRed, fontWeight: FontWeight.bold),
          errorText: errorPasswordCredentialsText.isNotEmpty
              ? errorPasswordCredentialsText
              : null,
          errorBorder: _textFieldBorder(2.0, AppColors.darkRed),
          focusedErrorBorder: _textFieldBorder(3.0, AppColors.darkRed),
          enabledBorder: _textFieldBorder(2.0, Colors.black),
          focusedBorder: _textFieldBorder(3.0, Colors.black),
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye),
            color: Colors.black,
            onPressed: () {
              setState(() {
                passwordHidden = !passwordHidden;
              });
            },
          ),
        ),
      ),
    );
  }

  _buildEmailTextField() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        child: TextFormField(
          controller: emailController,
          cursorColor: Colors.black,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: Colors.black),
            labelText: "Email",
            focusColor: Colors.black,
            enabledBorder: _textFieldBorder(2.0, Colors.black),
            focusedBorder: _textFieldBorder(3.0, Colors.black),
          ),
        ));
  }

  _buildAppLogo() {
    return Center(
        child: Container(
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Image.asset('assets/app_logo.png', width: 156),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Mi Conjunto Guardas',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    ));
  }

  /// En caso de que los campos estén vacios, se le saltará una alerta de dialogo
  _showEmptyCredentialsAlertDialog(String title, String message) {
    return showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
              dialogTitle: title,
              dialogMessage: message,
            ),
        barrierDismissible: false);
  }

  _textFieldBorder(double borderWidth, Color borderColor) {
    return OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: borderWidth));
  }

  /// Guarda las credenciales del residente en el dispositivo móvil
  _saveLoginCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
    await prefs.setString("password", password);
  }
}
