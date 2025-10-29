import 'package:bayer/rensponsive/rensponsive.dart';
import 'package:bayer/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Suivi de la sélection
  String? _selectedRole; // 'owner' ou 'tenant'

  void _loginAsOwner() {
    Get.off(() => const HomeView());
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
            child: Text("Desktop Login"),
            onPressed: _loginAsOwner,
          ),
        ),
        tablet: const Center(),
        mobile: Scaffold(
          backgroundColor: Colors.blueGrey[50],
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Iconsax.login_1_outline,
                    size: 100,
                    color: Color(0xFF448AFF),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Bienvenue',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connectez-vous pour continuer',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      labelText: 'Mot de passe',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      // Conteneur Propriétaire
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() => _selectedRole = 'owner');
                            _loginAsOwner(); // appel existant
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: _selectedRole == 'owner'
                                  ? Colors.blueAccent
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blueAccent),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Propriétaire',
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedRole == 'owner'
                                    ? Colors.white
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
                            height: 50,
                            decoration: BoxDecoration(
                              color: _selectedRole == 'tenant'
                                  ? Colors.blueAccent
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blueAccent),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Locataire',
                              style: TextStyle(
                                fontSize: 16,
                                color: _selectedRole == 'tenant'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
