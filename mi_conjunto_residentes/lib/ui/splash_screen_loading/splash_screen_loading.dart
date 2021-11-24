import 'package:flutter/material.dart';
import 'package:mi_conjunto_residentes/provider/resident_provider.dart';
import 'package:mi_conjunto_residentes/ui/common/progress_loader.dart';
import 'package:mi_conjunto_residentes/ui/login/login.dart';
import 'package:mi_conjunto_residentes/ui/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/colors.dart' as AppColors;
import 'package:firebase_core/firebase_core.dart';

import 'package:provider/provider.dart';

/// Página de carga después del splash screen
/// Para comprobar las credenciales del usuario logueado
class SplashScreenLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _residentData = context.watch<ResidentProvider>();
    return Container(
        color: AppColors.themeOrange,
        child: FutureBuilder<Widget>(
            future: Future.delayed(Duration(milliseconds: 250), () async {
              await Firebase.initializeApp();
              return await _checkLoginCredentials(_residentData);
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ProgressLoader()
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              return snapshot.data;
            }));
  }

  /// Comprueba las credenciales del usuario logueado
  /// Si las credenciales existen y son correctas, se le redirigirá a la página de su perfil
  /// Si no, se le redirigirña a la página de login
  Future<Widget> _checkLoginCredentials(ResidentProvider residentData) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("email") && prefs.containsKey("password")) {
      String email = prefs.getString("email");
      String password = prefs.getString("password");

      bool isLoggedIn = await residentData.loginResident(email, password);
      if (isLoggedIn) {
        return ProfilePage();
      }
    }

    return LoginPage();
  }
}
