

/// Modelo de 'conjunto_residencial'
class ResidentialBlock {
  int residentialBlockId;
  String name;

  ResidentialBlock({this.residentialBlockId, this.name});

  factory ResidentialBlock.fromJson(Map<String, dynamic> json) {
    return ResidentialBlock(
        residentialBlockId: json["residentialBlockId"], name: json["name"]);
  }
}
