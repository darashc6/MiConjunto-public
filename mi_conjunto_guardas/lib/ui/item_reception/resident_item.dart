import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import '../../constants/strings.dart' as AppStrings;

/// Instancia de un residente (sin sus números de móvil)
class ResidentItem extends StatelessWidget {
  ResidentItem(this.resident, this.onPress);

  final Resident resident;
  final Function onPress;
  final TextStyle infoTextStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: GestureDetector(
        onTap: onPress,
        child: Card(
            elevation: 5,
            child: Row(
              children: [
                _buildResidentAvatar(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildResidentInfoText(
                        '${AppStrings.towerString}: ${resident.tower}'),
                    _buildResidentInfoText(
                        '${AppStrings.apartmentString}: ${resident.apartment}'),
                    _buildResidentInfoText(resident.ownerName),
                  ],
                )
              ],
            )),
      ),
    );
  }

  _buildResidentAvatar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 30, 15),
      child: Image.asset("assets/resident_avatar.png", width: 70),
    );
  }

  _buildResidentInfoText(String text) {
    return Text(
      text,
      style: infoTextStyle,
    );
  }
}
