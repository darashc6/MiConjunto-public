import "package:flutter/material.dart";
import 'package:mi_conjunto_residentes/models/resident.dart';
import '../../constants/colors.dart' as AppColors;

/// Clase conteniendo información acerca del residente
class ProfileInfoCard extends StatelessWidget {
  ProfileInfoCard({@required this.resident});

  final Resident resident;

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.gradientOrange)),
      child: Column(
        children: [
          Center(
            child: Image.asset(
              "assets/resident_avatar.png",
              width: 75.0,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            resident.ownerName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            resident.residentialBlock.name,
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TowerApartmentInfo(
                title: "Int/Torre",
                description: '${resident.tower}',
                imageAsset: "assets/tower_icon.png",
              ),
              TowerApartmentInfo(
                title: "Apto/Casa",
                description: '${resident.apartment}',
                imageAsset: "assets/apartment_icon.png",
              ),
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

/// Clase conteniendo información de apartamento/casa y torre/interior del residente
class TowerApartmentInfo extends StatelessWidget {
  TowerApartmentInfo(
      {@required this.imageAsset,
      @required this.title,
      @required this.description});

  final String title;
  final String description;
  final String imageAsset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imageAsset,
          width: 40,
        ),
        SizedBox(
          width: 15,
        ),
        Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              description,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ],
    );
  }
}
