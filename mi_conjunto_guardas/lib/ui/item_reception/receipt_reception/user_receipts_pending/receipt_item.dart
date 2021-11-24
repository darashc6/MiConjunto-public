import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/receipt.dart';
import '../../../../constants/colors.dart' as AppColors;
import '../../../../constants/strings.dart' as AppStrings;
import '../../../../utils/date_time_format.dart' as UtilsDateTimeFormat;

/// Instancia de Recibo
class ReceiptItem extends StatefulWidget {
  ReceiptItem(this.receipt);

  final Receipt receipt;
  @override
  _ReceiptItemState createState() => _ReceiptItemState();
}

class _ReceiptItemState extends State<ReceiptItem> {
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
              _buildPublicCompanyLogo(),
              Container(
                width: MediaQuery.of(context).size.width - 120,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: AppColors.gradientGreen,
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildReceiptInfoText(
                          'Empresa: ${widget.receipt.publicCompany.name}'),
                      _buildReceiptInfoText(
                          'Fecha recibido: ${UtilsDateTimeFormat.formatDate("dd/MM/yyyy", widget.receipt.receptionDate)}'),
                      _buildReceiptInfoText(
                          'Hora recibido: ${UtilsDateTimeFormat.formatDate("HH:mm", widget.receipt.receptionDate)}'),
                      if (widget.receipt.notes != null) _displayNotes(context),
                      _buildCheckBox()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  _buildCheckBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        width: double.infinity,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
                value: widget.receipt.checked,
                onChanged: (value) {
                  setState(() {
                    widget.receipt.checked = value;
                  });
                },
                activeColor: Colors.white,
                checkColor: Colors.black),
          ),
        ),
      ),
    );
  }

  _buildPublicCompanyLogo() {
    return Container(
      width: 100,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(
            _receiptCompanyIcon(widget.receipt.publicCompany.publicCompanyId)),
      ),
    );
  }

  _buildReceiptInfoText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
    );
  }

  _displayNotes(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15),
        Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 145,
              child: Wrap(children: [
                _buildReceiptInfoText('Observaciones: ${widget.receipt.notes}')
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
}
