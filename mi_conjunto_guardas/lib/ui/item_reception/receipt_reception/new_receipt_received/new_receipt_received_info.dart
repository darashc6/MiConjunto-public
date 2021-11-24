import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import 'package:mi_conjunto_guardas/provider_models/receipt_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/resident_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/residential_block_provider.dart';
import 'package:mi_conjunto_guardas/route_arguments/resident_arguments.dart';
import 'package:mi_conjunto_guardas/route_arguments/success_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/alert_dialog.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_appbar.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_elevated_button.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_text_form_field.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';
import '../../../../constants/colors.dart' as AppColors;
import '../../../../constants/strings.dart' as AppStrings;
import '../../../../constants/variables.dart' as AppVariables;

import '../../dropdown_menu.dart';
import '../../resident_item.dart';
import 'package:provider/provider.dart';

/// Página para añadir más información sobre el nuevo recibo (empresa, observaciones)
class NewReceiptReceivedInfoPage extends StatefulWidget {
  @override
  _NewReceiptReceivedInfoPageState createState() =>
      _NewReceiptReceivedInfoPageState();
}

class _NewReceiptReceivedInfoPageState
    extends State<NewReceiptReceivedInfoPage> {
  final TextEditingController observationNotesController =
      TextEditingController();
  String publicCompanyIdSelected = "1";
  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    final Resident resident =
        (ModalRoute.of(context).settings.arguments as ResidentArguments)
            .resident;
    final _receiptData = context.watch<ReceiptProvider>();
    final _residentialBlockData = context.watch<ResidentialBlockProvider>();
    final _residentData = context.watch<ResidentProvider>();

    return Scaffold(
      appBar: CustomAppBar(
          appBarTitle: "Recepción de recibo",
          onTap: () {
            Navigator.pop(context);
          }),
      body: ListView(
        children: [
          _checkReceiptTo(resident),
          _buildDropdownMenu(),
          CustomTextFormField(
            labelText: "Observaciones",
            controller: observationNotesController,
            keyboardType: TextInputType.text,
            minLines: 4,
          ),
          SizedBox(height: 25),
          _buildAddReceiptButton(
              resident, _receiptData, _residentData, _residentialBlockData)
        ],
      ),
    );
  }

  _buildDropdownMenu() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.skyBlue, width: 2)),
        child: DropdownMenu(
            dropdownItems: AppVariables.receiptPublicCompanies,
            onValueChange: (value) {
              publicCompanyIdSelected = value;
            }),
      ),
    );
  }

  _buildAddReceiptButton(
      Resident resident,
      ReceiptProvider receiptData,
      ResidentProvider residentData,
      ResidentialBlockProvider residentialBlockData) {
    return (isAdding)
        ? Center(child: ProgressLoader())
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: CustomElevatedButton(
              onPress: () async => await _addReceipt(
                  resident, receiptData, residentData, residentialBlockData),
              buttonText: "RECIBIDO",
            ));
  }

  _addReceipt(
      Resident resident,
      ReceiptProvider receiptData,
      ResidentProvider residentData,
      ResidentialBlockProvider residentialBlockData) async {
    if (resident != null) {
      await _addReceiptToSingleResident(receiptData, resident);
    }

    if (resident == null) {
      await _addReceiptToResidentsBlock(
          receiptData, residentData, residentialBlockData);
    }
  }

  /// Comprueba si el recibo está dirigido para un solo residente, o al conjunto entero
  _checkReceiptTo(Resident resident) {
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

  /// Añade el nuevo recibo al dirigente único
  _addReceiptToSingleResident(
      ReceiptProvider receiptData, Resident residentToAdd) async {
    setState(() {
      isAdding = true;
    });
    bool isReceiptAdded = await receiptData.addReceipt(residentToAdd.residentId,
        int.parse(publicCompanyIdSelected), observationNotesController.text);

    if (isReceiptAdded) {
      setState(() {
        isAdding = false;
        Navigator.pushNamed(context, AppStrings.successPageRoute,
            arguments: SuccessArguments(
                successMessage: "¡Recibo recibido!",
                nextRoute: AppStrings.receiptReceptionPageRoute));
      });
    } else {
      setState(() {
        isAdding = false;
        _showNewReceiptErrorAlertDialog("Error",
            "Error al añadir un nuevo recibo. Por favor, inténtelo de nuevo más tarde");
      });
    }
  }

  /// Añade el nuevo recibo al conjunto entero
  _addReceiptToResidentsBlock(
      ReceiptProvider receiptData,
      ResidentProvider residentData,
      ResidentialBlockProvider residentialBlockData) async {
    setState(() {
      isAdding = true;
    });
    final blockResidents = await residentData.fetchResidents(
        residentialBlockData.getResidentialBlock.residentialBlockId,
        "",
        "",
        "");

    await Future.forEach(blockResidents, (resident) async {
      await receiptData.addReceipt(resident.residentId,
          int.parse(publicCompanyIdSelected), observationNotesController.text);
    });

    setState(() {
      isAdding = false;
      Navigator.pushNamed(context, AppStrings.successPageRoute,
          arguments: SuccessArguments(
              successMessage: "¡Recibos recibidos!",
              nextRoute: AppStrings.receiptReceptionPageRoute));
    });
  }

  /// En caso de error, se le mostrará una alerta de diálogo
  _showNewReceiptErrorAlertDialog(String title, String message) {
    return showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
              dialogTitle: title,
              dialogMessage: message,
            ),
        barrierDismissible: false);
  }
}
