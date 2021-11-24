import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import 'package:mi_conjunto_guardas/provider_models/resident_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/residential_block_provider.dart';
import 'package:mi_conjunto_guardas/route_arguments/resident_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_appbar.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';
import 'package:mi_conjunto_guardas/ui/common/search_text_form_field.dart';
import '../../../../constants/strings.dart' as AppStrings;

import '../../resident_item.dart';
import 'package:provider/provider.dart';

/// Página para seleccionar el dirigente del nuevo recibo
class NewReceiptReceivedPage extends StatefulWidget {
  @override
  _NewReceiptReceivedPageState createState() => _NewReceiptReceivedPageState();
}

class _NewReceiptReceivedPageState extends State<NewReceiptReceivedPage> {
  final _towerSearchController = TextEditingController();
  final _apartmentSearchController = TextEditingController();
  final _ownerNameSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _residentialBlockData = context.watch<ResidentialBlockProvider>();
    final _residentData = context.watch<ResidentProvider>();

    return Scaffold(
      appBar: CustomAppBar(appBarTitle: "Recepción de recibo", onTap: () {
        Navigator.pop(context);
      }),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Text(
              "Introduzca el dirigente del recibo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, AppStrings.newReceiptReceivedPageInfoRoute,
                    arguments: ResidentArguments(resident: null));
              },
              child: _buildAllResidentsButton(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "o",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SearchTextFormField(
                  AppStrings.towerString,
                  "assets/textfield_tower_icon.png",
                  _towerSearchController, (value) async {
                await Future.delayed(Duration(milliseconds: 250));
                setState(() {});
              }),
              SearchTextFormField(
                  AppStrings.apartmentString,
                  "assets/textfield_apartment_icon.png",
                  _apartmentSearchController, (value) async {
                await Future.delayed(Duration(milliseconds: 250));
                setState(() {});
              }),
            ],
          ),
          SearchTextFormField(
            AppStrings.ownerNameString,
            "assets/textfield_owner_icon.png",
            _ownerNameSearchController,
            (value) async {
              await Future.delayed(Duration(milliseconds: 250));
              setState(() {});
            },
            width: double.infinity,
            keyboardType: TextInputType.name,
          ),
          Expanded(
            child: FutureBuilder<List<Resident>>(
                future: _residentData.fetchResidents(
                    _residentialBlockData
                        .getResidentialBlock.residentialBlockId,
                    _towerSearchController.text,
                    _apartmentSearchController.text,
                    _ownerNameSearchController.text),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: ProgressLoader(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }

                  if (snapshot.data.isEmpty) {
                    return Center(
                      child: Text(
                        "Sin resultados",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return _buildResidentsList(snapshot.data);
                }),
          )
        ],
      ),
    );
  }

  _buildResidentsList(List<Resident> residentsList) {
    return ListView.builder(
        itemCount: residentsList.length,
        itemBuilder: (context, index) {
          return ResidentItem(residentsList[index], () {
            Navigator.pushNamed(
                context, AppStrings.newReceiptReceivedPageInfoRoute,
                arguments: ResidentArguments(resident: residentsList[index]));
          });
        });
  }

  _buildAllResidentsButton() {
    return Container(
      width: double.infinity,
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
}
