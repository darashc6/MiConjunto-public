import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_conjunto_residentes/models/resident.dart';
import '../constants/strings.dart' as AppStrings;

class ResidentProvider extends ChangeNotifier {
  ResidentProvider();

  final String _serverResidentLoginEndpoint = "/residents/login";
  final String _serverResidentSaveDeviceToken = "/save_token";

  Resident _resident = Resident();
  Resident get getResident => _resident;

  /// Login del residente, para acceder a la aplicación por completo
  /// 'email' -> Obligatorio. Email del residente
  /// 'pasword' -> Obligatorio. Contraseña del residente
  Future<bool> loginResident(String email, String password) async {
    try {
      Uri uriLogin =
          Uri.http(AppStrings.serverUrl, _serverResidentLoginEndpoint);

      var response = await http.post(uriLogin,
          body: jsonEncode({'email': email, 'password': password}),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw 'Error login Resident.';
      }

      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      if (json != null) {
        _resident = Resident.fromJson(json);
        return true;
      }

      return false;
    } catch (error) {
      print(error);
      return false;
    }
  }

  /// Guarda el token de dispositivo del residente, para luego ser notificados
  /// El token es diferente para cada dispositivo.
  Future<void> saveDeviceToken(int residentId, String deviceToken) async {
    try {
      var jsonBody = {'deviceToken': deviceToken};

      Uri uriSaveDeviceToken = Uri.http(AppStrings.serverUrl,
          '/residents/$residentId$_serverResidentSaveDeviceToken');

      var response = await http.patch(uriSaveDeviceToken,
          body: jsonEncode(jsonBody),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw 'Error saving device token';
      }

      _resident =
          Resident.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } catch (error) {
      print(error);
    }
  }
}
