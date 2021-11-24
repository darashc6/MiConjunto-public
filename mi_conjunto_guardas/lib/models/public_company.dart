
/// Modelo de 'empresa_servicio_publico'
class PublicCompany {
  int publicCompanyId;
  String name;

  PublicCompany({this.publicCompanyId, this.name});

  factory PublicCompany.fromJson(Map<String, dynamic> json) {
    return PublicCompany(
        publicCompanyId: json["publicCompanyId"], name: json["name"]);
  }
}