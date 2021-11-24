import 'package:flutter/material.dart';
import 'package:mi_conjunto_residentes/ui/common/orange_gradient_container.dart';

// AppBar personalizado
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {@required this.title,
      @required this.onBackPress,
      this.customTabs});

  final String title;
  final Function onBackPress;
  final List<Tab> customTabs;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: onBackPress),
        flexibleSpace: OrangeGradientContainer(),
        bottom: (customTabs != null)
            ? TabBar(tabs: customTabs, indicatorColor: Colors.black)
            : PreferredSize(
                child: Container(), preferredSize: Size.fromHeight(0)));
  }

  @override
  Size get preferredSize => Size(double.infinity,
      (customTabs != null) ? 90 : 55);
}
