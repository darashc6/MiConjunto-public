import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_conjunto_guardas/models/package.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import '../constants/strings.dart' as AppStrings;

class PackageProvider extends ChangeNotifier {
  PackageProvider();

  final String _serverPackagesGet = "/packages";
  final String _serverPackagesAdd = "/packages/new";
  final String _serverPackagesUpdate = "/update";
  final String _serverPackagesPendingResidents = "/packages/pending/residents";

  /// Añade una nueva encomienda.
  /// 'residentId' -> Obligatorio. ID del residente al que va dirigido la nueva encomienda
  /// 'companyId' -> Obligatorio. ID de la empresa.
  /// 'notes' -> Opcional. Observaciones de la encomienda
  Future<bool> addPackage(int residentId, int companyId, String notes) async {
    try {
      Map<String, dynamic> newPackageBody = {
        'residentId': residentId,
        'companyId': companyId
      };
      if (notes.isNotEmpty) newPackageBody['notes'] = notes;

      Uri uriNewPackage = Uri.http(AppStrings.serverUrl, _serverPackagesAdd);

      var response = await http.post(uriNewPackage,
          body: jsonEncode(newPackageBody),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) throw "Error adding new package";

      return true;
    } catch (error) {
      return false;
    }
  }

  /// Devuelve todas las encomiendas de un residente.
  /// 'residentId' -> Obligatorio. Es lo que filtra las encomiendas por cada residente
  /// 'showPendingOnly' -> Opcional. Se usa en caso de que solo queramos ver las encomiendas pendientes
  Future<List<Package>> fetchPackages(
      int residentId, bool showPendingOnly) async {
    try {
      Map<String, dynamic> queryParams = {
        'residentId': residentId.toString(),
        'showPendingOnly': showPendingOnly.toString()
      };
      List<Package> _packagesList = [];

      Uri uriGetPendingPackages =
          Uri.http(AppStrings.serverUrl, _serverPackagesGet, queryParams);

      var response = await http.get(uriGetPendingPackages,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw "Error fetching resident packages";
      }

      (jsonDecode(utf8.decode(response.bodyBytes))
              as List<dynamic>)
          .forEach((element) {
        _packagesList.add(Package.fromJson(element as Map<String, dynamic>));
      });
      return _packagesList;
    } catch (error) {
      print(error);
      return [];
    }
  }

  /// Muestra aquellos residentes que tienes alguna(s) encomienda(s) pendiente
  /// 'residentialBlockId' -> Obligatorio. Para filtrar los residentes por cada conjunto residencial
  Future<List<Resident>> fetchResidentsWithPendingPackages(
      int residentialBlockId) async {
    try {
      List<Resident> _residentsWithPendingPackages = [];

      var queryParams = {'residentialBlockId': residentialBlockId.toString()};
      Uri uriResidentsWithPendingPackages = Uri.http(
          AppStrings.serverUrl, _serverPackagesPendingResidents, queryParams);

      var response = await http.get(uriResidentsWithPendingPackages,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw "Error fetching residents with pending packages";
      }

      (jsonDecode(utf8.decode(response.bodyBytes))
              as List<dynamic>)
          .forEach((element) {
        _residentsWithPendingPackages
            .add(Resident.fromJson(element["Resident"] as Map<String, dynamic>));
      });
      return _residentsWithPendingPackages;
    } catch (error) {
      print(error);
      return [];
    }
  }

  /// Actualiza la encomienda. Para confirmar la entrega de la encomienda al residente.
  /// 'packageId' -> Obligatorio. ID de la encomienda a actualizar
  Future<bool> updatePackage(int packageId) async {
    try {
      Uri uriUpdatePackage = Uri.http(
          AppStrings.serverUrl, '/packages/$packageId$_serverPackagesUpdate');

      var response = await http.patch(uriUpdatePackage,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw "Package does not exist";
      }

      return true;
    } catch (error) {
      return false;
    }
  }
}
