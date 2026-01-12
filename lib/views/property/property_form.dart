import 'package:bayer/costante/export.dart';
import 'package:bayer/models/property_model.dart';

class PropertyForm extends StatefulWidget {
  final PropertyModel? property;
  final VoidCallback onSave;
  const PropertyForm({super.key, this.property, required this.onSave});

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
    adresseController = TextEditingController(text: widget.property?.adresse);
    descriptionController =
        TextEditingController(text: widget.property?.description);
    if (widget.property != null) {
      type = widget.property?.type;
      selectedIndex = widget.property!.type.index;
    }
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

    if (widget.property != null) {
      if (await property.update()) {
        EasyLoading.showSuccess('Proprieté modifié');
        widget.onSave();
      } else {
        EasyLoading.showError('Impossible de mettre a jour la propriete');
      }
      return;
    } else {
      if (await property.insert()) {
        EasyLoading.showSuccess('Proprieté ajouté');
        widget.onSave();
      } else {
        EasyLoading.showError('Impossible d\'ajouter une propriete');
      }
    }
  }

  int selectedIndex = 0;

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
            Text(
              widget.property == null
                  ? 'Nouvelle propriété'
                  : "Modifier la propriété",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Row(
                // runSpacing: 5,
                spacing: 5,
                children: List.generate(
                    TypePropriete.values.length,
                    (index) => ChoiceChip(
                        selectedColor: AppColors.blue,
                        elevation: 0,
                        onSelected: (value) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        label: TypePropriete.values[index].name.text,
                        selected: selectedIndex == index))),
            TextFormField(
              validator: (value) =>
                  value!.isEmpty ? 'ce champs est requis' : null,
              controller: designationController,
              decoration: const InputDecoration(
                isDense: true,
                hint: Text('Designation'),
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              validator: (value) =>
                  value!.isEmpty ? 'ce champs est requis' : null,
              controller: prixController,
              decoration: const InputDecoration(
                isDense: true,
                hint: Text('Prix'),
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              validator: (value) =>
                  value!.isEmpty ? 'ce champs est requis' : null,
              controller: adresseController,
              decoration: const InputDecoration(
                isDense: true,
                hint: Text('Adresse'),
                border: OutlineInputBorder(),
              ),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                isDense: true,
                hint: Text('Description(facultatif)'),
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            MyButton(
              label: widget.property == null ? 'Enregister' : 'Modifier',
              onTap: onSubmit,
              borderSize: 50,
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
