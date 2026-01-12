import 'dart:convert';

import 'package:bayer/services/cache_manager.dart';

import '../main.dart';

enum TypeUser {
  proprietaire,
  locataire,
  defoult,
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

  bool get isDefault =>
      (email == 'admin@bayeur.com' && password == 'bayeur') ||
      (email == 'emeryndalos@gmail.com' && password == 'bayeur');
  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel.build(
        id: data['user_id'] ?? '',
        userNme: data['user_name'] ?? '',
        email: data['email'] ?? '',
        password: data['password'] ?? '',
        type: TypeUser.values.byName(data['type']));
  }

  @override
  String toString() {
    return userNme;
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

  Future<bool> connect() async {
    try {
      final data = jsonEncode(toJson());
      logger.t('User connected successfull');
      return await CacheManager.user.write(data);
    } catch (e) {
      logger.e('Failed to connect user : Error : $e');
      return false;
    }
  }

  Future<bool> disconnect() async {
    try {
      return await CacheManager.user.remove();
    } catch (e) {
      logger.e('Failed to desconnect user : Error : $e');
      return false;
    }
  }

  static UserModel? get current {
    final data = CacheManager.user.read();
    if (data.isEmpty) {
      return null;
    }
    return UserModel.fromJson(jsonDecode(data));
  }
}

extension CustomStringExt on String {
  String get crypted {
    List<int> bytes = utf8.encode(this);
    return base64.encode(bytes);
  }

  String get decrypted {
    try {
      List<int> bytes = base64.decode(this);
      String decodedText = utf8.decode(bytes);
      return decodedText;
    } catch (e) {
      return this + ('#}{#');
    }
  }
}
