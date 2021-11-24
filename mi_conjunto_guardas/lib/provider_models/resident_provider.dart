import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_conjunto_guardas/models/resident.dart';
import '../constants/strings.dart' as AppStrings;

class ResidentProvider extends ChangeNotifier {
  ResidentProvider();

  final String _serverResidentsGet = "/residents";

  /// Devuelve todos los residentes de un conjunto
  /// 'residentialBlockId' -> Obligatorio. ID del conjunto
  /// 'tower' -> Opcional. Interior/Torre. Principalmente usado para filtros de busqueda
  /// 'apartment' -> Opcional. Apartamento/Casa. Principalmente usado para filtros de busqueda
  /// 'ownerName' -> Opcional. Nombre del propietario. Principalmente usado para filtros de busqueda
  Future<List<Resident>> fetchResidents(
      int residentialBlockId, String tower, String apartment, String ownerName,
      {bool parkingActive}) async {
    try {
      Map<String, dynamic> queryParams = {
        'residentialBlockId': residentialBlockId.toString()
      };
      List<Resident> _listResidents = [];

      if (tower.isNotEmpty) queryParams["tower"] = tower;
      if (apartment.isNotEmpty) queryParams["apartment"] = apartment;
      if (ownerName.isNotEmpty) queryParams["ownerName"] = ownerName;
      if (parkingActive != null)
        queryParams["parkingActive"] = parkingActive.toString();

      Uri uriResidents =
          Uri.http(AppStrings.serverUrl, _serverResidentsGet, queryParams);

      var response = await http.get(uriResidents,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) throw 'Error fetching Block Residents';

      (jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>)
          .forEach((element) {
        _listResidents.add(Resident.fromJson(element as Map<String, dynamic>));
      });

      return _listResidents;
    } catch (error) {
      print(error);
      return [];
    }
  }
}
