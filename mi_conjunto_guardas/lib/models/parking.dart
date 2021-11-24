
/// Modelo de 'control_parqueadero'
class Parking {
  int parkingId;
  String entryDate;
  String exitDate;
  int nParking;
  String numberPlate;
  String notes;
  int chargingRate;

  Parking(
      {this.parkingId,
      this.entryDate,
      this.exitDate,
      this.nParking,
      this.numberPlate,
      this.notes,
      this.chargingRate});

  factory Parking.fromJson(Map<String, dynamic> json) {
    return Parking(
        parkingId: json["controlParkingId"],
        entryDate: json["entryDate"],
        exitDate: json["exitDate"],
        nParking: json["nParking"],
        numberPlate: json["numberPlate"],
        notes: json["notes"],
        chargingRate: json["chargingRate"]);
  }
}
