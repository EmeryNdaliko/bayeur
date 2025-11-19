import 'dart:convert';
import 'package:bayer/costante/export.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  static ApiHelper? _instance;
  final String baseUrl;
  static bool _isConnected = false;

  /// Constructeur privé
  ApiHelper._internal({required this.baseUrl});

  /// Accès global (singleton)
  factory ApiHelper({required String baseUrl}) {
    _instance ??= ApiHelper._internal(baseUrl: baseUrl);
    return _instance!;
  }

  /// Méthode d'initialisation unique
  Future<void> initConnection() async {
    if (_isConnected) {
      logger.i("🔄 Connexion déjà initialisée");
      return;
    }

    final connected = await _connect();
    if (connected) {
      _isConnected = true;
      logger.i("✅ Connexion initialisée avec succès");
    } else {
      logger.i("⚠️ Échec d'initialisation de la connexion");
    }
  }

  /// Méthode privée de connexion à l'API
  Future<bool> _connect() async {
    try {
      final url = Uri.parse('$baseUrl/ping');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        logger.i("✅ Connexion à l'API réussie");
        return true;
      } else {
        logger.i("⚠️ Erreur de connexion : ${response.statusCode}");
        return false;
      }
    } catch (e) {
      logger.i("❌ Erreur de connexion : $e");
      return false;
    }
  }

  /// Requête POST générique
  Future<bool> postData(
      String endpoint, Map<String, dynamic> data) async {
    if (!_isConnected) await initConnection();

    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      logger.w(response.request?.url);
      logger.w(response.body);

      if (response.statusCode == 200) {
        var decodedRes = jsonDecode(response.body);
        EasyLoading.showToast(decodedRes['message']);

        return true;
      } else {
        EasyLoading.showToast('errueur d\'ajout du locataire');
        logger.e('Erreur POST: ${response.statusCode}');
           return false;
        
      }
    } catch (e) {
      
      logger.e('Erreur POST: $e');
         return false;
   
    }
  }

  /// Requête GET générique
  Future<List<dynamic>?> getData(String endpoint) async {
    if (!_isConnected) await initConnection();

    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      final response = await http.get(url);
      logger.w(response.request?.url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        logger.i('Erreur GET: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.i('Erreur GET: $e');
      return null;
    }
  }
}
