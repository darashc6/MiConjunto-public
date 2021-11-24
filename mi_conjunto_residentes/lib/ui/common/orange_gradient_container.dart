import 'package:flutter/material.dart';
import '../../constants/colors.dart' as AppColors;

// Contenedor para aplicar los colores de la aplicación al AppBar
class OrangeGradientContainer extends StatelessWidget {
  const OrangeGradientContainer({this.height, this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.lightOrange, AppColors.darkOrange])),
    );
  }
}
