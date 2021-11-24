import 'package:flutter/material.dart';
import 'package:mi_conjunto_residentes/models/parking.dart';
import '../../utils/date_time_format.dart' as UtilsDateTimeFormat;

/// Instancia de 'Parqueado'
class ParkingItem extends StatelessWidget {
  ParkingItem({this.parking});

  final Parking parking;
  final TextStyle _mainTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            _buildParkingItemText('Nº Parqueado: ${parking.nParking}'),
            _buildParkingItemText('Placa Vehículo: ${parking.numberPlate}'),
            _buildParkingItemText(
                'Fecha salida: ${UtilsDateTimeFormat.formatDate("y-MM-d - HH:mm:ss", parking.entryDate)}'),
            _buildParkingItemText('Tarifa: ${parking.chargingRate}\$'),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParkingItemText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: _mainTextStyle,
      ),
    );
  }
}
