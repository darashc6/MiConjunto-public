import 'dart:convert';
import 'dart:io';

import 'package:mi_conjunto_guardas/models/residential_block.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/strings.dart' as AppStrings;

class ResidentialBlockProvider extends ChangeNotifier {
  ResidentialBlockProvider();

  ResidentialBlock _residentialBlock = ResidentialBlock();
  ResidentialBlock get getResidentialBlock => _residentialBlock;

  final String _serverBlockLoginEndpoint = "/login";

  /// Login del conjunto residencial
  /// 'email' -> Obligatorio. Email del conjunto residencial
  /// 'password' -> Obligatorio. Contraseña del conjunto residencial
  Future<bool> loginResidentialBlock(String email, String password) async {
    try {
      Uri uriLogin =
          Uri.http(AppStrings.serverUrl, 'blocks$_serverBlockLoginEndpoint');

      var response = await http.post(uriLogin,
          body: jsonEncode({'email': email, 'password': password}),
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw "Error login ResidentialBlock";
      }

      Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
      if (json != null) {
        _residentialBlock = ResidentialBlock.fromJson(json);
        return true;
      }

      return false;
    } catch (error) {
      return false;
    }
  }
}
