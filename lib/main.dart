import 'dart:io';
import 'package:bayer/costante/export.dart';
import 'package:bayer/services/cache_manager.dart';
import 'package:bayer/views/login_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_size/window_size.dart';

// final api = ApiHelper(baseUrl: 'http://192.168.101.1/bayeur_api');
final api = ApiHelper(baseUrl: 'http://localhost/bayeur_api');

Future<void> initApplication() async {
  // Initialisation widgets Flutter
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefManager().init();
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
  setWindowTitle('Bayeur');
  setWindowMinSize(const Size(502.7, 1000));
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
          // textTheme: GoogleFonts.ralewayTextTheme(),
          fontFamily: 'raleway'),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


//TODO CHANGER LA POLICE EN DMSANS