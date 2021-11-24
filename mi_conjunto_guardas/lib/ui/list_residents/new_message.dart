import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import 'package:mi_conjunto_guardas/provider_models/message_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/resident_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/residential_block_provider.dart';
import 'package:mi_conjunto_guardas/route_arguments/resident_arguments.dart';
import 'package:mi_conjunto_guardas/route_arguments/success_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/alert_dialog.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_appbar.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_elevated_button.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_text_form_field.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/resident_item.dart';
import 'package:provider/provider.dart';
import '../../constants/strings.dart' as AppStrings;

/// Página de envío de un nuevo mensaje al residente
class NewMessagePage extends StatefulWidget {
  @override
  _NewMessagePageState createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  final subjectController = TextEditingController();
  final messageContentController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Resident resident =
        (ModalRoute.of(context).settings.arguments as ResidentArguments)
            .resident;
    final _messageData = context.watch<MessageProvider>();
    final _residentData = context.watch<ResidentProvider>();
    final _residentialBlockData = context.watch<ResidentialBlockProvider>();

    return Scaffold(
      appBar: CustomAppBar(
          appBarTitle: "Nuevo mensaje",
          onTap: () {
            Navigator.pop(context);
          }),
      body: ListView(
        children: [
          _checkMessageTo(resident),
          _buildTextFormField(subjectController, "Asunto*", 1),
          _buildTextFormField(messageContentController, "Mensaje*", 4),
          SizedBox(
            height: 20,
          ),
          _buildMessageButton(
              _messageData, _residentData, _residentialBlockData, resident)
        ],
      ),
    );
  }

  _checkMessageTo(Resident resident) {
    if (resident != null) {
      return ResidentItem(resident, null);
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Dirigido a todos los residentes",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  _buildMessageButton(
      MessageProvider messageData,
      ResidentProvider residentProvider,
      ResidentialBlockProvider residentialBlockData,
      Resident resident) {
    return (isLoading)
        ? Center(child: ProgressLoader())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: CustomElevatedButton(
              onPress: () async => await _sendMessage(resident, messageData,
                  residentProvider, residentialBlockData),
              buttonText: "ENVIAR MENSAJE",
            ));
  }

  _buildTextFormField(
      TextEditingController controller, String labelText, int minLines) {
    return CustomTextFormField(
      labelText: labelText,
      controller: controller,
      minLines: minLines,
      keyboardType: TextInputType.text,
    );
  }

  _sendMessage(
      Resident resident,
      MessageProvider messageData,
      ResidentProvider residentData,
      ResidentialBlockProvider residentialBlockData) async {
    if (_messageBodyIsNotEmpty()) {
      if (resident != null) {
        await _sendMessageToSingleResident(messageData, resident);
      }

      if (resident == null) {
        await _sendMessageToResidentialBlock(
            residentialBlockData, residentData, messageData);
      }
    } else {
      _showMessageAlertDialogError("Campos vacíos",
          "Rellene todos los campos necesarios para mandar el mensaje");
    }
  }

  _sendMessageToResidentialBlock(ResidentialBlockProvider residentialBlockData,
      ResidentProvider residentData, MessageProvider messageData) async {
    setState(() {
      isLoading = true;
    });

    List<Resident> blockResidents = await residentData.fetchResidents(
        residentialBlockData.getResidentialBlock.residentialBlockId,
        "",
        "",
        "");

    await Future.forEach(blockResidents, (resident) async {
      await messageData.addMessage(subjectController.text,
          messageContentController.text, resident.residentId);
    });

    setState(() {
      isLoading = false;
      Navigator.pushNamed(context, AppStrings.successPageRoute,
          arguments: SuccessArguments(
              successMessage: "¡Mensajes enviados!",
              nextRoute: AppStrings.profilePageRoute));
    });
  }

  _sendMessageToSingleResident(
      MessageProvider messageData, Resident resident) async {
    setState(() {
      isLoading = true;
    });

    bool isMessageAdded = await messageData.addMessage(subjectController.text,
        messageContentController.text, resident.residentId);

    if (isMessageAdded) {
      Navigator.pushNamed(context, AppStrings.successPageRoute,
          arguments: SuccessArguments(
              successMessage: "¡Mensaje enviado!",
              nextRoute: AppStrings.profilePageRoute));
    } else {
      _showMessageAlertDialogError("Error",
          "Error a la hora de enviar el mensaje. Por favor, intentélo de nuevo más tarde");
    }
    if (_messageBodyIsNotEmpty()) {
    } else {
      _showMessageAlertDialogError("Campos vacíos",
          "Rellene todos los campos necesarios para mandar el mensaje");
    }
  }

  bool _messageBodyIsNotEmpty() {
    return subjectController.text.isNotEmpty &&
        messageContentController.text.isNotEmpty;
  }

  _showMessageAlertDialogError(String title, String message) {
    return showDialog(
        context: context,
        builder: (context) =>
            CustomAlertDialog(dialogTitle: title, dialogMessage: message),
        barrierDismissible: false);
  }
}
