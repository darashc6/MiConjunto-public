import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import 'package:mi_conjunto_guardas/provider_models/resident_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/residential_block_provider.dart';
import 'package:mi_conjunto_guardas/route_arguments/resident_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_appbar.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';
import 'package:mi_conjunto_guardas/ui/common/search_text_form_field.dart';
import 'package:provider/provider.dart';

import '../../../../constants/strings.dart' as AppStrings;
import '../../resident_item.dart';

/// Página para seleccionar el dirigente del nuevo parqueadero
class NewParkingPage extends StatefulWidget {
  @override
  _NewParkingPageState createState() => _NewParkingPageState();
}

class _NewParkingPageState extends State<NewParkingPage> {
  final _towerSearchController = TextEditingController();
  final _apartmentSearchController = TextEditingController();
  final _ownerNameSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _residentialBlockData = context.watch<ResidentialBlockProvider>();
    final _residentData = context.watch<ResidentProvider>();

    return Scaffold(
      appBar: CustomAppBar(
          appBarTitle: "Nuevo parqueadero",
          onTap: () {
            Navigator.pop(context);
          }),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text(
              "Introduzca el dirigente del parqueado",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
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
              _ownerNameSearchController, (value) async {
            await Future.delayed(Duration(milliseconds: 250));
            setState(() {});
          }, width: double.infinity, keyboardType: TextInputType.name),
          Expanded(
            child: FutureBuilder<List<Resident>>(
                future: _residentData.fetchResidents(
                    _residentialBlockData
                        .getResidentialBlock.residentialBlockId,
                    _towerSearchController.text,
                    _apartmentSearchController.text,
                    _ownerNameSearchController.text,
                    parkingActive: false),
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

                  return _builsResidentsList(snapshot.data);
                }),
          )
        ],
      ),
    );
  }

  _builsResidentsList(List<Resident> residentsList) {
    return ListView.builder(
        itemCount: residentsList.length,
        itemBuilder: (context, index) {
          return ResidentItem(residentsList[index], () {
            Navigator.pushNamed(context, AppStrings.newParkingInfoPageRoute,
                arguments: ResidentArguments(resident: residentsList[index]));
          });
        });
  }
}
