import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import 'package:mi_conjunto_guardas/provider_models/resident_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/residential_block_provider.dart';
import 'package:mi_conjunto_guardas/route_arguments/resident_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';
import '../common/custom_appbar.dart';
import '../common/search_text_form_field.dart';
import 'resident_item_with_phone_numbers.dart';
import 'package:provider/provider.dart';

import '../../constants/strings.dart' as AppStrings;

/// Muestra la lista de residentes que tiene el conjunto
class ResidentsListPage extends StatefulWidget {
  @override
  _ResidentsListPageState createState() => _ResidentsListPageState();
}

class _ResidentsListPageState extends State<ResidentsListPage> {
  final _towerSearchController = TextEditingController();
  final _apartmentSearchController = TextEditingController();
  final _ownerNameSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _residentialBlockData = context.watch<ResidentialBlockProvider>();
    final _residentData = context.watch<ResidentProvider>();

    return Scaffold(
      appBar: CustomAppBar(
        appBarTitle: "Residentes",
        onTap: () {
          Navigator.pop(context);
        },
        trailingIcons: [
          IconButton(
              icon: Icon(
                Icons.group,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, AppStrings.newMessagePage,
                    arguments: ResidentArguments(resident: null));
              })
        ],
      ),
      body: Column(
        children: [
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
          Flexible(
            child: FutureBuilder<List<Resident>>(
                future: _residentData.fetchResidents(
                  _residentialBlockData.getResidentialBlock.residentialBlockId,
                  _towerSearchController.text,
                  _apartmentSearchController.text,
                  _ownerNameSearchController.text,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: ProgressLoader(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  }

                  if (snapshot.data.isEmpty) {
                    return Center(
                      child: Text(
                        AppStrings.noResultsString,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return _buildListResidents(snapshot.data);
                }),
          )
        ],
      ),
    );
  }

  _buildListResidents(List<Resident> listResidents) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: listResidents.length,
        itemBuilder: (context, index) {
          return ResidentItemWithPhoneNumbers(listResidents[index]);
        });
  }
}
