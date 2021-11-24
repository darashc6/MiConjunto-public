import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/strings.dart' as AppStrings;

class QrReaderProvider extends ChangeNotifier {
  QrReaderProvider();

  final String _serverReadQr = "/qr_reader/read";

  /// Lee un código QR
  /// 'data' -> Obligatorio. Dato que lee del codigo QR
  Future<bool> readQr(String data) async {
    try {
      Map<String, dynamic> qrReaderBody = {"data": data};

      Uri uriReadQr = Uri.http(AppStrings.serverUrl, _serverReadQr);

      var response = await http.post(uriReadQr,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: jsonEncode(qrReaderBody));

      if (response.statusCode != 200) throw 'Error reading QR code';

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
