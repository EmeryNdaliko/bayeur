import 'package:bayer/costante/export.dart';

class LocataireForm extends StatefulWidget {
  final LocataireModel? locataire;
  final VoidCallback onSave;
  const LocataireForm({
    super.key,
    this.locataire,
    required this.onSave,
  });

  @override
  State<LocataireForm> createState() => _LocataireFormState();
}

class _LocataireFormState extends State<LocataireForm> {
  late TextEditingController nomController;
  late TextEditingController emailController;
  late TextEditingController adresseController;
  late TextEditingController passwordController;

  void initialise() {
    nomController = TextEditingController(text: widget.locataire?.nom);
    emailController = TextEditingController(text: widget.locataire?.email);
    adresseController = TextEditingController(text: widget.locataire?.adresse);
    passwordController =
        TextEditingController(text: widget.locataire?.password);
  }

  @override
  void initState() {
    initialise();
    super.initState();
  }

  final formKey = GlobalKey<FormState>();
  Future<void> onSubmit() async {
    if (!formKey.currentState!.validate()) {
      EasyLoading.showError('Remplissez tous les champs');
      return;
    }

    final locataire = LocataireModel.build(
      nom: nomController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      adresse: adresseController.text.trim(),
    );
    if (widget.locataire == null) {
      locataire.insert();
      Get.back();
      widget.onSave();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.locataire == null
                ? "Nouveau Locataire"
                : "Modifier le locataire",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          Expanded(
            child: Form(
              key: formKey,
              child: Column(
                spacing: 5,
                children: [
                  TextFormField(
                    controller: nomController,
                    validator: (value) => value!.isEmpty
                        ? "Entrer un nomController valide"
                        : null,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.user_outline),
                        hintText: "Noms",
                        isDense: true,
                        border: OutlineInputBorder()),
                  ),
                  TextFormField(
                    controller: emailController,
                    validator: (value) =>
                        value!.isEmpty ? "Entrer un email valide" : null,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.message_2_outline),
                        hintText: "Email",
                        isDense: true,
                        border: OutlineInputBorder()),
                  ),
                  TextFormField(
                    controller: adresseController,
                    validator: (value) =>
                        value!.isEmpty ? "Entrer une adresse valide" : null,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_city_outlined),
                        hintText: "adresse",
                        isDense: true,
                        border: OutlineInputBorder()),
                  ),
                  TextFormField(
                    controller: passwordController,
                    validator: (value) =>
                        value!.isEmpty ? "Entrer un mot de passe valide" : null,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.key),
                        hintText: "Mot de passe",
                        isDense: true,
                        border: OutlineInputBorder()),
                  ),
                  MyButton(
                    borderSize: 50,
                    spacing: 10,
                    label: 'Entregistrer',
                    icon: Icons.check,
                    onTap: onSubmit,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
