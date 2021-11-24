

/// Modelo de 'conjunto_residencial'
class ResidentialBlock {
  final int residentialBlockId;
  final String email;
  final String name;

  ResidentialBlock({this.residentialBlockId, this.email, this.name});

  factory ResidentialBlock.fromJson(Map<String, dynamic> json) {
    return ResidentialBlock(
        residentialBlockId: json["residentialBlockId"],
        email: json["email"],
        name: json["name"]);
  }
}
