import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/receipt.dart';
import 'package:mi_conjunto_guardas/provider_models/receipt_provider.dart';
import 'package:mi_conjunto_guardas/route_arguments/resident_arguments.dart';
import 'package:mi_conjunto_guardas/route_arguments/success_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_elevated_button.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/receipt_reception/user_receipts_pending/receipt_item.dart';
import '../../resident_item.dart';
import '../../../common/custom_appbar.dart';
import '../../../../constants/strings.dart' as AppStrings;

import 'package:provider/provider.dart';

/// Página para ver los recibos pendientes de un residente
class UserReceiptsPendingPage extends StatefulWidget {
  @override
  _UserReceiptsPendingPageState createState() =>
      _UserReceiptsPendingPageState();
}

class _UserReceiptsPendingPageState extends State<UserReceiptsPendingPage> {
  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final ResidentArguments args =
        ModalRoute.of(context).settings.arguments as ResidentArguments;
    final _receiptData = context.watch<ReceiptProvider>();

    return Scaffold(
      appBar: CustomAppBar(
          appBarTitle: "Recibos pendiente",
          onTap: () {
            Navigator.pop(context);
          }),
      body: Column(
        children: [
          ResidentItem(args.resident, null),
          Expanded(
              child: FutureBuilder<List<Receipt>>(
                  future: _receiptData.fetchReceipts(
                      args.resident.residentId, true),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: ProgressLoader(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }

                    return (isUpdating)
                        ? Center(
                            child: ProgressLoader(),
                          )
                        : ListView(
                            children: _receiptsPendingWidgetList(
                                snapshot.data, _receiptData),
                          );
                  })),
        ],
      ),
    );
  }

  _receiptsPendingWidgetList(
      List<Receipt> listReceipts, ReceiptProvider receiptData) {
    List<Widget> _listReceiptsPending = [];

    listReceipts.forEach((receipt) {
      receipt.checked = false;
      _listReceiptsPending.add(ReceiptItem(receipt));
    });

    _listReceiptsPending.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 10),
      child: CustomElevatedButton(
          buttonText: "ENTREGADO",
          onPress: () async =>
              await _updateReceipts(listReceipts, receiptData)),
    ));

    return _listReceiptsPending;
  }

  _updateReceipts(
      List<Receipt> listReceipts, ReceiptProvider receiptData) async {
    setState(() {
      isUpdating = true;
    });

    await Future.forEach(
        listReceipts.where((receipt) => receipt.checked).toList(),
        (receipt) async {
      await receiptData.updatePackage(receipt.receiptId);
    });

    setState(() {
      isUpdating = false;
      Navigator.pushNamed(context, AppStrings.successPageRoute,
          arguments: SuccessArguments(
              successMessage: "¡Recibos entregados!",
              nextRoute: AppStrings.receiptReceptionPageRoute));
    });
  }
}
