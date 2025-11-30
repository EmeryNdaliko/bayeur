import 'package:bayer/costante/export.dart';
import 'package:bayer/widget/ask_yes_no_widget.dart';
import 'package:bayer/widget/dialog_widget.dart';

class LocataireView extends StatefulWidget {
  const LocataireView({super.key});

  @override
  State<LocataireView> createState() => _LocataireViewState();
}

class _LocataireViewState extends State<LocataireView> {
  List<LocataireModel> locataires = [];
  bool isLoading = false;
  SqliteManager db = SqliteManager();
  String query = '';
  final TextEditingController searchController = TextEditingController();

  Future<void> fetchData() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      // var data = await api.getData('locataire/list');
      var data = await db.query('locataires');
      locataires = data.map((e) => LocataireModel.fromJson(e)).toList();

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } on Exception catch (e) {
      EasyLoading.showError("Erreur : $e");
      logger.e("Erreur : $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void deleteLocataire(LocataireModel locataire) {
    Get.dialog(AskYesNoWidget(
      onConfirm: () async {
        await locataire.delete().then(
          (value) {
            if (value) {
              fetchData();
            }
          },
        );
      },
    ));
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void _showForm([LocataireModel? locataire]) {
    Get.dialog(
        DialogWidget(
            child: LocataireForm(
          onSave: fetchData,
          locataire: locataire,
        )),
        transitionCurve: Curves.bounceInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Rensponsive(
      desktop: Column(
        children: [
          /// --- En-tête avec barre de recherche et bouton ---
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                  width: 300,
                  child: SearchField(
                    controller: searchController,
                  )),
              const SizedBox(width: 10),
              MyButton(
                label: "Nouveau locataire",
                showIcon: false,
                width: 200,
                borderSize: 50,
                onTap: () => Get.dialog(DialogWidget(
                    child: LocataireForm(
                  onSave: fetchData,
                ))),
              ),
            ],
          ),
      
          const SizedBox(height: 20),
      
          /// --- Tableau ou État vide ---
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : locataires.isEmpty
                    ? const EmptyState(title: 'Aucun locataire trouvé')
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DataTable2(
                          minWidth: 900,
                          columnSpacing: 16,
                          horizontalMargin: 16,
                          dividerThickness: 1,
                          headingRowColor: WidgetStateProperty.all(
                              AppColors.primaryLight.withAlpha(20)),
                          headingTextStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.w900,
                                color: AppColors.primary,
                              ),
                          dataRowHeight: 40,
                          columns: const [
                            DataColumn2(label: Text('Noms')),
                            DataColumn2(label: Text('Email')),
                            DataColumn2(label: Text('Adresse')),
                            DataColumn2(label: Text('Téléphone')),
                            DataColumn2(label: Text('Actions')),
                          ],
                          rows: locataires
                              .map(
                                (locataire) => DataRow2(
                                  onTap: () => Get.to(() =>
                                      LocataireDetails(locataire: locataire)),
                                  cells: [
                                    DataCell(Row(
                                      spacing: 10,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              AppColors.primaryLightAccent,
                                          child: Text(
                                              (locataires.indexOf(locataire) +
                                                      1)
                                                  .toString()),
                                        ).size(30, 30),
                                        Text(locataire.nom.firstMaj()),
                                      ],
                                    )),
                                    DataCell(Text(locataire.email)),
                                    DataCell(
                                        Text(locataire.adresse.firstMaj())),
                                    const DataCell(Text('Aucun numéro')),
                                    DataCell(
                                      Row(
                                        spacing: 10,
                                        children: [
                                          const Icon(
                                            Iconsax.edit_2_outline,
                                            color: AppColors.red,
                                          ).clickable(ontap: () {
                                            Get.dialog(
                                              DialogWidget(
                                                child: LocataireForm(
                                                  locataire: locataire,
                                                  onSave: fetchData,
                                                ),
                                              ),
                                            );
                                          }),
                                          const Icon(
                                            Iconsax.trash_outline,
                                          ).clickable(
                                              ontap: () =>
                                                  deleteLocataire(locataire))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
          ),
        ],
      ),

      /// --- Version mobile ---
      mobile: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            /// Barre de recherche + bouton
            Row(
              children: [
                const Expanded(child: SearchField()),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Get.dialog(
                    Dialog(
                      child: LocataireForm(
                        onSave: () => fetchData(),
                      ),
                    ),
                  ),
                  child: MyButton.icon(
                    icon: Icons.add,
                    onPressed: _showForm,
                    label: 'Nouveau',
                    borderSize: 50,
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.primaryLight,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// Liste des locataires
            Expanded(
              child: locataires.isEmpty
                  ? const EmptyState(title: 'Aucun locataire trouvé')
                  : ListView.separated(
                      itemCount: locataires.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final locataire = locataires[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            onTap: () => Get.to(
                              () => LocataireDetails(locataire: locataire),
                              curve: Curves.bounceInOut,
                              transition: Transition.zoom,
                            ),
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              child: Icon(Iconsax.user_outline,
                                  color: AppColors.primary),
                            ),
                            title: Text(
                              locataire.nom,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(locataire.email),
                            trailing: PopupMenuButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: 'edit',
                                    child: const Text('Modifier'),
                                    onTap: () => _showForm(locataire)),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: const Text('Supprimer'),
                                  onTap: () => deleteLocataire(locataire),
                                ),
                                const PopupMenuItem(
                                    value: 'details', child: Text('Détails')),
                              ],
                              onSelected: (value) {
                                if (value == 'details') {
                                  Get.to(() =>
                                      LocataireDetails(locataire: locataire));
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      /// --- Tablette (optionnel à étendre plus tard) ---
      tablet: const Center(
        child: Text("Version tablette à venir..."),
      ),
    );
  }
}
