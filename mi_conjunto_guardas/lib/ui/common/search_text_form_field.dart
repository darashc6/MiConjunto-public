import 'package:flutter/material.dart';
import '../../constants/colors.dart' as AppColors;

/// Campo de texto personalizado
class SearchTextFormField extends StatelessWidget {
  SearchTextFormField(
      this.labelText, this.leadingIconAsset, this.controller, this.onTextChange,
      {this.width, this.keyboardType});

  final double width;
  final TextInputType keyboardType;
  final String labelText;
  final String leadingIconAsset;
  final TextEditingController controller;
  final Function onTextChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Container(
        color: AppColors.gray,
        width: width ?? MediaQuery.of(context).size.width / 2.25,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      leadingIconAsset,
                      width: 36,
                    ),
                  )),
              Flexible(
                flex: 3,
                child: TextFormField(
                  keyboardType: keyboardType ?? TextInputType.number,
                  controller: controller,
                  onChanged: onTextChange,
                  decoration: InputDecoration(
                      fillColor: AppColors.gray,
                      filled: true,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.gray)),
                      labelText: labelText,
                      labelStyle: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
