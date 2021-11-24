import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_conjunto_residentes/models/message.dart';
import '../constants/strings.dart' as AppStrings;

class MessageProvider extends ChangeNotifier {
  MessageProvider();

  final String _serverGetMessages = "/messages";
  final String _serverUpdateMessage = "/update";
  List<Message> _messagesList = [];
  List<Message> get getMessages => _messagesList;

  /// Devuelve todos los mensajes de un residente
  /// 'residentId' -> Obligatorio. ID de residente. Utilizado para filtrar los mensajes
  Future<void> fetchMessages(int residentId) async {
    try {
      _messagesList.clear();
      Map<String, String> queryParams = {'residentId': residentId.toString()};

      Uri uriData =
          Uri.http(AppStrings.serverUrl, _serverGetMessages, queryParams);

      http.Response response = await http.get(uriData,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'});

      if (response.statusCode != 200) {
        throw "Error fetching resident messages";
      }

      List jsonMessageList =
          jsonDecode(utf8.decode(response.bodyBytes)) as List;

      jsonMessageList.forEach((message) {
        _messagesList.add(Message.fromJson(message));
      });
    } catch (error) {
      print(error);
    }
  }

  /// Actualiza el estado del mensaje. En concreto, convierte un mensaje de estado 'no leído', en estado 'leído'
  /// 'messageId' -> Obligatorio. ID del mensaje a actualizar.
  Future<bool> updateMessage(int messageId) async {
    try {
      Uri uriData = Uri.http(AppStrings.serverUrl,
          '$_serverGetMessages/$messageId$_serverUpdateMessage');

      http.Response response = await http.patch(uriData,
          headers: {HttpHeaders.contentTypeHeader: 'application/josn'});

      if (response.statusCode != 200) {
        throw "Error updating message";
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
