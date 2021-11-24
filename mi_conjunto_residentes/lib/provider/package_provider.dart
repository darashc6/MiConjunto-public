import 'dart:convert';
import 'dart:io';
import 'package:mi_conjunto_residentes/models/package.dart';

import '../constants/strings.dart' as AppStrings;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PackageProvider extends ChangeNotifier {
  PackageProvider();

  final String _serverPackagesGet = "/packages";
  List<Package> _packagesReceived = [];
  List<Package> get getPackagesReceived => _packagesReceived;
  List<Package> _packagesPending = [];
  List<Package> get getPackagesPending => _packagesPending;

  /// Retorna las encomiendas de un residente
  /// 'residenteId' -> Obligatorio. ID del residente
  Future<void> fetchPackages(int residentId) async {
    try {
      _clearData();
      var queryParams = {'residentId': residentId.toString()};

      Uri uriData =
          Uri.http(AppStrings.serverUrl, _serverPackagesGet, queryParams);

      var response = await http.get(uriData,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        _splitPackages(json);
      }
    } catch (error) {
      print(error);
    }
  }

  /// Divide las encomiendas en listas diferentes
  /// Si la encomienda no tiene una fecha de entrega, significa que esta pendiente.
  void _splitPackages(List<dynamic> allPackages) {
    allPackages.forEach((package) {
      if (package['deliveryDate'] != null) {
        _packagesReceived.add(Package.fromJson(package));
      } else {
        _packagesPending.add(Package.fromJson(package));
      }
    });
  }

  /// Vacia las listas
  void _clearData() {
    _packagesPending.clear();
    _packagesReceived.clear();
  }
}
