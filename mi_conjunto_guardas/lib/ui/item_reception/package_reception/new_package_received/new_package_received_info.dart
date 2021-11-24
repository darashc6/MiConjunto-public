import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import 'package:mi_conjunto_guardas/provider_models/package_provider.dart';
import 'package:mi_conjunto_guardas/route_arguments/resident_arguments.dart';
import 'package:mi_conjunto_guardas/route_arguments/success_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/alert_dialog.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_elevated_button.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_text_form_field.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/dropdown_menu.dart';
import '../../../common/custom_appbar.dart';
import '../../resident_item.dart';
import '../../../../constants/colors.dart' as AppColors;
import '../../../../constants/strings.dart' as AppStrings;
import '../../../../constants/variables.dart' as AppVariables;

import 'package:provider/provider.dart';

/// Página para añadir más información sobre la nueva encomienda (empresa, observaciones)
class NewPackageReceivedInfoPage extends StatefulWidget {
  @override
  _NewPackageReceivedInfoPageState createState() =>
      _NewPackageReceivedInfoPageState();
}

class _NewPackageReceivedInfoPageState
    extends State<NewPackageReceivedInfoPage> {
  TextEditingController observationNotesController = TextEditingController();
  String companyIdSelected = "1";
  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    final Resident resident =
        (ModalRoute.of(context).settings.arguments as ResidentArguments)
            .resident;
    final _packageData = context.watch<PackageProvider>();

    return Scaffold(
      appBar: CustomAppBar(
          appBarTitle: "Recepción de encomienda",
          onTap: () {
            Navigator.pop(context);
          }),
      body: ListView(
        children: [
          ResidentItem(resident, null),
          _buildDropdownMenu(),
          CustomTextFormField(
            labelText: "Observaciones",
            controller: observationNotesController,
            keyboardType: TextInputType.text,
            minLines: 4,
          ),
          SizedBox(height: 25),
          _buildAddPackageButton(resident, _packageData)
        ],
      ),
    );
  }

  /// Guarda la nueva encomienda
  _addPackage(Resident resident, PackageProvider packageData) async {
    setState(() {
      isAdding = true;
    });
    bool isPackageAdded = await packageData.addPackage(resident.residentId,
        int.parse(companyIdSelected), observationNotesController.text);

    if (isPackageAdded) {
      setState(() {
        isAdding = false;
        Navigator.pushNamed(context, AppStrings.successPageRoute,
            arguments: SuccessArguments(
                successMessage: "¡Nueva encomienda recibido!",
                nextRoute: AppStrings.packageReceptionPageRoute));
      });
    } else {
      setState(() {
        isAdding = false;
        _showNewPackageErrorAlertDialog("Error",
            "Error al añadir una nueva encomienda. Por favor, inténtelo de nuevo más tarde");
      });
    }
  }

  _buildAddPackageButton(Resident resident, PackageProvider packageData) {
    return (isAdding)
        ? Center(
            child: ProgressLoader(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 75),
            child: CustomElevatedButton(
              onPress: () async => await _addPackage(resident, packageData),
              buttonText: "RECIBIDO",
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
            dropdownItems: AppVariables.packageCompanies,
            onValueChange: (value) {
              companyIdSelected = value;
            }),
      ),
    );
  }

  /// En caso de error, se le mostrará una alerta de diálogo
  _showNewPackageErrorAlertDialog(String title, String message) {
    return showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
              dialogTitle: title,
              dialogMessage: message,
            ),
        barrierDismissible: false);
  }
}
