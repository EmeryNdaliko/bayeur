enum LocationStatut { enAttente, active, termine }

class LocationModel {
  String id = '';
  String locataireId = '';
  String proprieteId = '';
  DateTime dateDebut = DateTime.now();
  DateTime dateFin = DateTime.now();
  double locationPrix = 0.0;
  LocationStatut statut = LocationStatut.enAttente;
  DateTime created = DateTime.now();
  DateTime updated = DateTime.now();

  LocationModel();
  LocationModel.build({
    required this.id,
    required this.locataireId,
    required this.proprieteId,
    required this.dateDebut,
    required this.dateFin,
    required this.locationPrix,
    required this.statut,
    required this.created,
    required this.updated,
  });

  factory LocationModel.fromJson(Map<String, dynamic> data) =>
      LocationModel.build(
        id: data['location_id'] ?? '',
        locataireId: data['locataire_id'] ?? '',
        proprieteId: data['propriete_id'] ?? '',
        dateDebut: DateTime.parse(data['date_debut'].toString()),
        dateFin: DateTime.parse(data['date_fin'].toString()),
        locationPrix: double.tryParse(data['loyer_mensuel'].toString()) ?? 0.0,
        statut: LocationStatut.values.byName(data['statut']),
        created: DateTime.parse(data['created_at'].toString()),
        updated: DateTime.parse(data['updated_at'].toString()),
      );

  Map<String, dynamic> get toJson {
    return {
      'location_id': id,
      'locataire_id': locataireId,
      'propriete_id': proprieteId,
      'date_debut': dateDebut.toIso8601String(),
      'date_fin': dateFin.toIso8601String(),
      'loyer_mensuel': locationPrix,
      'statut': statut.name,
      'created_at': created.toIso8601String(),
      'updated_at': updated.toIso8601String(),
    };
  }
}
