import 'package:mi_conjunto_residentes/models/public_company.dart';

/// Modelo de 'recibo'
class Receipt {
  int receiptId;
  String receptionDate;
  String deliveryDate;
  String notes;
  PublicCompany publicCompany;

  Receipt(
      {this.receiptId,
      this.receptionDate,
      this.deliveryDate,
      this.notes,
      this.publicCompany});

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
        receiptId: json["receiptId"],
        receptionDate: json["receptionDate"],
        deliveryDate: json["deliveryDate"],
        notes: json["notes"],
        publicCompany: PublicCompany.fromJson(json["PublicCompany"]));
  }
}
