import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import 'package:mi_conjunto_guardas/provider_models/package_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/residential_block_provider.dart';
import 'package:mi_conjunto_guardas/route_arguments/residents_list_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/alert_dialog.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';
import 'package:mi_conjunto_guardas/ui/item_reception/new_or_pending_item_button.dart';
import '../../common/custom_appbar.dart';

import '../../../constants/strings.dart' as AppStrings;
import 'package:provider/provider.dart';

/// Página principal de Encomiendas
class PackageMainPage extends StatefulWidget {
  @override
  _PackageMainPageState createState() => _PackageMainPageState();
}

class _PackageMainPageState extends State<PackageMainPage> {
  @override
  Widget build(BuildContext context) {
    final _residentialBlockData = context.watch<ResidentialBlockProvider>();
    final _packageData = context.watch<PackageProvider>();

    return WillPopScope(
      onWillPop: () => _returnToProfilePage(),
      child: Scaffold(
          appBar: CustomAppBar(
              appBarTitle: "Encomiendas", onTap: () => _returnToProfilePage()),
          body: FutureBuilder<List<Resident>>(
            future: _packageData.fetchResidentsWithPendingPackages(
                _residentialBlockData.getResidentialBlock.residentialBlockId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ProgressLoader(),
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              }

              return Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    NewOrPendingItemButton(
                        buttonTitle: "Recepción de encomienda",
                        buttonDescription: "Añadir una nueva encomienda",
                        onPress: () {
                          Navigator.pushNamed(
                              context, AppStrings.newPackageReceivedPageRoute);
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    NewOrPendingItemButton(
                        buttonTitle: "Encomiendas pendientes",
                        buttonDescription:
                            "Apartamento / Casas con encomiendas pendientes",
                        nPending: snapshot.data.length,
                        onPress: () => _pendingPackagesOnPress(snapshot.data))
                  ],
                ),
              );
            },
          )),
    );
  }

  _showNoPendingPackagesAlertDialog(String title, String message) {
    return showDialog(
        context: context,
        builder: (_) => CustomAlertDialog(
              dialogTitle: title,
              dialogMessage: message,
            ),
        barrierDismissible: false);
  }

  _pendingPackagesOnPress(List<Resident> residentsList) {
    (residentsList.isNotEmpty)
        ? Navigator.pushNamed(
            context, AppStrings.residentsListWithPackagesPendingPageRoute,
            arguments: ResidentsListArguments(
                residentsList: residentsList,
                nextRoute: AppStrings.residentPackagesPendingPageRoute))
        : _showNoPendingPackagesAlertDialog(
            "Encomiendas pendientes", "No tiene ninguna encomienda pendiente");
  }

  _returnToProfilePage() {
    Navigator.pushNamedAndRemoveUntil(
        context, AppStrings.profilePageRoute, (route) => false);
  }
}
