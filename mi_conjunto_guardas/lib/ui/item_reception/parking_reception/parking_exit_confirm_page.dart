import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/parking.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import 'package:mi_conjunto_guardas/route_arguments/parking_arguments.dart';
import 'package:mi_conjunto_guardas/route_arguments/resident_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_appbar.dart';

import '../../../utils/date_time_format.dart' as UtilsDateTimeFormat;
import '../resident_item.dart';
import '../../../constants/strings.dart' as AppStrings;

/// Página mostrando datos de la salida del parqueado
class ParkingExitConfirmedPage extends StatefulWidget {
  @override
  _ParkingExitConfirmedPageState createState() =>
      _ParkingExitConfirmedPageState();
}

class _ParkingExitConfirmedPageState extends State<ParkingExitConfirmedPage> {
  @override
  Widget build(BuildContext context) {
    final List<Object> args = ModalRoute.of(context).settings.arguments;

    return WillPopScope(
      onWillPop: () => _returnToParkingMainPaige(),
      child: Scaffold(
        appBar: CustomAppBar(
            appBarTitle: "Parqueado salida",
            onTap: () => _returnToParkingMainPaige()),
        body: _buildParkingExitConfirmedBody(
            (args[0] as ResidentArguments).resident,
            (args[1] as ParkingArguments).parking),
      ),
    );
  }

  _buildParkingExitConfirmedBody(
      Resident residentWithExitParking, Parking exitParking) {
    return ListView(
      children: [
        ResidentItem(residentWithExitParking, null),
        _buildParkingSubItem(
            "Ingreso",
            UtilsDateTimeFormat.formatDate(
                "y-MM-d - HH:mm:ss", exitParking.entryDate)),
        _buildParkingSubItem(
            "Salida",
            UtilsDateTimeFormat.formatDate(
                "y-MM-d - HH:mm:ss", exitParking.exitDate)),
        _buildParkingSubItem(
            "Tiempo permanencia",
            UtilsDateTimeFormat.timeDifference(
                exitParking.entryDate, exitParking.exitDate)),
        _buildParkingSubItem("Tarifa", '${exitParking.chargingRate}\$'),
        _buildParkingSubItem("Nº Parqueado", '${exitParking.nParking}'),
        _buildParkingSubItem("Placa vehículo", exitParking.numberPlate),
        if (exitParking.notes != null)
          _buildParkingSubItem("Observaciones", exitParking.notes),
        _returnToParkingMainPageButton()
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

  _returnToParkingMainPageButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 15),
      child: ElevatedButton(
          onPressed: () => _returnToParkingMainPaige(),
          child: Text(
            "VOLVER",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          )),
    );
  }

  _returnToParkingMainPaige() {
    Navigator.pushNamed(context, AppStrings.parkingMainPageRoute);
  }
}
