import 'package:flutter/material.dart';
import '../../constants/colors.dart' as AppColors;

/// Contenedor personalizado para aplicar al AppBar
class BlueGradientContainer extends StatelessWidget {
  const BlueGradientContainer({this.height, this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.lightBlack, AppColors.lightBlack])),
    );
  }
}
