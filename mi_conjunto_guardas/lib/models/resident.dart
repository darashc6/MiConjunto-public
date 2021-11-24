

/// Modelo de 'residente'
class Resident {
  int residentId;
  String email;
  int tower;
  int apartment;
  String phoneNumber1;
  String phoneNumber2;
  String phoneNumber3;
  String ownerName;
  bool parkingActive;

  Resident({
    this.residentId,
    this.email,
    this.tower,
    this.apartment,
    this.phoneNumber1,
    this.phoneNumber2,
    this.phoneNumber3,
    this.ownerName,
    this.parkingActive,
  });

  factory Resident.fromJson(Map<String, dynamic> json) {
    return Resident(
        residentId: json["residentId"],
        email: json["email"],
        tower: json["tower"],
        apartment: json["apartment"],
        phoneNumber1: json["phoneNumber1"],
        phoneNumber2: json["phoneNumber2"],
        phoneNumber3: json["phoneNumber3"],
        ownerName: json["ownerName"],
        parkingActive: json["parkingActive"]);
  }
}
