import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/parking.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import 'package:mi_conjunto_guardas/provider_models/parking_provider.dart';
import 'package:mi_conjunto_guardas/route_arguments/parking_arguments.dart';
import 'package:mi_conjunto_guardas/route_arguments/resident_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/alert_dialog.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_appbar.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';
import 'package:provider/provider.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/resident_item.dart';
import '../../../constants/strings.dart' as AppStrings;

import '../../../utils/date_time_format.dart' as UtilsDateTimeFormat;

/// Página con datos del parqueadero actualmente activo de un residente
class ResidentParkingActivePage extends StatefulWidget {
  @override
  _ResidentParkingActivePageState createState() =>
      _ResidentParkingActivePageState();
}

class _ResidentParkingActivePageState extends State<ResidentParkingActivePage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final resident =
        (ModalRoute.of(context).settings.arguments as ResidentArguments)
            .resident;
    final _parkingData = context.watch<ParkingProvider>();
    return Scaffold(
      appBar: CustomAppBar(
          appBarTitle: "Parqueadero existente",
          onTap: () {
            Navigator.pop(context);
          }),
      body: (isLoading)
          ? Center(
              child: ProgressLoader(),
            )
          : FutureBuilder<Parking>(
              future: _parkingData.fetchParking(resident.residentId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: ProgressLoader(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error cargado datos del parqueadero"),
                  );
                }

                return (isLoading)
                    ? Center(
                        child: ProgressLoader(),
                      )
                    : _buildParkingActiveBody(
                        _parkingData, resident, snapshot.data);
              }),
    );
  }

  _buildParkingActiveBody(ParkingProvider parkingData,
      Resident residentWithActiveParking, Parking activeParking) {
    return ListView(
      children: [
        ResidentItem(residentWithActiveParking, null),
        _buildParkingSubItem(
            "Ingreso",
            UtilsDateTimeFormat.formatDate(
                "y-MM-d - HH:mm:ss", activeParking.entryDate)),
        _buildParkingSubItem("Nº Parqueado", '${activeParking.nParking ?? ""}'),
        _buildParkingSubItem("Placa vehículo", activeParking.numberPlate ?? ""),
        if (activeParking.notes != null)
          _buildParkingSubItem("Observaciones", activeParking.notes ?? ""),
        SizedBox(
          height: 25,
        ),
        _confirmParkingExitButton(
            parkingData, activeParking, residentWithActiveParking)
      ],
    );
  }

  _buildParkingSubItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$content',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  _confirmParkingExitButton(
      ParkingProvider parkingData, Parking parkingToUpdate, Resident resident) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 75),
      child: ElevatedButton(
          onPressed: () async =>
              await _updateParking(parkingData, parkingToUpdate, resident),
          child: Text(
            "CONFIRMAR SALIDA",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
    );
  }

  /// Actualiza el estado del parqueado
  _updateParking(ParkingProvider parkingData, Parking parkingToUpdate,
      Resident residentToUpdate) async {
    setState(() {
      isLoading = true;
    });
    Parking parking =
        await parkingData.updateParking(parkingToUpdate.parkingId);

    if (parking != null) {
      Navigator.pushNamed(context, AppStrings.residentParkingExitRoute,
          arguments: [
            ResidentArguments(resident: residentToUpdate),
            ParkingArguments(parking: parking)
          ]);
    } else {
      _showUpdatingParkingErrorAlertDialog("Error",
          "Error a la hora de procesar la salida. Por favor, inténtelo de nuevo más tarde");
    }
  }

  /// Muestra un dialogo de error en caso de que ocurre algún fallo a la hora de actualizar el estado del parqueado
  _showUpdatingParkingErrorAlertDialog(String title, String message) {
    return showDialog(
        context: context,
        builder: (context) =>
            CustomAlertDialog(dialogTitle: title, dialogMessage: message),
        barrierDismissible: false);
  }
}
