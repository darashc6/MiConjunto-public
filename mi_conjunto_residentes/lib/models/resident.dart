import 'package:mi_conjunto_residentes/models/residential_block.dart';

/// Modelo de 'residente'
class Resident {
  int residentId;
  String email;
  int tower;
  int apartment;
  String deviceToken;
  String phoneNumber1;
  String phoneNumber2;
  String phoneNumber3;
  String ownerName;
  bool parkingActive;
  String webPage;
  ResidentialBlock residentialBlock;

  Resident(
      {this.residentId,
      this.email,
      this.tower,
      this.apartment,
      this.deviceToken,
      this.phoneNumber1,
      this.phoneNumber2,
      this.phoneNumber3,
      this.ownerName,
      this.parkingActive,
      this.webPage,
      this.residentialBlock});

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
        residentId: json["residentId"],
        email: json["email"],
        tower: json["tower"],
        deviceToken: json["deviceToken"],
        apartment: json["apartment"],
        phoneNumber1: json["phoneNumber1"],
        phoneNumber2: json["phoneNumber2"],
        phoneNumber3: json["phoneNumber3"],
        ownerName: json["ownerName"],
        parkingActive: json["parkingActive"],
        webPage: json["webPage"],
        residentialBlock: ResidentialBlock.fromJson(json["ResidentialBlock"]));
  }

  set setDeviceToken(String deviceToken) => this.deviceToken = deviceToken;
}
