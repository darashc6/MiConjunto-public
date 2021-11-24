import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/package.dart';
import '../../../../constants/colors.dart' as AppColors;
import '../../../../constants/strings.dart' as AppStrings;
import '../../../../utils/date_time_format.dart' as UtilsDateTimeFormat;

/// Instancia de Encomienda
class PackageItem extends StatefulWidget {
  PackageItem(this.package);

  final Package package;
  @override
  _PackageItemState createState() => _PackageItemState();
}

class _PackageItemState extends State<PackageItem> {
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
              _buildCompanyLogo(),
              Container(
                width: MediaQuery.of(context).size.width - 120,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: AppColors.gradientBrown,
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
                      _buildPackageInfoText(
                          'Empresa: ${widget.package.company.name}'),
                      _buildPackageInfoText(
                          'Fecha recibido: ${UtilsDateTimeFormat.formatDate("dd/MM/yyyy", widget.package.receptionDate)}'),
                      _buildPackageInfoText(
                          'Hora recibido: ${UtilsDateTimeFormat.formatDate("HH:mm", widget.package.receptionDate)}'),
                      if (widget.package.notes != null) _displayNotes(context),
                      _buildCheckbox()
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

  _buildCheckbox() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        width: double.infinity,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
                value: widget.package.checked,
                onChanged: (value) {
                  setState(() {
                    widget.package.checked = value;
                  });
                },
                activeColor: Colors.white,
                checkColor: Colors.black),
          ),
        ),
      ),
    );
  }

  _buildCompanyLogo() {
    return Container(
      width: 100,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child:
            Image.asset(_packageCompanyIcon(widget.package.company.companyId)),
      ),
    );
  }

  _buildPackageInfoText(String text) {
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
                _buildPackageInfoText('Observaciones: ${widget.package.notes}'),
              ]),
            ),
          ],
        )
      ],
    );
  }

  String _packageCompanyIcon(int companyId) {
    const String assetsMainPath = AppStrings.assetsCompanyLogos;

    switch (companyId) {
      case 1:
        return '$assetsMainPath/alibaba_logo.png';
        break;
      case 2:
        return "$assetsMainPath/aliexpress_logo.png";
        break;
      case 3:
        return "$assetsMainPath/amazon_logo.png";
        break;
      case 4:
        return "$assetsMainPath/coordinadora_logo.png";
        break;
      case 5:
        return "$assetsMainPath/dafiti_logo.png";
        break;
      case 6:
        return "$assetsMainPath/deprisa_logo.png";
        break;
      case 7:
        return "$assetsMainPath/envia_logo.png";
        break;
      case 8:
        return "$assetsMainPath/falabella_logo.png";
        break;
      case 9:
        return "$assetsMainPath/interrapidisimo_logo.png";
        break;
      case 10:
        return "$assetsMainPath/linio_logo.png";
        break;
      case 11:
        return "$assetsMainPath/mensajeros_urbanos_logo.png";
        break;
      case 12:
        return "$assetsMainPath/mercado_libre_logo.png";
        break;
      case 13:
        return "$assetsMainPath/servientrega_logo.png";
        break;
      case 14:
        return "$assetsMainPath/wish_logo.png";
        break;
      default:
        return "$assetsMainPath/others_logo.png";
        break;
    }
  }
}
