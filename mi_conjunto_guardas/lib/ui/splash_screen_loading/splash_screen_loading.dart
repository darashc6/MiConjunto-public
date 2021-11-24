import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/constants/colors.dart' as AppColors;
import 'package:mi_conjunto_guardas/provider_models/residential_block_provider.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';
import 'package:mi_conjunto_guardas/ui/login/login.dart';
import 'package:mi_conjunto_guardas/ui/profile/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';

/// Página de carga después del splash screen
/// Para comprobar las credenciales del conjunto logueado
class SplashScreenLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _residentialBlockData = context.watch<ResidentialBlockProvider>();
    return Container(
      color: AppColors.themeBlack,
      child: Center(
        child: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: 250),
                () => _checkLoginCredentials(_residentialBlockData)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ProgressLoader(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              return snapshot.data;
            }),
      ),
    );
  }

  /// Comprueba las credenciales del conjunto logueado
  /// Si las credenciales existen y son correctas, se le redirigirá a la página de su perfil
  /// Si no, se le redirigirña a la página de login
  Future<Widget> _checkLoginCredentials(
      ResidentialBlockProvider residentialBlockData) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("email") && prefs.containsKey("password")) {
      String email = prefs.getString("email");
      String password = prefs.getString("password");

      bool isLoggedIn =
          await residentialBlockData.loginResidentialBlock(email, password);
      if (isLoggedIn) {
        return ProfilePage();
      }
    }

    return LoginPage();
  }
}
