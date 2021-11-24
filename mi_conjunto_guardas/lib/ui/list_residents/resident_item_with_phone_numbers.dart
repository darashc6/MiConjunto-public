import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import 'package:mi_conjunto_guardas/route_arguments/resident_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_elevated_button.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/strings.dart' as AppStrings;

/// Instancia de un residente (para mostrar los diferentes números de móvil)
class ResidentItemWithPhoneNumbers extends StatelessWidget {
  ResidentItemWithPhoneNumbers(this.resident);

  final Resident resident;
  final TextStyle infoTextStyle =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Card(
          elevation: 5,
          child: ExpansionTile(
              trailing: Column(),
              title: Row(
                children: [
                  _buildResidentAvatar(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildResidentInfoText(
                          '${AppStrings.towerString}: ${resident.tower}'),
                      _buildResidentInfoText(
                          "${AppStrings.apartmentString}: ${resident.apartment}"),
                      _buildResidentInfoText(resident.ownerName),
                    ],
                  )
                ],
              ),
              children: [
                _buildResidentPhoneNumbersBody(),
                _buildSendMessageButton(context),
              ]),
        ));
  }

  Padding _buildResidentAvatar() {
    return Padding(
                  padding: const EdgeInsets.fromLTRB(5, 15, 30, 15),
                  child: Image.asset("assets/resident_avatar.png", width: 70),
                );
  }

  _buildSendMessageButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: CustomElevatedButton(
          onPress: () {
            Navigator.pushNamed(context, AppStrings.newMessagePage,
                arguments: ResidentArguments(resident: resident));
          },
          buttonText: "ENVIAR MENSAJE",
        ));
  }

  _buildResidentPhoneNumbersBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (resident.phoneNumber1 != null && resident.phoneNumber1 != '')
            _callResidentWithPhoneNumber(resident.phoneNumber1),
          if (resident.phoneNumber2 != null && resident.phoneNumber2 != '')
            _callResidentWithPhoneNumber(resident.phoneNumber2),
          if (resident.phoneNumber3 != null && resident.phoneNumber3 != '')
            _callResidentWithPhoneNumber(resident.phoneNumber3)
        ],
      ),
    );
  }

  _buildResidentInfoText(String text) {
    return Text(
      text,
      style: infoTextStyle,
    );
  }

  _callResidentWithPhoneNumber(String phoneNumber) {
    return GestureDetector(
      onTap: () async {
        await launch('tel:$phoneNumber');
      },
      child: Image.asset(
        "assets/phone_call_icon.png",
        width: 50,
      ),
    );
  }
}
