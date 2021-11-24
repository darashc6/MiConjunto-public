import 'package:flutter/material.dart';
import '../../constants/colors.dart' as AppColors;

/// Menu personalizado para mostrar las diferentes empresas/empresas de servicios públicos
class DropdownMenu extends StatelessWidget {
  DropdownMenu({this.dropdownItems, this.onValueChange});

  final List<dynamic> dropdownItems;
  final Function onValueChange;

  String dropdownValue = "1";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonFormField(
        style: TextStyle(
            color: AppColors.skyBlue,
            fontSize: 16,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.transparent))),
        value: dropdownValue,
        items: _getDropDownMenuItems(dropdownItems),
        onChanged: onValueChange,
      ),
    );
  }

  List<DropdownMenuItem> _getDropDownMenuItems(List<dynamic> items) {
    List<DropdownMenuItem> dropdownMenuItems = [];

    items.forEach((item) {
      dropdownMenuItems.add(DropdownMenuItem(
          value: '${item["companyId"] ?? item["publicCompanyId"]}',
          child: Text('${item["name"]}')));
    });

    return dropdownMenuItems;
  }
}
