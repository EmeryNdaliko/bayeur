import 'package:bayer/costante/export.dart';

class LocataireModel {
  var uuid = Uuid();
  String id = '';
  String nom = '';
  String email = '';
  String password = '';
  String adresse = '';
  String telephone = '';
  // TypeUser type = TypeUser.locataire;
  LocataireModel();

  SqliteManager db = SqliteManager();
  String get generateId => uuid.v4();

  LocataireModel.build({
    required this.id,
    required this.nom,
    required this.email,
    required this.adresse,
    required this.password,
    required this.telephone,
  });

  factory LocataireModel.fromJson(Map<String, dynamic> data) {
    return LocataireModel.build(
      id: data['locataire_id'],
      nom: data['nom'] ?? '',
      email: data['email'] ?? '',
      adresse: data['adresse'] ?? '',
      telephone: data['telephone'] ?? '',
      password: data['password'] ?? '',
    );
    // type: TypeUser.values.byName(data['type']));
  }

  Map<String, dynamic> toJson() {
    return {
      'locataire_id': id,
      'nom': nom,
      'email': email,
      'adresse': adresse,
      'telephone': telephone,
      'password': password,
      // 'type': type.name,
    };
  }

  Future<bool> insert() async {
    try {
      SqliteManager db = SqliteManager();

      EasyLoading.show(
          status: 'Patientez...', maskType: EasyLoadingMaskType.black);
      // var success = await api.postData('locataire/insert', toJson());
      var success = await db.insert('locataires', toJson());

      if (success > 0) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      EasyLoading.showError('Erreur : $e');
      logger.e(e);
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> update() async {
    try {
      SqliteManager db = SqliteManager();

      EasyLoading.show(
          status: 'Patientez...', maskType: EasyLoadingMaskType.black);
      // var success = await api.postData('locataire/insert', toJson());
      var success = await db.update(
        table: 'locataires',
        values: toJson(),
        where: 'locataire_id =?',
        whereArgs: [id],
      );

      if (success > 0) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      EasyLoading.showError('Erreur : $e');
      logger.e(e);
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<bool> delete() async {
    try {
      EasyLoading.show(
          status: 'Patientez...', maskType: EasyLoadingMaskType.black);
      // var success = await api.postData('locataire/insert', toJson());
      var success = await db.delete(
        table: 'locataires',
        where: 'locataire_id =?',
        whereArgs: [id],
      );

      if (success > 0) {
        logger.t("suppression : $success");
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      EasyLoading.showError('Erreur : $e');
      logger.e(e);
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
