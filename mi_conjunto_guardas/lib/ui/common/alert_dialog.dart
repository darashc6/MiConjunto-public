import 'package:flutter/material.dart';

/// Alerta de diálogo personalizado
class CustomAlertDialog extends StatelessWidget {
  CustomAlertDialog({@required this.dialogTitle, @required this.dialogMessage});

  final String dialogTitle;
  final String dialogMessage;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(dialogTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
          dialogMessage,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "OK",
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ]);
  }
}
