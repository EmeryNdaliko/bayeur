import 'package:bayer/costante/export.dart';
import 'package:bayer/main.dart';

class LocataireModel {
  int? id;
  String nom = '';
  String email = '';
  String password = '';
  String adresse = '';
  // TypeUser type = TypeUser.locataire;
  LocataireModel();

  LocataireModel.build({
    this.id,
    required this.nom,
    required this.email,
    required this.adresse,
    required this.password,
    // required this.type,
  });

  factory LocataireModel.fromJson(Map<String, dynamic> data) {
    return LocataireModel.build(
      id: data['locataire_id'],
      nom: data['nom'] ?? '',
      email: data['email'] ?? '',
      adresse: data['adresse'] ?? '',
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
      'password': password,
      // 'type': type.name,
    };
  }

  Future<void> insert() async {
    EasyLoading.show(
        status: 'Patientez...', maskType: EasyLoadingMaskType.black);
    var success = await api.postData('locataire/insert', toJson());
    logger.i(toJson());
    if (success) {
      EasyLoading.showSuccess('Ajout du locataire reussi');
    } else {
      EasyLoading.showError('Echec d\'ajout du locataire');
    }
  }
}
