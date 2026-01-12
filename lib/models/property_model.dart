import 'package:bayer/costante/export.dart';

enum TypePropriete {
  maison,
  appartement,
  studio,
  bureau,
  magasin,
  terrain,
  entrepot
}

enum StatutPropriete {
  disponible,
  occupe,
  enconstruction;

  void update() {
    SqliteManager db = SqliteManager();
    db.update(
        table: 'proprietes',
        values: {'statut': 'occupe'},
        where: 'propriete_id=?',
        whereArgs: []);
  }
}

class PropertyModel {
  String? id;
  TypePropriete type = TypePropriete.maison;
  String designation = '';
  String adresse = '';
  double prix = 0.0;
  String description = '';
  StatutPropriete statut = StatutPropriete.disponible;
  DateTime? createdAt;
  final SqliteManager database = SqliteManager();

  PropertyModel();
  PropertyModel.build({
    this.id,
    required this.designation,
    required this.type,
    required this.adresse,
    required this.prix,
    this.statut = StatutPropriete.disponible,
    required this.description,
    this.createdAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> data) {
    return PropertyModel.build(
        id: data['propriete_id'] ?? '',
        designation: data['designation'] ?? '',
        type: TypePropriete.values.byName(data['type']),
        adresse: data['adresse'] ?? '',
        description: data['nbchambre'] ?? '',
        prix: double.tryParse(data['prix'].toString()) ?? 0.0,
        statut: StatutPropriete.values.byName(data['statut']),
        createdAt: DateTime.tryParse(data['created_at']));
  }

  Map<String, dynamic> toJson() => {
        'propriete_id': id,
        'designation': designation,
        'type': type.name,
        'adresse': adresse,
        'prix': prix,
        'description': description,
        'statut': statut.name,
        'created_at': createdAt?.toIso8601String()
      };

  Future<bool> insert() async {
    var result = await database.insert('proprietes', toJson());
    if (result > 0) {
      return true;
    }
    return false;
  }

  Future<bool> update() async {
    var result = await database.update(
        table: 'proprietes',
        values: toJson(),
        where: 'propriete_id=?',
        whereArgs: [id]);

    if (result > 0) {
      return true;
    }
    return false;
  }

  Future<bool> delete() async {
    try {
      EasyLoading.show(
          status: 'Patientez...', maskType: EasyLoadingMaskType.black);
      // var success = await api.postData('locataire/insert', toJson());
      var success = await database.delete(
        table: 'proprietes',
        where: 'propriete_id=?',
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

  static Future<PropertyModel?> getPropertyById(String id) async {
    var sql = SqliteManager();
    var result =
        await sql.query('proprietes', where: 'propriete_id=?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return PropertyModel.fromJson(result.first);
    }
    return null;
  }
}
