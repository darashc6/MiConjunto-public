import 'package:flutter/material.dart';
import 'blue_gradient_container.dart';

/// AppBar personalizada
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {@required this.appBarTitle, @required this.onTap, this.trailingIcons});

  final String appBarTitle;
  final Function onTap;
  final List<Widget> trailingIcons;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        appBarTitle,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
      flexibleSpace: BlueGradientContainer(),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: onTap),
      actions: trailingIcons ?? trailingIcons,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(55);
}
