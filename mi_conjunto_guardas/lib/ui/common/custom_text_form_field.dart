import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/colors.dart' as AppColors;

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {@required this.labelText,
      @required this.controller,
      this.minLines,
      @required this.keyboardType});

  final String labelText;
  final TextEditingController controller;
  final int minLines;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: TextFormField(
          minLines: minLines ?? 1,
          maxLines: null,
          controller: controller,
          cursorColor: AppColors.skyBlue,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelStyle: TextStyle(color: AppColors.skyBlue),
            labelText: labelText,
            focusColor: AppColors.skyBlue,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.skyBlue, width: 2.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.skyBlue, width: 3.0)),
          ),
        ));
  }
}
