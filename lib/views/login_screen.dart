import 'package:bayer/costante/export.dart';
import 'package:bayer/views/home_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Suivi de la sélection
  String _selectedRole = 'owner'; // 'owner' ou 'tenant'

  Future<void> _loginAsOwner() async {
    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      EasyLoading.showInfo("Verifier vos informations");
      return;
    }

    final sqliteManager = SqliteManager();
    var users =
        await sqliteManager.query('users', where: 'email=?', whereArgs: [
      emailController.text.trim(),
    ]);
    if (users.isNotEmpty) {}

    // Get.off(() => const HomeView()); // TODO ideal
    Get.to(
      () => const HomeView(),
      curve: Curves.bounceInOut,
      transition: Transition.zoom,
      opaque: true,
    );
  }

  void _loginAsTenant() {
    // Get.off(() => const TenantDashboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Rensponsive(
        desktop: Center(
          child: TextButton(
            onPressed: _loginAsOwner,
            child: const Text("Desktop Login"),
          ),
        ),
        tablet: const Center(),
        mobile: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.blueGrey[50],
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.asset('assets/images/logo.png')),
                    // const Icon(
                    //   Iconsax.login_1_outline,
                    //   size: 100,
                    //   color: Color(0xFF448AFF),
                    // ),
                    const SizedBox(height: 16),
                    const Text(
                      'Bienvenue',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connectez-vous pour continuer',
                      style: TextStyle(
                          fontSize: 16,
                          // color: Colors.grey,
                          fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(23, 4, 72, 30),
                        borderRadius: BorderRadius.circular(12),
                        // border: Border.all(color: Colors.blueAccent),
                      ),
                      child: Row(
                        children: [
                          // Conteneur Propriétaire

                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selectedRole = 'owner');
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _selectedRole == 'owner'
                                      ? AppColors.primary
                                      : null,
                                  borderRadius: BorderRadius.circular(12),
                                  // border: Border.all(color: Colors.blueAccent),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Propriétaire',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _selectedRole == 'owner'
                                        ? AppColors.primaryLight
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Conteneur Locataire
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selectedRole = 'tenant');
                                _loginAsTenant(); // appel existant
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _selectedRole == 'tenant'
                                      ? AppColors.primary
                                      : null,
                                  borderRadius: BorderRadius.circular(12),
                                  // border: Border.all(color: Colors.blueAccent),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Locataire',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _selectedRole == 'tenant'
                                        ? AppColors.primaryLight
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.message_outline),
                        labelText: 'Email',
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.key),
                        labelText: 'Mot de passe',
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyButton(
                        label: 'Connexion',
                        height: 40,
                        fontSize: 19,
                        borderSize: 50,
                        onTap: _loginAsOwner)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
