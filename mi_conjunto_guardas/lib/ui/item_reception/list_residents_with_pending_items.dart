import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import 'package:mi_conjunto_guardas/route_arguments/resident_arguments.dart';
import 'package:mi_conjunto_guardas/route_arguments/residents_list_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_appbar.dart';
import 'package:mi_conjunto_guardas/ui/common/search_text_form_field.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/resident_item.dart';
import '../../constants/strings.dart' as AppStrings;

/// Página con encomiendas/recibos pendientes de cada residente
class ListResidentsWithPendingItems extends StatefulWidget {
  @override
  _ListResidentsWithPendingItemsState createState() =>
      _ListResidentsWithPendingItemsState();
}

class _ListResidentsWithPendingItemsState
    extends State<ListResidentsWithPendingItems> {
  final TextEditingController _towerSearchController = TextEditingController();
  final TextEditingController _apartmentSearchController =
      TextEditingController();
  final TextEditingController _ownerNameSearchController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ResidentsListArguments args =
        ModalRoute.of(context).settings.arguments as ResidentsListArguments;

    return Scaffold(
      appBar: CustomAppBar(
          appBarTitle: "Pendientes",
          onTap: () {
            Navigator.pop(context);
          }),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SearchTextFormField(
                  AppStrings.towerString,
                  "assets/textfield_tower_icon.png",
                  _towerSearchController, (value) {
                setState(() {});
              }),
              SearchTextFormField(
                  AppStrings.apartmentString,
                  "assets/textfield_apartment_icon.png",
                  _apartmentSearchController, (value) {
                setState(() {});
              }),
            ],
          ),
          SearchTextFormField(
              AppStrings.ownerNameString,
              "assets/textfield_owner_icon.png",
              _ownerNameSearchController, (value) {
            setState(() {});
          }, width: double.infinity, keyboardType: TextInputType.name),
          Flexible(
              child: _residentsListWithPendingItems(
                  args.residentsList
                      .where((item) =>
                          (_towerSearchController.text.isEmpty
                              ? item.tower
                                  .toString()
                                  .contains(_towerSearchController.text)
                              : item.tower.toString() ==
                                  _towerSearchController.text) &&
                          (_apartmentSearchController.text.isEmpty
                              ? item.apartment
                                  .toString()
                                  .contains(_apartmentSearchController.text)
                              : item.apartment.toString() ==
                                  _apartmentSearchController.text) &&
                          (item.ownerName.toLowerCase().toString().contains(
                              _ownerNameSearchController.text.toLowerCase())))
                      .toList(),
                  args.nextRoute))
        ],
      ),
    );
  }

  _residentsListWithPendingItems(
      List<Resident> residentsList, String nextRoute) {
    return ListView.builder(
        itemCount: residentsList.length,
        itemBuilder: (context, index) {
          return ResidentItem(residentsList[index], () {
            Navigator.pushNamed(context, nextRoute,
                arguments: ResidentArguments(resident: residentsList[index]));
          });
        });
  }
}
