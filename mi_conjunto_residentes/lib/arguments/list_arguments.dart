import 'package:mi_conjunto_residentes/models/message.dart';

class ListArguments {
  final List<dynamic> pendingList;
  final List<dynamic> receivedList;
  final List<Message> messagesList;
  final String itemType;

  ListArguments({this.pendingList, this.receivedList, this.messagesList, this.itemType});
}
