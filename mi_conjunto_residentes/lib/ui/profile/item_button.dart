import 'package:flutter/material.dart';
import '../../constants/colors.dart' as AppColors;

/// Botón personalizado para Recibo/Encomienda/Parqueado/Mensaje
class ItemButton extends StatelessWidget {
  ItemButton(
      {this.pending,
      @required this.onPress,
      @required this.linearColors,
      @required this.buttonName,
      @required this.assetButtonIcon});

  final String pending;
  final Function onPress;
  final List<Color> linearColors;
  final String buttonName;
  final String assetButtonIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
        child: GestureDetector(
          onTap: onPress,
          child: Container(
            margin: EdgeInsets.only(top: 10),
            height: 140.0,
            width: 140.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  colors: linearColors,
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight),
            ),
            child: Stack(children: [
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(assetButtonIcon),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        buttonName,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      )
                    ]),
              ),
              if (pending != null)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                          color: AppColors.pendingRed, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          '$pending',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
            ]),
          ),
        ));
  }
}
