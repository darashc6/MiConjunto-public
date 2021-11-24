import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_conjunto_residentes/ui/common/progress_loader.dart';
import '../../constants/colors.dart' as AppColors;
import '../../constants/strings.dart' as AppStrings;

import 'package:provider/provider.dart';
import 'package:mi_conjunto_residentes/provider/resident_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Página de login de residente
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordHidden = true;
  bool isLoading = false;
  String errorPasswordCredentialsText = "";

  @override
  Widget build(BuildContext context) {
    final _residentData = context.watch<ResidentProvider>();

    return Scaffold(
        body: ListView(children: [
      _buildAppLogo(),
      SizedBox(
        height: 100,
      ),
      _buildEmailTextFormField(),
      _buildPasswordTextFormField(),
      SizedBox(
        height: 20,
      ),
      _buildLoginButton(_residentData),
    ]));
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
              'Mi Conjunto Residentes',
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

  _buildPasswordTextFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: TextFormField(
        controller: passwordController,
        cursorColor: AppColors.themeOrange,
        obscureText: passwordHidden,
        decoration: InputDecoration(
          labelStyle: TextStyle(color: AppColors.themeOrange),
          labelText: "Password",
          errorStyle:
              TextStyle(color: AppColors.darkRed, fontWeight: FontWeight.bold),
          errorText: errorPasswordCredentialsText.isNotEmpty
              ? errorPasswordCredentialsText
              : null,
          errorBorder: _textFieldBorder(2.0, AppColors.darkRed),
          focusedErrorBorder: _textFieldBorder(3.0, AppColors.darkRed),
          enabledBorder: _textFieldBorder(2.0, AppColors.themeOrange),
          focusedBorder: _textFieldBorder(3.0, AppColors.themeOrange),
          suffixIcon: IconButton(
            icon: Icon(Icons.remove_red_eye),
            color: AppColors.themeOrange,
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

  _buildEmailTextFormField() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        child: TextFormField(
          controller: emailController,
          cursorColor: AppColors.themeOrange,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: AppColors.themeOrange),
            labelText: "Email",
            focusColor: AppColors.themeOrange,
            enabledBorder: _textFieldBorder(2.0, AppColors.themeOrange),
            focusedBorder: _textFieldBorder(3.0, AppColors.themeOrange),
          ),
        ));
  }

  _buildLoginButton(ResidentProvider residentData) {
    return (!isLoading)
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: ElevatedButton(
                onPressed: () async => _doLoginAttempt(residentData),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => AppColors.themeOrange)),
                child: Text("INICIAR SESIÓN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white))),
          )
        : Center(child: ProgressLoader());
  }

  _doLoginAttempt(ResidentProvider residentData) async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      setState(() {
        errorPasswordCredentialsText = "";
        isLoading = true;
      });

      String email = emailController.text;
      String password = passwordController.text;
      bool isLoginCorrect = await residentData.loginResident(email, password);

      if (isLoginCorrect) {
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

  /// En caso de que los campos estén vacios, se le saltará una alerta de dialogo
  _showEmptyCredentialsAlertDialog(String title, String description) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title:
                    Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                content: Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))
                ]),
        barrierDismissible: false);
  }

  _textFieldBorder(double borderWidth, Color borderColor) {
    return OutlineInputBorder(
        borderSide: BorderSide(color: borderColor, width: borderWidth));
  }

  /// Guarda las credenciales del residente en el dispositivo móvil
  _saveLoginCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("email", email);
    prefs.setString("password", password);
  }
}
