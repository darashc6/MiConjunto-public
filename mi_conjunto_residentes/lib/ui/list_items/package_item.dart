import 'package:flutter/material.dart';
import 'package:mi_conjunto_residentes/models/package.dart';
import 'package:mi_conjunto_residentes/utils/date_time_format.dart'
    as UtilsDateTimeFormat;
import '../../constants/colors.dart' as AppColors;
import '../../constants/strings.dart' as AppStrings;

/// Instancia de encomienda
class PackageItem extends StatelessWidget {
  PackageItem(this.package);

  final TextStyle infoTextStyle =
      TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold);
  final Package package;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width,
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
              _displayCompanyLogo(),
              _displayPackageBody(context),
            ],
          ),
          if (package.deliveryDate == null) _displayPendingBanner()
        ]),
      ),
    );
  }

  Widget _displayPackageBody(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 120,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.lightBrown, AppColors.darkBrown],
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
            if (package.notes != null) _displayNotes(context),
          ],
        ),
      ),
    );
  }

  Widget _displayCompanyLogo() {
    return Container(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(_packageCompanyIcon(package.company.companyId)),
      ),
    );
  }

  Widget _displayMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Empresa: ${package.company.name}',
          style: infoTextStyle,
        ),
        Text(
          _displayCorrectDate(package),
          style: infoTextStyle,
        ),
        Text(
          _displayCorrectTime(package),
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
                  'Observaciones: ${package.notes}',
                  style: infoTextStyle,
                ),
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

  String _displayCorrectDate(Package package) {
    if (package.deliveryDate == null)
      return 'Fecha recibido: ${UtilsDateTimeFormat.formatDate("dd/MM/yyyy", package.receptionDate)}';

    return 'Fecha entregado: ${UtilsDateTimeFormat.formatDate("dd/MM/yyyy", package.deliveryDate)}';
  }

  String _displayCorrectTime(Package package) {
    if (package.deliveryDate == null)
      return 'Hora recibido: ${UtilsDateTimeFormat.formatDate("HH:mm", package.receptionDate)}';

    return 'Hora entregado: ${UtilsDateTimeFormat.formatDate("HH:mm", package.deliveryDate)}';
  }
}
