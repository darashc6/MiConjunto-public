import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import 'package:mi_conjunto_guardas/provider_models/parking_provider.dart';
import 'package:mi_conjunto_guardas/route_arguments/resident_arguments.dart';
import 'package:mi_conjunto_guardas/route_arguments/success_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/alert_dialog.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_appbar.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_elevated_button.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_text_form_field.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';

import 'package:provider/provider.dart';
import '../../../../constants/strings.dart' as AppStrings;
import '../../resident_item.dart';

/// Página para añadir más información sobre el nuevo parqueadero (nº matricula, placa vehículo)
class NewParkingInfoPage extends StatefulWidget {
  @override
  _NewParkingInfoPageState createState() => _NewParkingInfoPageState();
}

class _NewParkingInfoPageState extends State<NewParkingInfoPage> {
  bool isAdding = false;
  final nParkingController = TextEditingController();
  final numberPlateController = TextEditingController();
  final observationNotesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Resident resident =
        (ModalRoute.of(context).settings.arguments as ResidentArguments)
            .resident;
    final _parkingData = context.watch<ParkingProvider>();

    return Scaffold(
      appBar: CustomAppBar(
          appBarTitle: "Nuevo parqueadero",
          onTap: () {
            Navigator.pop(context);
          }),
      body: ListView(
        children: [
          ResidentItem(resident, null),
          CustomTextFormField(
              labelText: "N* Parqueado*",
              controller: nParkingController,
              keyboardType: TextInputType.number),
          CustomTextFormField(
              labelText: "Placa Vehículo*",
              controller: numberPlateController,
              keyboardType: TextInputType.text),
          CustomTextFormField(
            labelText: "Observaciones",
            controller: observationNotesController,
            keyboardType: TextInputType.text,
            minLines: 4,
          ),
          SizedBox(height: 25),
          _addParkingButton(resident, _parkingData)
        ],
      ),
    );
  }

  /// Muestra una alerta de dialogo en caso de error.
  _showNewParkingErrorAlertDialog(String title, String message) {
    return showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
              dialogTitle: title,
              dialogMessage: message,
            ),
        barrierDismissible: false);
  }

  _addParkingButton(Resident resident, ParkingProvider parkingData) {
    return (isAdding)
        ? Center(
            child: ProgressLoader(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: CustomElevatedButton(
                onPress: () async => await _addParking(resident, parkingData),
                buttonText: "ASIGNAR"),
          );
  }

  /// Añade un nuevo parqueado
  _addParking(
      Resident residentWithNewParking, ParkingProvider parkingData) async {
    if (nParkingController.text.isNotEmpty &&
        numberPlateController.text.isNotEmpty) {
      setState(() {
        isAdding = true;
      });
      Map<String, String> parkingBody = {
        "nParking": nParkingController.text,
        "numberPlate": numberPlateController.text,
        "residentId": residentWithNewParking.residentId.toString()
      };
      if (observationNotesController.text.isNotEmpty)
        parkingBody["notes"] = observationNotesController.text;

      bool isParkingAdded = await parkingData.addParking(parkingBody);

      if (isParkingAdded) {
        setState(() {
          isAdding = false;
          Navigator.pushNamed(context, AppStrings.successPageRoute,
              arguments: SuccessArguments(
                  successMessage: "¡Parqueadero asignado!",
                  nextRoute: AppStrings.parkingMainPageRoute));
        });
      } else {
        setState(() {
          isAdding = false;
          _showNewParkingErrorAlertDialog("Error",
              "Error al asignar un nuevo parqueadero. Por favor, inténtelo de nuevo más tarde.");
        });
      }
    } else {
      _showNewParkingErrorAlertDialog("Campos vacíos",
          "Por favor, rellene aquellos campos que son obligatorios (Nº Parqueado, Placa Vehículos)");
    }
  }
}
