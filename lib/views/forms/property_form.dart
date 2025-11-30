import 'package:bayer/costante/app_colors.dart';
import 'package:bayer/costante/export.dart';
import 'package:bayer/models/property_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PropertyForm extends StatefulWidget {
  final PropertyModel? property;
  const PropertyForm({super.key, this.property});

  @override
  State<PropertyForm> createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {
  late TextEditingController designationController;
  late TextEditingController prixController;
  late TextEditingController adresseController;
  late TextEditingController descriptionController;
  TypePropriete? type = TypePropriete.maison;
  final formKey = GlobalKey<FormState>();

  void initialise() {
    designationController =
        TextEditingController(text: widget.property?.designation);
    prixController =
        TextEditingController(text: widget.property?.prix.toString());
    adresseController =
        TextEditingController(text: widget.property?.designation);
    descriptionController =
        TextEditingController(text: widget.property?.description);
    type = widget.property?.type;
  }

  @override
  void initState() {
    super.initState();
    initialise();
  }

  Future<void> onSubmit() async {
    if (!formKey.currentState!.validate()) {
      EasyLoading.showInfo('Verifier vos informations');
      return;
    }

    var property = PropertyModel.build(
        id: widget.property == null ? uuid.v4() : widget.property?.id,
        designation: designationController.text.trim(),
        type: type ?? TypePropriete.maison,
        adresse: adresseController.text.trim(),
        prix: double.tryParse(prixController.text.trim().toString()) ?? 0.0,
        statut: StatutPropriete.disponible,
        description: descriptionController.text.trim(),
        createdAt: DateTime.now());
    if (await property.insert()) {
      EasyLoading.showSuccess('Proprieté ajouté');
    } else {
      EasyLoading.showError('Impossible d\'ajouter une propriete');
    }
  }

  int selectedIndex = 0;
  String selectedProperty = '';
  void onSeleceted(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            const BarreWidget(),
            const Text(
              'Nouvelle propriété',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Wrap(
              runSpacing: 5,
              spacing: 5,
              children: TypePropriete.values
                  .map((e) => InputChip(
                        selectedColor: AppColors.primary,
                        checkmarkColor:
                            selectedIndex == TypePropriete.values.indexOf(e)
                                ? AppColors.background
                                : null,
                        selected:
                            selectedIndex == TypePropriete.values.indexOf(e),
                        label: Text(
                          e.name.substring(0, 1).toUpperCase() +
                              e.name.substring(1),
                          style: TextStyle(
                              color: selectedIndex ==
                                      TypePropriete.values.indexOf(e)
                                  ? AppColors.background
                                  : null),
                        ),
                        onPressed: () {
                          onSeleceted(TypePropriete.values.indexOf(e));
                          setState(() {
                            selectedProperty = e.name;
                          });
                        },
                      ))
                  .toList(),
            ),
            TextField(
              controller: designationController,
              decoration: const InputDecoration(
                isDense: true,
                hint: Text('Designation'),
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: prixController,
              decoration: const InputDecoration(
                isDense: true,
                hint: Text('Prix'),
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: adresseController,
              decoration: const InputDecoration(
                isDense: true,
                hint: Text('Adresse'),
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                isDense: true,
                hint: Text('Description'),
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                // EasyLoading.showToast('Ajout propriété');
                onSubmit();
              },
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                    child: Text(
                  'Enregister',
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BarreWidget extends StatelessWidget {
  const BarreWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: 40,
      height: 5,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
    );
  }
}
