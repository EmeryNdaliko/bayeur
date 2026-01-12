import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bayer/costante/export.dart';
import 'package:bayer/models/property_model.dart';

import 'package:bayer/widget/dialog_widget.dart';

class PropertyView extends StatefulWidget {
  const PropertyView({super.key});

  @override
  State<PropertyView> createState() => _PropertyViewState();
}

class _PropertyViewState extends State<PropertyView> {
  var properties = <PropertyModel>[];
  bool isLoading = false;
  Future<void> fetchData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    var sqlManager = SqliteManager();
    await sqlManager.query('proprietes').then((value) {
      if (mounted) {
        setState(() {
          properties = value
              .map(
                (e) => PropertyModel.fromJson(e),
              )
              .toList();
        });
      }
    });
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  int pageIndex = 0;

  List<Widget> get pages => [
        _desktopContent(),
      ];

  @override
  void initState() {
    fetchData();

    // var a = (() {})();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: const Scaffold(),
      tablet: const Scaffold(),
      desktop: pages[pageIndex],
    );
  }

  Column _desktopContent() {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 300, child: SearchField()),
            const SizedBox(width: 5),
            MyButton(
              label: "Nouvelle propriété",
              showIcon: false,
              width: 200,
              borderSize: 50,
              onTap: () => Get.dialog(DialogWidget(child: PropertyForm(
                onSave: () {
                  Get.back();
                  fetchData();
                },
              ))),
            ),
          ],
        ),
        Expanded(
            child: Theme(
          data: Theme.of(context).copyWith(
              cardTheme:
                  const CardThemeData(elevation: 0, color: AppColors.white)),
          child: PaginatedDataTable2(
              showCheckboxColumn: true,
              columns: [
                'Designation',
                'Type',
                'adresse',
                'prix',
                'Statut',
                'Action',
              ]
                  .map<DataColumn>((e) => DataColumn(
                      label: e.textColor(fontweight: FontWeight.w600)))
                  .toList(),
              source: Source(
                properties: properties,
                onSelected: (property) {},
                onDelete: (property) {
                  AwesomeDialog(
                    width: 500,
                    title: 'Success',
                    autoHide: 2.seconds,
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.scale,
                    desc: 'une breve description',
                  ).show();
                  return;
                  AwesomeDialog(
                          context: context,
                          dialogType: DialogType.question,
                          width: 500,
                          title: 'Confirmation',
                          btnOkOnPress: () async {
                            await property.delete().then(
                              (value) {
                                if (value) {
                                  fetchData().then(
                                    (value) {},
                                  );
                                }
                              },
                            );
                          },
                          btnCancelOnPress: () {})
                      .show();
                },
                onSave: () {
                  Get.back();
                  fetchData();
                },
              )),
        )),
      ],
    );
  }
}

class Source extends DataTableSource {
  final List<PropertyModel> properties;
  final Function(PropertyModel) onSelected;
  final Function(PropertyModel) onDelete;
  final VoidCallback onSave;

  Source({
    required this.properties,
    required this.onSelected,
    required this.onDelete,
    required this.onSave,
  });
  @override
  DataRow2? getRow(int index) {
    // assert(index < 0 && index < properties.length);
    var propriete = properties[index];
    return DataRow2(
        onTap: () {
          logger.i(propriete.toJson());
        },
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
              propriete.designation.firstMaj().text,
            ],
          )),
          DataCell(
            (propriete.type.name.firstMaj().text),
          ),
          DataCell(propriete.adresse.text),
          DataCell(propriete.prix.toString().text),
          DataCell(
            Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(45, 183, 100, 0.306),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(propriete.statut.name.firstMaj()),
            ),
          ),
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
                      child: SizedBox(
                        child: PropertyForm(
                          property: propriete,
                          onSave: onSave,
                        ),
                      ),
                    ),
                  );
                }),
                const Icon(
                  Iconsax.trash_outline,
                ).clickable(ontap: () => onDelete(propriete))
              ],
            ),
          ),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => properties.length;

  @override
  int get selectedRowCount => 5;
}
