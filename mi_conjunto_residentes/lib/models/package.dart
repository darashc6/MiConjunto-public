import 'package:mi_conjunto_residentes/models/company.dart';

/// Modelo de 'encomienda'
class Package {
  int packageId;
  String receptionDate;
  String deliveryDate;
  String notes;
  Company company;

  Package(
      {this.packageId,
      this.receptionDate,
      this.deliveryDate,
      this.notes,
      this.company});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
        packageId: json["packageId"],
        receptionDate: json["receptionDate"],
        deliveryDate: json["deliveryDate"],
        notes: json["notes"],
        company: Company.fromJson(json["Company"]));
  }
}
