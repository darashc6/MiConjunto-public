import 'package:flutter/material.dart';
import 'package:mi_conjunto_residentes/arguments/parking_arguments.dart';
import 'package:mi_conjunto_residentes/models/parking.dart';
import 'package:mi_conjunto_residentes/ui/common/custom_app_bar.dart';
import '../../utils/date_time_format.dart' as UtilsDateTimeFormat;

/// Página mostrando detalles sobre un parqueado anterior.
class ParkingInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Parking parking =
        (ModalRoute.of(context).settings.arguments as ParkingArguments).parking;

    return Scaffold(
      appBar: CustomAppBar(
          title: "Parqueados",
          onBackPress: () {
            Navigator.pop(context);
          }),
      body: ListView(
        children: [
          _buildParkingSubItem(
              "Ingreso",
              UtilsDateTimeFormat.formatDate(
                  "y-MM-d - HH:mm:ss", parking.entryDate)),
          _buildParkingSubItem(
              "Salida",
              UtilsDateTimeFormat.formatDate(
                  "y-MM-d - HH:mm:ss", parking.exitDate)),
          _buildParkingSubItem(
              "Tiempo permanencia",
              UtilsDateTimeFormat.timeDifference(
                  parking.entryDate, parking.exitDate)),
          _buildParkingSubItem("Tarifa", '${parking.chargingRate}\$'),
          _buildParkingSubItem("Nº Parqueado", '${parking.nParking}'),
          _buildParkingSubItem("Placa vehículo", parking.numberPlate),
          if (parking.notes != null)
            _buildParkingSubItem("Observaciones", parking.notes),
        ],
      ),
    );
  }

  Widget _buildParkingSubItem(String title, String content) {
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
}
