
/// Modelo de 'servicio_empresa_publica'
class PublicCompany {
  int publicCompanyId;
  String name;

  PublicCompany({this.publicCompanyId, this.name});

  factory PublicCompany.fromJson(Map<String, dynamic> json) {
    return PublicCompany(
        publicCompanyId: json["publicCompanyId"], name: json["name"]);
  }
}
