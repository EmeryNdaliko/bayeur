import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bayer/costante/export.dart';
import 'package:bayer/views/location/new_location.dart';
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
  LocataireModel selectedLocataire = LocataireModel();

  int pageIndex = 0;
  List<Widget> get pages => [
        _desktopContent(),
        LocataireDetails(
          locataire: selectedLocataire,
          onBack: () {
            setState(() {
              pageIndex = 0;
            });
          },
        ),
        NewLocation(
          onSave: () {},
          onBack: () {
            setState(() {
              pageIndex = 0;
            });
          },
        )
      ];

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

  void deleteLocataire(LocataireModel locataire, BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      btnOkOnPress: () {},
    );

    //   AskYesNoWidget(
    //   onConfirm: () async {
    //     await locataire.delete().then(
    //       (value) {
    //         if (value) {
    //           fetchData();
    //         }
    //       },
    //     );
    //   },
    // )
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
    return Responsive(
      desktop: Column(
        children: [
          /// --- En-tête avec barre de recherche et bouton ---
          if (pageIndex == 0)
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
          Expanded(child: pages[pageIndex])
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
                              () => LocataireDetails(
                                locataire: locataire,
                              ),
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
                                  onTap: () =>
                                      deleteLocataire(locataire, context),
                                ),
                                const PopupMenuItem(
                                    value: 'details', child: Text('Détails')),
                              ],
                              onSelected: (value) {
                                if (value == 'details') {
                                  Get.to(() => LocataireDetails(
                                        locataire: locataire,
                                      ));
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

  Widget _desktopContent() {
    return Theme(
      data: Theme.of(context)
          .copyWith(cardTheme: const CardThemeData(color: Colors.white)),
      child: PaginatedDataTable2(
        empty: isLoading
            ? const Center(child: CircularProgressIndicator())
            : const EmptyState(title: 'Aucun locataire trouvé'),
        showCheckboxColumn: true,
        columns: [
          'Noms',
          'Email',
          'Adresse',
          'Téléphone',
          'Actions',
        ].map((e) => DataColumn2(label: Text(e))).toList(),
        source: LocataireSource(
          context: context,
          locataires: locataires,
          onSave: fetchData,
          onSelected: (loc) {
            setState(() {
              selectedLocataire = loc;
              pageIndex = 1;
            });
          },
        ),
      ),
    );
  }
}

class LocataireSource extends DataTableSource {
  final List<LocataireModel> locataires;
  final VoidCallback onSave;
  final BuildContext context;
  final Function(LocataireModel loc) onSelected;

  LocataireSource({
    required this.onSelected,
    required this.context,
    required this.locataires,
    required this.onSave,
  });

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => locataires.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow2(
      onTap: () => onSelected(locataires[index]),
      cells: [
        DataCell(Row(
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Text("${index + 1}",
                    style: TextStyle(
                        color: AppColors.primary,
                        fontFamily: GoogleFonts.dmSans().fontFamily)),
              ),
            ),
            const SizedBox(width: 10),
            Text(locataires[index].nom),
          ],
        )),
        DataCell(Text(locataires[index].email)),
        DataCell(Text(locataires[index].adresse)),
        DataCell(Text(locataires[index].telephone)),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Iconsax.edit_2_outline, color: AppColors.red),
              onPressed: () {
                Get.dialog(DialogWidget(
                    child: LocataireForm(
                  onSave: onSave,
                  locataire: locataires[index],
                )));
              },
            ),
            IconButton(
              icon: const Icon(Iconsax.trash_outline),
              onPressed: () {
                AwesomeDialog(
                  width: 400,
                  context: context,
                  dialogType: DialogType.question,
                  btnOkText: "Supprimer",
                  btnCancelText: "Annuler",
                  buttonsTextStyle: const TextStyle(
                      fontWeight: FontWeight.normal, color: AppColors.white),
                  btnCancelOnPress: () {},
                  btnOkOnPress: () async {
                    bool success = await locataires[index].delete();
                    if (success) {
                      AwesomeDialog(
                              width: 400,
                              title: 'Suppression',
                              desc: 'Supression reussi',
                              context: context,
                              dialogType: DialogType.success,
                              autoHide: 2.seconds)
                          .show();
                      onSave();
                    }
                  },
                  title: 'Suspression',
                  desc: "Voulez-vous supprimer ${locataires[index].nom} ?",
                ).show();
              },
            ),
          ],
        )),
      ],
    );
  }
}
