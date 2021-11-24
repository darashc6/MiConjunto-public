import 'package:flutter/material.dart';
import 'package:mi_conjunto_residentes/arguments/message_arguments.dart';
import 'package:mi_conjunto_residentes/models/message.dart';
import 'package:mi_conjunto_residentes/ui/common/custom_app_bar.dart';
import '../../utils/date_time_format.dart' as UtilsDateTimeFormat;

/// Página con un mensaje específico
class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Message message =
        (ModalRoute.of(context).settings.arguments as MessageArguments).message;

    return Scaffold(
      appBar: CustomAppBar(
          title: "Mensaje",
          onBackPress: () {
            Navigator.pop(context);
          }),
      body: ListView(
        children: [
          _buildMessageSubItem("Asunto", message.subject),
          _buildMessageSubItem("Fecha",
              UtilsDateTimeFormat.formatDate("dd/MM/yyyy", message.dateSent)),
          _buildMessageSubItem("Mensaje", message.messageContent),
        ],
      ),
    );
  }

  Widget _buildMessageSubItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$content',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
