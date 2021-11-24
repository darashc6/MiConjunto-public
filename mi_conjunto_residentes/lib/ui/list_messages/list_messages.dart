import 'package:flutter/material.dart';
import 'package:mi_conjunto_residentes/arguments/list_arguments.dart';
import 'package:mi_conjunto_residentes/arguments/message_arguments.dart';
import 'package:mi_conjunto_residentes/models/message.dart';
import 'package:mi_conjunto_residentes/provider/message_provider.dart';
import 'package:mi_conjunto_residentes/ui/common/custom_app_bar.dart';
import 'package:provider/provider.dart';
import '../../constants/strings.dart' as AppStrings;
import '../../utils/date_time_format.dart' as UtilsDateTimeFormat;

/// Página con una lista de mensajes del residente
class MessagesListPage extends StatefulWidget {
  MessagesListPage(this.pageTitle);

  final String pageTitle;
  @override
  _MessagesListPageState createState() => _MessagesListPageState();
}

class _MessagesListPageState extends State<MessagesListPage> {
  @override
  Widget build(BuildContext context) {
    final ListArguments args =
        ModalRoute.of(context).settings.arguments as ListArguments;
    final _messageData = context.watch<MessageProvider>();

    return Scaffold(
      appBar: CustomAppBar(
          title: widget.pageTitle,
          onBackPress: () {
            Navigator.pop(context);
          }),
      body: _buildMessagesListBody(args.messagesList, _messageData),
    );
  }

  Widget _buildMessagesListBody(
      List<Message> messagesList, MessageProvider _messageData) {
    if (messagesList.isNotEmpty) {
      return ListView.builder(
        itemCount: messagesList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppStrings.messagePageRoute,
                    arguments: MessageArguments(message: messagesList[index]));
                setState(() {
                  messagesList[index].isRead = true;
                  _messageData.updateMessage(messagesList[index].messageId);
                });
              },
              child: _messageItem(messagesList[index]));
        });
    }

    return Center(
      child: Text(
        'Sin mensajes',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget _messageItem(Message messageItem) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: (!messageItem.isRead)
            ? BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10))
            : BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _checkMaxStringLength(messageItem.subject, 20),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    UtilsDateTimeFormat.formatDate(
                        "dd/MM/yyyy", messageItem.dateSent),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _checkMaxStringLength(messageItem.messageContent, 44),
                style: TextStyle(fontSize: 14),
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  String _checkMaxStringLength(String textToCheck, int maxLength) {
    if (textToCheck.length > maxLength)
      return textToCheck.substring(0, maxLength) + "...";

    return textToCheck;
  }
}
