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
  enconstruction,
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
        id: data['propriete_id'],
        designation: data['designation'],
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
    final SqliteManager database = SqliteManager();
    var result = await database.insert('proprietes', toJson());

    if (result > 0) {
      return true;
    }
    return false;
  }
}
