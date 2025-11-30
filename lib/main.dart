import 'dart:io';
import 'package:bayer/costante/export.dart';
import 'package:bayer/views/login_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// final api = ApiHelper(baseUrl: 'http://192.168.101.1/bayeur_api');
final api = ApiHelper(baseUrl: 'http://localhost/bayeur_api');

/** TODO Splash Screen 
 *  return AnimatedSplashScreen(
      splash: 'images/splash.png',
      nextScreen: MainScreen(),
      splashTransition: SplashTransition.rotationTransition,
      pageTransitionType: PageTransitionType.scale,
    );
 */

Future<void> initApplication() async {
  // Initialisation widgets Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation SQLite selon la plateforme
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  } else {
    databaseFactory = databaseFactory;
  }

  // Ouverture SQLite via ton manager
  final sqliteManager = SqliteManager();
  await sqliteManager.open();
}

void main() async {
  await initApplication(); // Appel de la fonction d’installation
  runApp(const BayeurApp());
}

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 50,
    colors: true,
    printEmojis: true,
  ),
);
var uuid = const Uuid();

class BayeurApp extends StatelessWidget {
  const BayeurApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      title: 'BAYEUR',
      theme: ThemeData(
        // colorScheme: const ColorScheme.highContrastDark(),
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryLightAccent,
          foregroundColor: AppColors.primary,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.black,
        ),
        textTheme: GoogleFonts.ralewayTextTheme(),
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
