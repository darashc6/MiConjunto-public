import 'company.dart';

/// Modelo de 'encomienda'
class Package {
  int packageId;
  String receptionDate;
  String deliveryDate;
  String notes;
  bool checked;
  Company company;

  Package(
      {this.packageId,
      this.receptionDate,
      this.deliveryDate,
      this.notes,
      this.checked,
      this.company});

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
        packageId: json["packageId"],
        receptionDate: json["receptionDate"],
        deliveryDate: json["deliveryDate"],
        notes: json["notes"],
        checked: false,
        company: Company.fromJson(json["Company"]));
  }
}
