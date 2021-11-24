import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_conjunto_guardas/models/receipt.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import '../constants/strings.dart' as AppStrings;

class ReceiptProvider extends ChangeNotifier {
  ReceiptProvider();

  final String _serverReceiptsGet = "/receipts";
  final String _serverReceiptsAdd = "/receipts/new";
  final String _serverReceiptsUpdate = "/update";
  final String _serverReceiptsPendingResidents = "/receipts/pending/residents";

  /// Devuelve todas los recibos de un residente.
  /// 'residentId' -> Obligatorio. Es lo que filtra los recibos por cada residente
  /// 'showPendingOnly' -> Opcional. Se usa en caso de que solo queramos ver los recibos pendientes
  Future<List<Receipt>> fetchReceipts(
      int residentId, bool showPendingOnly) async {
    try {
      Map<String, dynamic> queryParams = {
        'residentId': residentId.toString(),
        'showPendingOnly': showPendingOnly.toString()
      };
      List<Receipt> _receiptsList = [];

      Uri uriGetPendingPackages =
          Uri.http(AppStrings.serverUrl, _serverReceiptsGet, queryParams);

      var response = await http.get(uriGetPendingPackages,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw "Error fetching resident receipts";
      }

      (jsonDecode(utf8.decode(response.bodyBytes))
              as List<dynamic>)
          .forEach((element) {
        _receiptsList.add(Receipt.fromJson(element as Map<String, dynamic>));
      });
      return _receiptsList;
    } catch (error) {
      print(error);
      return [];
    }
  }

  /// Muestra aquellos residentes que tienes alguno(s) recibos(s) pendiente
  /// 'residentialBlockId' -> Obligatorio. Para filtrar los residentes por cada conjunto residencial
  Future<List<Resident>> fetchResidentsWithPendingReceipts(
      int residentialBlockId) async {
    try {
      Map<String, dynamic> queryParams = {
        'residentialBlockId': residentialBlockId.toString()
      };
      List<Resident> _residentsWithPendingReceipts = [];

      Uri uriResidentsWithPendingPackages = Uri.http(
          AppStrings.serverUrl, _serverReceiptsPendingResidents, queryParams);

      var response = await http.get(uriResidentsWithPendingPackages,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw "Error fetching residents with pending receipts";
      }

      (jsonDecode(utf8.decode(response.bodyBytes))
              as List<dynamic>)
          .forEach((element) {
        _residentsWithPendingReceipts
            .add(Resident.fromJson(element["Resident"] as Map<String, dynamic>));
      });

      return _residentsWithPendingReceipts;
    } catch (error) {
      print(error);
      return [];
    }
  }

  /// Añade un nuevo recibo.
  /// 'residentId' -> Obligatorio. ID del residente al que va dirigido el nuevo recibo
  /// 'publicCompanyId' -> Obligatorio. ID de la empresa se servicio público.
  /// 'notes' -> Opcional. Observaciones del recibo
  Future<bool> addReceipt(int residentId, int companyId, String notes) async {
    try {
      Map<String, dynamic> newReceiptBody = {
        'residentId': residentId,
        'publicCompanyId': companyId
      };
      if (notes.isNotEmpty) newReceiptBody['notes'] = notes;

      Uri uriNewReceipt = Uri.http(AppStrings.serverUrl, _serverReceiptsAdd);

      var response = await http.post(uriNewReceipt,
          body: jsonEncode(newReceiptBody),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw "Error adding new receipt";
      }

      return true;
    } catch (error) {
      return false;
    }
  }

  /// Actualiza el recibo. Para confirmar la entrega del recibo al residente.
  /// 'receiptId' -> Obligatorio. ID del recibo a actualizar
  Future<bool> updatePackage(int receiptId) async {
    try {
      Uri uriGetPendingPackages = Uri.http(
          AppStrings.serverUrl, '/receipts/$receiptId$_serverReceiptsUpdate');

      var response = await http.patch(uriGetPendingPackages,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw "Error updating receipt";
      }

      return true;
    } catch (error) {
      return false;
    }
  }
}
