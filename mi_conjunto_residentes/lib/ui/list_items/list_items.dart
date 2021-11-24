import 'package:flutter/material.dart';
import 'package:mi_conjunto_residentes/models/package.dart';
import 'package:mi_conjunto_residentes/models/receipt.dart';
import 'package:mi_conjunto_residentes/ui/common/custom_app_bar.dart';
import './package_item.dart';
import './receipt_item.dart';
import '../../constants/strings.dart' as AppStrings;

import '../../arguments/list_arguments.dart';

/// Página principal de encomiendas y recibos (Historial y Pendientes)
class ItemsListPage extends StatelessWidget {
  const ItemsListPage(this.pageTitle);
  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    final ListArguments args =
        ModalRoute.of(context).settings.arguments as ListArguments;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: CustomAppBar(
            title: pageTitle,
            onBackPress: () {
              Navigator.pop(context);
            },
            customTabs: [_buildTab("Pendiente"), _buildTab("Historial")],
          ),
          body: TabBarView(children: [
            _checkPendingList(args.pendingList, args.itemType),
            _checkReceivedList(args.receivedList, args.itemType)
          ])),
    );
  }

  Widget _buildTab(String tabName) {
    return Tab(
      child: Text(
        tabName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
  
  Widget _checkReceivedList(List<dynamic> receivedList, String itemType) {
    if (receivedList.isNotEmpty) {
      return ListView.builder(
          itemCount: receivedList.length,
          itemBuilder: (context, index) {
            return _checkItemType(receivedList[index], itemType);
          });
    }

    return Center(
      child: Text(
        'Sin ${itemType == AppStrings.itemTypePackage ? 'encomiendas' : 'recibos'} en los últimos 90 días',
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget _checkPendingList(List<dynamic> pendingList, String itemType) {
    if (pendingList.isNotEmpty) {
      return ListView.builder(
          itemCount: pendingList.length,
          itemBuilder: (context, index) {
            return _checkItemType(pendingList[index], itemType);
          });
    }

    return Center(
      child: Text(
        "No tiene ${itemType == AppStrings.itemTypePackage ? 'ningúna encomienda' : 'ningún recibo'} pendiente",
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  Widget _checkItemType(dynamic item, String itemType) {
    return (itemType == AppStrings.itemTypePackage)
        ? PackageItem(item as Package)
        : ReceiptItem(item as Receipt);
  }
}
