import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mi_conjunto_residentes/models/parking.dart';
import '../constants/strings.dart' as AppStrings;

class ParkingProvider extends ChangeNotifier {
  ParkingProvider();

  final String _serverParkingGet = "/control_parking";
  final String _serverParkingHistoryListGet = "/control_parking/history";

  /// Devuelve datos del parqueamiento del residente indicado
  /// 'residentId' -> Obligatorio. ID del residente. Para filtrar el parqueamiento
  Future<Parking> fetchParking(int residentId) async {
    try {
      var queryParams = {'residentId': residentId.toString()};

      Uri uriControlParking =
          Uri.http(AppStrings.serverUrl, _serverParkingGet, queryParams);

      var response = await http.get(uriControlParking,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw "Error fetching active parking data";
      }

      return Parking.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// Muestra el historial de todos los parqueamientos de un residente específico.
  /// 'residentId' -> Obligatorio. ID del residente. Para filtrar el historial
  Future<List<Parking>> fetchParkingHistoryList(int residentId) async {
    try {
      var queryParams = {'residentId': residentId.toString()};
      List<Parking> _listParking = [];

      Uri uriControlParking = Uri.http(
          AppStrings.serverUrl, _serverParkingHistoryListGet, queryParams);

      var response = await http.get(uriControlParking,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw "Error fetching active parking data";
      }

      (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>)
          .forEach((item) {
        _listParking.add(Parking.fromJson(item));
      });

      return _listParking;
    } catch (error) {
      print(error);
      return [];
    }
  }
}
