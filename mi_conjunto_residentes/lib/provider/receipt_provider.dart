import 'dart:convert';
import 'dart:io';
import 'package:mi_conjunto_residentes/models/receipt.dart';

import '../constants/strings.dart' as AppStrings;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReceiptProvider extends ChangeNotifier {
  ReceiptProvider();

  final String _serverReceiptsGet = "/receipts";
  List<Receipt> _receiptsReceived = [];
  List<Receipt> get getReceiptsReceived => _receiptsReceived;
  List<Receipt> _receiptsPending = [];
  List<Receipt> get getReceiptsPending => _receiptsPending;

  /// Retorna los recibos de un residente
  /// 'residenteId' -> Obligatorio. ID del residente
  Future<void> fetchReceipts(int residentId) async {
    try {
      _clearData();
      var queryParams = {'residentId': residentId.toString()};

      Uri uriReceipts =
          Uri.http(AppStrings.serverUrl, _serverReceiptsGet, queryParams);

      var response = await http.get(uriReceipts,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode == 200) {
        List<dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        _splitReceipts(json);
      }
    } catch (error) {
      print(error);
    }
  }

  /// Divide los recibos en listas diferentes
  /// Si el recibo no tiene una fecha de entrega, significa que esta pendiente.
  void _splitReceipts(List<dynamic> allReceipts) {
    allReceipts.forEach((receipt) {
      if (receipt['deliveryDate'] != null) {
        _receiptsReceived.add(Receipt.fromJson(receipt));
      } else {
        _receiptsPending.add(Receipt.fromJson(receipt));
      }
    });
  }

  /// Vacia las listas
  void _clearData() {
    _receiptsPending.clear();
    _receiptsReceived.clear();
  }
}
