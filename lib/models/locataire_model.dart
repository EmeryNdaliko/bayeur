class LocataireModel {
  String? id;
  String nom = '';
  String email = '';
  String password = '';
  // TypeUser type = TypeUser.locataire;
  LocataireModel();

  LocataireModel.build({
    this.id,
    required this.nom,
    required this.email,
    required this.password,
    // required this.type,
  });

  factory LocataireModel.fromJson(Map<String, dynamic> data) {
    return LocataireModel.build(
      id: data['locataire_id'],
      nom: data['nom'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
    );
    // type: TypeUser.values.byName(data['type']));
  }

  Map<String, dynamic> toJson() {
    return {
      'locataire_id': id,
      'nom': nom,
      'email': email,
      'password': password,
      // 'type': type.name,
    };
  }
}
