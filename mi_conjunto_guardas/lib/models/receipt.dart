import 'public_company.dart';

/// Modelo de 'recibo'
class Receipt {
  int receiptId;
  String receptionDate;
  String deliveryDate;
  String notes;
  bool checked;
  PublicCompany publicCompany;

  Receipt(
      {this.receiptId,
      this.receptionDate,
      this.deliveryDate,
      this.notes,
      this.checked,
      this.publicCompany});

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
        receiptId: json["receiptId"],
        receptionDate: json["receptionDate"],
        deliveryDate: json["deliveryDate"],
        notes: json["notes"],
        checked: false,
        publicCompany: PublicCompany.fromJson(json["PublicCompany"]));
  }
}
