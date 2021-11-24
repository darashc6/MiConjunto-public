import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_conjunto_guardas/models/parking.dart';
import '../constants/strings.dart' as AppStrings;

class ParkingProvider extends ChangeNotifier {
  ParkingProvider();

  final String _serverGetParking = "/control_parking";
  final String _serverAddParking = "/control_parking/new";
  final String _serverUpdateParking = "/update";

  /// Función para añadir un nuevo parqueamiento.
  /// 'nParking' -> Obligatorio. Nº del parqueamiento.
  /// 'numberPlate' -> Obligatorio. Placa del vehículo
  /// 'residentId' -> Obligatorio. ID del residente
  /// 'notes  -> Opcional. Observaciones acerca del parqueamiento
  Future<bool> addParking(Map<String, String> parkingBody) async {
    try {
      Uri uriAddParking = Uri.http(AppStrings.serverUrl, _serverAddParking);

      var response = await http.post(uriAddParking,
          body: jsonEncode(parkingBody),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) throw "Error adding new parking";

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  /// Devuelve datos del parqueamiento del residente indicado
  ///'residentId' -> Obligatorio. ID del residente. Para filtrar el parqueamiento
  Future<Parking> fetchParking(int residentId) async {
    try {
      Map<String, String> queryParams = {"residentId": residentId.toString()};

      Uri uriGetParking =
          Uri.http(AppStrings.serverUrl, _serverGetParking, queryParams);

      var response = await http.get(uriGetParking,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw "Error fetching parking";
      }

      return Parking.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// Actualiza el estado del parqueamiento.
  /// 'controlParkingId' -> Obligatorio. ID del parqueamiento a actualizar.
  Future<Parking> updateParking(int parkingId) async {
    try {
      Uri uriUpdateParking = Uri.http(AppStrings.serverUrl,
          '$_serverGetParking/$parkingId$_serverUpdateParking');

      var response = await http.patch(uriUpdateParking,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) throw "Error updating Parking.";

      return Parking.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } catch (error) {
      print(error);
      return null;
    }
  }
}
