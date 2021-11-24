import 'package:flutter/material.dart';
import '../../constants/colors.dart' as AppColors;

/// Cargador personalizado
class ProgressLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: AppColors.backgroundColor,
      valueColor: AlwaysStoppedAnimation<Color>(AppColors.themeOrange),
    );
  }
}