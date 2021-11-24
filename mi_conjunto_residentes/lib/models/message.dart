
/// Modelo de 'mensaje'
class Message {
  int messageId;
  String subject;
  String messageContent;
  String dateSent;
  bool isRead;

  Message(
      {this.messageId,
      this.subject,
      this.messageContent,
      this.dateSent,
      this.isRead});
  
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json["messageId"],
      subject: json["subject"],
      messageContent: json["messageContent"],
      dateSent: json["dateSent"],
      isRead: json["isRead"] 
    );
  }
}
