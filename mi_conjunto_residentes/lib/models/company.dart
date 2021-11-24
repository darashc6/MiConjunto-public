
/// Modelo de 'empresa'
class Company {
  int companyId;
  String name;

  Company({this.companyId, this.name});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(companyId: json["companyId"], name: json["name"]);
  }
}
