import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/strings.dart' as AppStrings;

class MessageProvider extends ChangeNotifier {
  MessageProvider();

  final String _serverAddMessage = "/messages/new";

  /// Función para añadir un nuevo mensaje para un residente específico
  /// 'residentId' -> Obligatorio. ID del residente. Para determinar a que residente va dirigido el mensaje
  /// 'subject' -> Obligatorio. Asunto.
  /// 'message' -> Obligatorio. Contenido del mensaje
  Future<bool> addMessage(
      String subject, String messageContent, int residentId) async {
    try {
      Map<String, dynamic> messageBody = {
        "subject": subject,
        "message": messageContent,
        "residentId": residentId.toString()
      };

      Uri uriAddMessage = Uri.http(AppStrings.serverUrl, _serverAddMessage);

      var response = await http.post(uriAddMessage,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: jsonEncode(messageBody));

      if (response.statusCode != 200) throw "Error saving message";

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
