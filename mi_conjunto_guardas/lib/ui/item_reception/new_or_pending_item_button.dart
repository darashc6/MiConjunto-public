import 'package:flutter/material.dart';
import '../../constants/colors.dart' as AppColors;

/// Botón personalizado para la recepción de una nueva encomienda/recibo
class NewOrPendingItemButton extends StatelessWidget {
  NewOrPendingItemButton(
      {@required this.buttonTitle,
      @required this.buttonDescription,
      @required this.onPress,
      this.nPending});

  final String buttonTitle;
  final String buttonDescription;
  final int nPending;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          width: double.infinity,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (nPending != null && nPending > 0)
                            _buildNumberItemsPendingText(),
                          Text(
                            buttonTitle,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward)
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                  ),
                  _buildButtonDescription(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildButtonDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          buttonDescription,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  _buildNumberItemsPendingText() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        height: 24,
        width: 24,
        decoration:
            BoxDecoration(color: AppColors.pendingRed, shape: BoxShape.circle),
        child: Center(
          child: Text(
            '$nPending',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
