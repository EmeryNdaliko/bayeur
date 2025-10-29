enum TypeUser {
  bayeur,
  locataire,
}

class UserModel {
  String? id;
  String userNme = '';
  String email = '';
  String password = '';
  TypeUser type = TypeUser.locataire;
  UserModel();

  UserModel.build({
    this.id,
    required this.userNme,
    required this.email,
    required this.password,
    required this.type,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel.build(
        id: data['id'],
        userNme: data['userNme'] ?? '',
        email: data['email'] ?? '',
        password: data['password'] ?? '',
        type: TypeUser.values.byName(data['type']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userNme': userNme,
      'email': email,
      'password': password,
      'type': type.name,
    };
  }
}
