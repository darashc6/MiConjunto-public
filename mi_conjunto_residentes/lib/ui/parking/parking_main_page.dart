import 'package:flutter/material.dart';
import 'package:mi_conjunto_residentes/arguments/parking_arguments.dart';
import 'package:mi_conjunto_residentes/models/parking.dart';
import 'package:mi_conjunto_residentes/provider/parking_provider.dart';
import 'package:mi_conjunto_residentes/provider/resident_provider.dart';
import 'package:mi_conjunto_residentes/ui/common/custom_app_bar.dart';
import 'package:mi_conjunto_residentes/ui/common/progress_loader.dart';
import 'package:mi_conjunto_residentes/ui/parking/parking_item.dart';
import '../../constants/strings.dart' as AppStrings;
import '../../utils/date_time_format.dart' as UtilsDateTimeFormat;

import 'package:provider/provider.dart';

/// Página principal de 'Parqueado'
/// En esta página se puede ver el historial de parqueadeos y el parqueado activo (Si la hay) de un residente
class ParkingMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool parkingActive =
        (ModalRoute.of(context).settings.arguments as ParkingArguments)
            .parkingActive;
    final _residentData = context.watch<ResidentProvider>();
    final _parkingData = context.watch<ParkingProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Parqueados",
          onBackPress: () {
            Navigator.pop(context);
          },
          customTabs: [_buildTab("Activo"), _buildTab("Historial")],
        ),
        body: TabBarView(children: [
          _getResidentParkingInfoActive(
              _residentData, _parkingData, parkingActive),
          _getResidentParkingInfoHistory(_residentData, _parkingData)
        ]),
      ),
    );
  }

  Widget _buildTab(String tabTitle) {
    return Tab(
      child: Text(
        tabTitle,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _getResidentParkingInfoActive(ResidentProvider residentData,
      ParkingProvider parkingData, bool parkingActive) {
    return (!parkingActive)
        ? Center(
            child: Text(
              "Parqueado inactivo",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          )
        : FutureBuilder<Parking>(
            future:
                parkingData.fetchParking(residentData.getResident.residentId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: ProgressLoader(),
                );
              }

              if (snapshot.hasError) {
                return Center(
                    child: Text("Error cargando los datos del parqueamiento."));
              }

              return _buildParkingDataBody(snapshot.data);
            });
  }

  Widget _getResidentParkingInfoHistory(
      ResidentProvider residentData, ParkingProvider parkingData) {
    return FutureBuilder(
        future: parkingData
            .fetchParkingHistoryList(residentData.getResident.residentId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: ProgressLoader(),
            );
          }

          if (snapshot.hasError) {
            return Center(
                child: Text("Error cargando los datos del parqueamiento."));
          }

          return _generateParkingHistoryList(snapshot.data);
        });
  }

  Widget _buildParkingDataBody(Parking parking) {
    return ListView(
      children: [
        _buildParkingSubItem(
            "Ingreso",
            UtilsDateTimeFormat.formatDate("y-MM-d - HH:mm:ss", parking.entryDate)),
        _buildParkingSubItem("Nº Parqueado", '${parking.nParking}'),
        _buildParkingSubItem("Placa vehículo", parking.numberPlate),
        if (parking.notes != null)
          _buildParkingSubItem("Observaciones", parking.notes),
      ],
    );
  }

  Widget _buildParkingSubItem(String title, String content) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$content',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _generateParkingHistoryList(List<Parking> parkingList) {
    return (parkingList.isEmpty)
        ? Center(
            child: Text("Historial vacío"),
          )
        : ListView.builder(
            itemCount: parkingList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppStrings.parkingInfoPageRoute,
                      arguments: ParkingArguments(parking: parkingList[index]));
                },
                child: ParkingItem(
                  parking: parkingList[index],
                ),
              );
            });
  }
}
