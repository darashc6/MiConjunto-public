import 'package:flutter/material.dart';
import 'package:mi_conjunto_guardas/provider_models/residential_block_provider.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart' as AppColors;

/// Clase conteniendo información acerca del residente
class ProfileInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _residentialBlockData = context.watch<ResidentialBlockProvider>();

    return Container(
      width: double.infinity,
      color: AppColors.lightBlack,
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(
                  "assets/guard_avatar.png",
                  width: 75.0,
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            _residentialBlockData.getResidentialBlock.email,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              _residentialBlockData.getResidentialBlock.name,
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
