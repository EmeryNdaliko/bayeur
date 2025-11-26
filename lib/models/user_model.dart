enum TypeUser {
  proprietaire,
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
        id: data['user_id'],
        userNme: data['user_name'] ?? '',
        email: data['email'] ?? '',
        password: data['password'] ?? '',
        type: TypeUser.values.byName(data['type_user']));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_name': userNme,
      'email': email,
      'password': password,
      'type': type.name,
    };
  }
}
