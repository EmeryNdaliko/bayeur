import 'package:bayer/costante/export.dart';
import 'package:bayer/services/api.dart';
import 'package:logger/logger.dart';

// final api = ApiHelper(baseUrl: 'http://192.168.101.1/bayeur_api');
final api = ApiHelper(baseUrl: 'http://localhost/bayeur_api');
void main() async {
  await api
      .initConnection(); //  Initialisation de la connexion api -> une seule fois

  // final locataires = await api.getData('locataire/list');
  // if (locataires != null) {
  //   logger.i("Données locataires reçues : $locataires");
  // }

  runApp(const BayeurApp());
}

var logger = Logger();

class BayeurApp extends StatelessWidget {
  const BayeurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      title: 'BAYEUR',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.black,
        ),
        textTheme: GoogleFonts.ralewayTextTheme(),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
