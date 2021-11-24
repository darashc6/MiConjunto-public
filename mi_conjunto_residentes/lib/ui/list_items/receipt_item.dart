import 'package:flutter/material.dart';
import 'package:mi_conjunto_residentes/models/receipt.dart';
import '../../constants/colors.dart' as AppColors;
import '../../constants/strings.dart' as AppStrings;
import '../../utils/date_time_format.dart' as UtilsDateTimeFormat;

/// Instancia de Recibo
class ReceiptItem extends StatelessWidget {
  ReceiptItem(this.receipt);

  final TextStyle infoTextStyle =
      TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold);
  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey, offset: Offset(0.0, 1.0), blurRadius: 6.0)
            ]),
        child: Stack(children: [
          Row(
            children: [
              _displayPublicCompanyLogo(),
              _displayReceiptBody(context),
            ],
          ),
          if (receipt.deliveryDate == null) _displayPendingBanner()
        ]),
      ),
    );
  }

  Container _displayReceiptBody(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 120,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.lightGreen, AppColors.darkGreen],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _displayMainInfo(),
            if (receipt.notes != null) _displayNotes(context),
          ],
        ),
      ),
    );
  }

  Container _displayPublicCompanyLogo() {
    return Container(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(
            _receiptCompanyIcon(receipt.publicCompany.publicCompanyId)),
      ),
    );
  }

  Widget _displayMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Empresa: ${receipt.publicCompany.name}',
          style: infoTextStyle,
        ),
        Text(
          _displayCorrectDate(receipt),
          style: infoTextStyle,
        ),
        Text(
          _displayCorrectTime(receipt),
          style: infoTextStyle,
        ),
      ],
    );
  }

  Widget _displayPendingBanner() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 75,
          height: 20,
          color: Colors.red,
          child: Center(
            child: Text(
              "Pendiente",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayNotes(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 145,
              child: Wrap(children: [
                Text(
                  'Observaciones: ${receipt.notes}',
                  style: infoTextStyle,
                ),
              ]),
            ),
          ],
        )
      ],
    );
  }

  String _receiptCompanyIcon(int publicCompanyId) {
    const String assetsMainPath = AppStrings.assetsPublicCompanyLogos;

    switch (publicCompanyId) {
      case 1:
        return "$assetsMainPath/enel_condensa_logo.png";
        break;
      case 2:
        return "$assetsMainPath/gas_natural_logo.png";
        break;
      case 3:
        return "$assetsMainPath/acueducto_logo.png";
        break;
      default:
        return "$assetsMainPath/internet_logo.png";
        break;
    }
  }

  String _displayCorrectDate(Receipt receipt) {
    if (receipt.deliveryDate == null)
      return 'Fecha recibido: ${UtilsDateTimeFormat.formatDate("dd/MM/yyyy", receipt.receptionDate)}';

    return 'Fecha entregado: ${UtilsDateTimeFormat.formatDate("dd/MM/yyyy", receipt.deliveryDate)}';
  }

  String _displayCorrectTime(Receipt receipt) {
    if (receipt.deliveryDate == null)
      return 'Hora recibido: ${UtilsDateTimeFormat.formatDate("HH:mm", receipt.receptionDate)}';

    return 'Hora entregado: ${UtilsDateTimeFormat.formatDate("HH:mm", receipt.deliveryDate)}';
  }
}
