import 'package:flutter/material.dart';

/// Boton personalizado para acceder a las diferentes funciones de la aplicación
class CustomButton extends StatelessWidget {
  CustomButton(this.assetImage, this.buttonName, this.buttonColors, this.onTap);

  final String assetImage;
  final String buttonName;
  final List<Color> buttonColors;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: buttonColors)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25, right: 35, top: 10, bottom: 10),
                  child: Image.asset(
                    assetImage,
                    width: 40,
                  ),
                ),
                Text(
                  buttonName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
