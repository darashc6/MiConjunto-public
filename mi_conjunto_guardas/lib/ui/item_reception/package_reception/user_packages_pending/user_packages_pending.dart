import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/models/package.dart';
import 'package:mi_conjunto_guardas/provider_models/package_provider.dart';
import 'package:mi_conjunto_guardas/route_arguments/resident_arguments.dart';
import 'package:mi_conjunto_guardas/route_arguments/success_arguments.dart';
import 'package:mi_conjunto_guardas/ui/common/custom_elevated_button.dart';
import 'package:mi_conjunto_guardas/ui/common/progress_loader.dart';
import '../../../common/custom_appbar.dart';
import 'package_item.dart';
import '../../../../constants/strings.dart' as AppStrings;
import '../../resident_item.dart';

import 'package:provider/provider.dart';

/// Página para ver los recibos pendientes de un residente
class UserPackagesPendingPage extends StatefulWidget {
  @override
  _UserPackagesPendingPageState createState() =>
      _UserPackagesPendingPageState();
}

class _UserPackagesPendingPageState extends State<UserPackagesPendingPage> {
  bool isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final ResidentArguments args =
        ModalRoute.of(context).settings.arguments as ResidentArguments;
    final _packageData = context.watch<PackageProvider>();

    return Scaffold(
      appBar: CustomAppBar(
          appBarTitle: "Encomiendas pendientes",
          onTap: () {
            Navigator.pop(context);
          }),
      body: Column(
        children: [
          ResidentItem(args.resident, null),
          Expanded(
            child: FutureBuilder<List<Package>>(
                future:
                    _packageData.fetchPackages(args.resident.residentId, true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: ProgressLoader(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  }

                  return (isUpdating)
                      ? Center(
                          child: ProgressLoader(),
                        )
                      : ListView(
                          children: _packagesPendingWidgetList(
                              snapshot.data, _packageData),
                        );
                }),
          ),
        ],
      ),
    );
  }

  _packagesPendingWidgetList(
      List<Package> listPackages, PackageProvider packageData) {
    List<Widget> _listPackagesPending = [];

    listPackages.forEach((package) {
      package.checked = false;
      _listPackagesPending.add(PackageItem(package));
    });

    _listPackagesPending.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 10),
      child: CustomElevatedButton(
          buttonText: "ENTREGADO",
          onPress: () async =>
              await _updatePackages(listPackages, packageData)),
    ));

    return _listPackagesPending;
  }

  /// Actualiza encomienda(s)
  _updatePackages(
      List<Package> listPackages, PackageProvider packageData) async {
    setState(() {
      isUpdating = true;
    });

    await Future.forEach(
        listPackages.where((package) => package.checked).toList(),
        (package) async {
      await packageData.updatePackage((package.packageId));
    });

    setState(() {
      isUpdating = false;
      Navigator.pushNamed(context, AppStrings.successPageRoute,
          arguments: SuccessArguments(
              successMessage: "¡Encomiendas entregados!",
              nextRoute: AppStrings.packageReceptionPageRoute));
    });
  }
}
