import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bayer/costante/export.dart';

class LocataireModel {
  var uuid = const Uuid();
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

  Map<String, dynamic>  toJson() {
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

  Future<List<Map<dynamic, dynamic>>> getAllPaiements() async {
    SqliteManager db = SqliteManager();
    return await db.execute(query: '''
            SELECT max(montant) FROM paiements paie 
            INNER JOIN locations 
            ON paie.location_id=locations.location_id 
            WHERE locations.locataire_id=? 
            ''', args: [id]);
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

      var res = await db.execute(query: '''
        SELECT * FROM locataires loc 
        INNER JOIN location on location.locataire_id = loc.locataire_id 
        INNER JOIN proprietes prop ON location.propriete_id = prop.propriete_id
        WHERE location.locataire_id =?
        ''', args: [id]);

      if (res.isNotEmpty) {
        logger.i(res.map((e) => e));

        var context = Get.context;
        AwesomeDialog(
                width: 400,
                title: 'Suppression',
                desc: 'Erreur de supression\nCet locataire a deja une location',
                context: context!,
                dialogType: DialogType.error,
                autoHide: 2.seconds)
            .show();

        return false;
      }

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

  static Future<LocataireModel?> getLocataireById(String id) async {
    var sql = SqliteManager();
    var result =
        await sql.query('locataires', where: 'locataire_id=?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return LocataireModel.fromJson(result.first);
    }
    return null;
  }
}
