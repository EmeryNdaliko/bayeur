import 'package:bayer/costante/export.dart';

import 'package:bayer/models/location_model.dart';
import 'package:bayer/models/property_model.dart';

class NewLocation extends StatefulWidget {
  final VoidCallback onSave;
  final VoidCallback onBack;
  const NewLocation({super.key, required this.onSave, required this.onBack});

  @override
  State<NewLocation> createState() => _NewLocationState();
}

class _NewLocationState extends State<NewLocation> {
  var properties = <PropertyModel>[];
  PropertyModel? selectedProperty;

  var tenants = <LocataireModel>[];
  LocataireModel? selectedTenant;

  DateTime start = DateTime.now();
  DateTime end =
      DateTime.now().add(const Duration(days: 365)); // Default 1 year

  final searchController = TextEditingController();
  final priceController = TextEditingController();

  final SqliteManager sql = SqliteManager();

  @override
  void initState() {
    super.initState();
    loadTenants();
  }

  Future<void> loadTenants() async {
    var data = await sql.query('locataires');
    setState(() {
      tenants = data.map((e) => LocataireModel.fromJson(e)).toList();
    });
  }

  Future<void> searchProperty(String search) async {
    if (search.isEmpty) return;

    // Search by designation or address
    var data = await sql.execute(
        query:
            'SELECT * FROM proprietes WHERE (designation LIKE ? OR adresse LIKE ?) AND statut=?',
        args: ['%$search%', '%$search%', StatutPropriete.disponible.name]);

    setState(() {
      if (search.isEmpty) {
        properties = [];
      } else {
        properties = data
            .map((e) => PropertyModel.fromJson(e.cast<String, dynamic>()))
            .toList();
      }
    });
  }

  Future<void> saveLocation() async {
    if (selectedProperty == null || selectedTenant == null) {
      EasyLoading.showError(
          'Veuillez sélectionner une propriété et un locataire');
      return;
    }

    if (priceController.text.isEmpty) {
      EasyLoading.showError('Veuillez entrer un loyer');
      return;
    }

    try {
      EasyLoading.show(status: 'Enregistrement...');

      var location = LocationModel.build(
        id: const Uuid().v4(),
        locataireId: selectedTenant!.id,
        proprieteId: selectedProperty!.id!,
        dateDebut: start,
        dateFin: end,
        locationPrix: double.parse(priceController.text),
        statut: LocationStatut.active,
        created: DateTime.now(),
        updated: DateTime.now(),
      );

      await sql.insert('location', location.toJson);
      await sql.update(
          table: 'proprietes',
          values: {'statut': 'occupe'},
          where: 'propriete_id=?',
          whereArgs: [location.proprieteId]); // mise a jour de la proppriete

      // Optionally update property status to occupied
      // selectedProperty!.statut = StatutPropriete.occupe;
      // await selectedProperty!.update();

      EasyLoading.dismiss();
      EasyLoading.showSuccess('Location créée avec succès');
      widget.onSave();
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Erreur: $e');
      logger.e(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: const Scaffold(),
      tablet: const Scaffold(),
      desktop: Scaffold(
          appBar: AppBar(
            title: 'Nouvelle location'.textColor(fontweight: FontWeight.w600),
            leading: IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.keyboard_backspace)),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  if (selectedProperty == null) ...[
                    const Text(
                      'Rechercher une propriété',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary),
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        SizedBox(
                            width: 350,
                            child: SearchField(
                              controller: searchController,
                              onChanged: (String val) {
                                searchProperty(val);
                              },
                            )),
                        MyButton(
                          label: 'Rechercher',
                          width: 150,
                          bgColor: AppColors.black,
                          borderSize: 50,
                          onTap: () => searchProperty(searchController.text),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (properties.isEmpty && searchController.text.isNotEmpty)
                      const Text("Aucune propriété trouvée"),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: properties.length,
                      itemBuilder: (context, index) {
                        final prop = properties[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.home),
                            title: Text(prop.designation),
                            subtitle: Text('${prop.adresse} - ${prop.prix} \$'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedProperty = prop;
                                  priceController.text = prop.prix.toString();
                                });
                              },
                              child: const Text("Sélectionner"),
                            ),
                          ),
                        );
                      },
                    )
                  ] else ...[
                    // Selected Property Display
                    Card(
                      color: Colors.blue.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle,
                                color: Colors.green, size: 40),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(selectedProperty!.designation,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text(selectedProperty!.adresse),
                                  Text("${selectedProperty!.prix} \$ / mois",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  selectedProperty = null;
                                });
                              },
                              icon: const Icon(Icons.change_circle),
                              label: const Text("Changer"),
                            )
                          ],
                        ),
                      ),
                    ),

                    const Divider(),
                    const Text(
                      'Détails de la location',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                    ),

                    // Tenant Selection
                    SizedBox(
                      width: 400,
                      child: DropdownButtonFormField<LocataireModel>(
                        decoration: const InputDecoration(
                          labelText: 'Locataire',
                          border: OutlineInputBorder(),
                        ),

                        // value: selectedTenant,

                        items: tenants.map((t) {
                          return DropdownMenuItem(
                            value: t,
                            child: Text(t.nom),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedTenant = val;
                          });
                        },
                      ),
                    ),

                    // Dates
                    Row(
                      spacing: 20,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Date de début"),
                              const SizedBox(height: 5),
                              OutlinedButton.icon(
                                icon: const Icon(Icons.calendar_today),
                                label: Text(
                                    "${start.day}/${start.month}/${start.year}"),
                                onPressed: () async {
                                  final d = await showDatePicker(
                                    context: context,
                                    initialDate: start,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (d != null) setState(() => start = d);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Date de fin"),
                              const SizedBox(height: 5),
                              OutlinedButton.icon(
                                icon: const Icon(Icons.calendar_today),
                                label:
                                    Text("${end.day}/${end.month}/${end.year}"),
                                onPressed: () async {
                                  final d = await showDatePicker(
                                    context: context,
                                    initialDate: end,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (d != null) setState(() => end = d);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Price
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Loyer Mensuel',
                          border: OutlineInputBorder(),
                          suffixText: '\$',
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    MyButton(
                      label: 'Enregistrer la location',
                      width: 250,
                      onTap: saveLocation,
                    )
                  ],
                ],
              ),
            ),
          )),
    );
  }
}
