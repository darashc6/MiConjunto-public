import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/resident.dart';
import 'package:mi_conjunto_guardas/provider_models/resident_provider.dart';
import 'package:mi_conjunto_guardas/provider_models/residential_block_provider.dart';
import 'package:mi_conjunto_guardas/route_arguments/residents_list_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/alert_dialog.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_appbar.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';
import '../../../constants/strings.dart' as AppStrings;

import 'package:provider/provider.dart';

import '../new_or_pending_item_button.dart';

/// Página principal de 'Parqueadero'
class ParkingMainPage extends StatefulWidget {
  @override
  _ParkingMainPageState createState() => _ParkingMainPageState();
}

class _ParkingMainPageState extends State<ParkingMainPage> {
  @override
  Widget build(BuildContext context) {
    final _residentData = context.watch<ResidentProvider>();
    final _residentialBlockData = context.watch<ResidentialBlockProvider>();

    return WillPopScope(
      onWillPop: () => _returnToProfilePage(),
      child: Scaffold(
          appBar: CustomAppBar(appBarTitle: "Parqueaderos Visitantes", onTap: () => _returnToProfilePage()),
          body: FutureBuilder<List<Resident>>(
            future: _residentData.fetchResidents(
                _residentialBlockData.getResidentialBlock.residentialBlockId,
                "",
                "",
                "",
                parkingActive: true),
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
                        buttonTitle: "Asignar parqueadero",
                        buttonDescription: "Asignar un nuevo parqueadero de visitante",
                        onPress: () {
                          Navigator.pushNamed(
                              context, AppStrings.newParkingPageRoute);
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    NewOrPendingItemButton(
                        buttonTitle: "Parqueaderos asignados",
                        buttonDescription:
                            "Apartamento / Casas con algún parqueadero de visitante asignado",
                        nPending: snapshot.data.length,
                        onPress: () => _activeParkingOnPress(snapshot.data))
                  ],
                ),
              );
            },
          )),
    );
  }

  _activeParkingOnPress(List<Resident> residentsList) {
    (residentsList.isNotEmpty)
        ? Navigator.pushNamed(
            context, AppStrings.residentsListWithParkingActivePageRoute,
            arguments: ResidentsListArguments(
                residentsList: residentsList,
                nextRoute: AppStrings.residentParkingPageRoute))
        : _showNoPendingPackagesAlertDialog(
            "Parqueaderos no activos", "No tiene ningun parqueadero activo");
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

  _returnToProfilePage() {
    Navigator.pushNamedAndRemoveUntil(
        context, AppStrings.profilePageRoute, (route) => false);
  }
}
