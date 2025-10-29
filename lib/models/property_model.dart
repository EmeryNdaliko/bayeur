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
  String adresse = '';
  double? surface;
  int nbchambre = 0;
  StatutPropriete statut = StatutPropriete.disponible;
  DateTime? createdAt;

  PropertyModel();
  PropertyModel.build({
    this.id,
    required this.type,
    required this.adresse,
    this.surface,
    this.statut = StatutPropriete.disponible,
    required this.nbchambre,
    this.createdAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> data) {
    return PropertyModel.build(
        id: data['id'],
        type: TypePropriete.values.byName(data['type']),
        adresse: data['adresse'] ?? '',
        nbchambre: int.tryParse(data['nbchambre'].toString()) ?? 0,
        surface: data['surface'] ?? '',
        statut: StatutPropriete.values.byName(data['statut']),
        createdAt: DateTime.tryParse(data['created']));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'adresse': adresse,
        'surface': surface,
        'nbchambre': nbchambre,
        'statut': statut.name,
        'created': createdAt
      };
}
