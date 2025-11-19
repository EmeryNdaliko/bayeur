class RensponseModel {
  String title = '';
  String message = '';
  int statut = 0;
  String appName = '';
  String appVersion = '';

  RensponseModel();
  RensponseModel.build({
    required this.title,
    required this.message,
    required this.statut,
  });
  factory RensponseModel.fromJson(Map<String, dynamic> data) {
    return RensponseModel.build(
      title: data['title'],
      message: data['message'],
      statut: data['statut'],
    );
  }

  Map<String, dynamic> get toJson => {
        'title': title,
        'message': message,
        "statut": statut,
      };
}
