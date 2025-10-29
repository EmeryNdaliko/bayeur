import 'package:bayer/costante/app_colors.dart';
import 'package:bayer/costante/extension.dart';
import 'package:bayer/models/locataire_model.dart';
import 'package:bayer/rensponsive/rensponsive.dart';
import 'package:bayer/views/forms/locataire_form.dart';
import 'package:bayer/views/locataire/locataire_details.dart';
import 'package:bayer/widget/button_widget.dart';
import 'package:bayer/widget/empty_state.dart';
import 'package:bayer/widget/search_widget.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class LocataireView extends StatefulWidget {
  const LocataireView({super.key});

  @override
  State<LocataireView> createState() => _LocataireViewState();
}

class _LocataireViewState extends State<LocataireView> {
  List<LocataireModel> locataires = [];

  @override
  void initState() {
    locataires = List.generate(
      10,
      (index) => LocataireModel.build(
        id: index.toString(),
        nom: 'Emery ndaliko kambale $index',
        email: 'locataire$index@example.com',
        password: '${String.fromCharCode(65 + index)}assword123',
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Rensponsive(
      desktop: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// --- En-tête avec barre de recherche et bouton ---
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 300, child: SearchField()),
                const SizedBox(width: 10),
                MyButton(
                  label: "Nouveau locataire",
                  showIcon: false,
                  width: 200,
                  borderSize: 50,
                  onTap: () => Get.dialog(const Dialog(child: LocataireForm())),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// --- Tableau ou État vide ---
            Expanded(
              child: locataires.isEmpty
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
                        headingTextStyle:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                        dataRowHeight: 40,
                        columns: const [
                          DataColumn2(label: Text('Noms')),
                          DataColumn2(label: Text('Email')),
                          DataColumn2(label: Text('Téléphone')),
                          DataColumn2(label: Text('Actions')),
                        ],
                        rows: locataires
                            .map(
                              (loc) => DataRow2(
                                onTap: () => Get.to(
                                    () => LocataireDetails(locataire: loc)),
                                cells: [
                                  DataCell(Row(
                                    spacing: 10,
                                    children: [
                                      Icon(Iconsax.gallery_bold,
                                          color: AppColors.primary),
                                      Text(loc.nom),
                                    ],
                                  )),
                                  DataCell(Text(loc.email)),
                                  const DataCell(Text('Aucun numéro')),
                                  DataCell(
                                    PopupMenuButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                            value: 'edit',
                                            child: Text('Modifier')),
                                        const PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Supprimer')),
                                        const PopupMenuItem(
                                            value: 'details',
                                            child: Text('Détails')),
                                      ],
                                      onSelected: (value) {
                                        if (value == 'details') {
                                          Get.to(() =>
                                              LocataireDetails(locataire: loc));
                                        }
                                      },
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
                    const Dialog(child: LocataireForm()),
                  ),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Nouveau",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
                        final loc = locataires[index];
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
                            onTap: () =>
                                Get.to(() => LocataireDetails(locataire: loc)),
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              child: Icon(Iconsax.user_outline,
                                  color: AppColors.primary),
                            ),
                            title: Text(
                              loc.nom,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(loc.email),
                            trailing: PopupMenuButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                    value: 'edit', child: Text('Modifier')),
                                PopupMenuItem(
                                    value: 'delete', child: Text('Supprimer')),
                                PopupMenuItem(
                                    value: 'details', child: Text('Détails')),
                              ],
                              onSelected: (value) {
                                if (value == 'details') {
                                  Get.to(
                                      () => LocataireDetails(locataire: loc));
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
