import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'info_card.dart';
import '../common/blue_gradient_container.dart';
import 'custom_button.dart';
import '../../constants/colors.dart' as AppColors;
import '../../constants/strings.dart' as AppStrings;

/// Página de perfil del residente
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.qr_code, color: Colors.white, size: 25.0),
            onPressed: () {
              Navigator.pushNamed(context, AppStrings.qrReaderPageRoute);
            },
          ),
          centerTitle: true,
          title: Text(
            "Perfil de Conjunto",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
          ),
          flexibleSpace: BlueGradientContainer(),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 25.0,
                ),
                onPressed: () async {
                  await _clearLoginCredentials();
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppStrings.loginPageRoute, (route) => false);
                })
          ],
        ),
        body: _buildProfileBody(context),
      ),
    );
  }

  _buildProfileBody(BuildContext context) {
    return ListView(
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ProfileInfoCard()),
        SizedBox(
          height: 20,
        ),
        CustomButton(
            "assets/messages_icon.png", "Residentes", AppColors.gradientViolet,
            () {
          Navigator.pushNamed(context, AppStrings.residentsListPageRoute);
        }),
        CustomButton(
            "assets/packages_icon.png", "Encomiendas", AppColors.gradientBrown,
            () {
          Navigator.pushNamed(context, AppStrings.packageReceptionPageRoute);
        }),
        CustomButton(
            "assets/receipt_icon.png", "Recibos", AppColors.gradientGreen, () {
          Navigator.pushNamed(context, AppStrings.receiptReceptionPageRoute);
        }),
        CustomButton("assets/parking_icon.png", "Parqueaderos Visitantes",
            AppColors.gradientBlue, () {
          Navigator.pushNamed(context, AppStrings.parkingMainPageRoute);
        }),
      ],
    );
  }

  /// Quita las credenciales de login guardadas en el dispositivo
  /// Ejecutado cuando el conjunto hace log out de la aplicación
  _clearLoginCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("email");
    await prefs.remove("password");
  }
}
