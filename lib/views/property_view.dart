import 'package:bayer/costante/export.dart';
import 'package:bayer/models/property_model.dart';
import 'package:bayer/views/forms/property_form.dart';
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

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              onTap: () =>
                  Get.dialog(const DialogWidget(child: PropertyForm())),
            ),
          ],
        ),
        Expanded(
            child: PaginatedDataTable2(
                columns: [
              DataColumn2(label: 'Designation'.text),
              DataColumn2(label: 'Type'.text),
              DataColumn2(label: 'adresse'.text),
              DataColumn2(label: 'prix'.text),
              DataColumn2(label: 'Statut'.text),
              DataColumn2(label: 'Action'.text),
            ],
                source: Source(
                  properties: properties,
                  onSelected: () {},
                ))
            //
            //
            // ListView.separated(
            //   separatorBuilder: (context, index) => const SizedBox(height: 5),
            //   itemCount: 30,
            //   itemBuilder: (context, index) {
            //     return Card(
            //       elevation: 0,
            //       color: AppColors.cardBackground,
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Container(
            //             decoration: BoxDecoration(
            //                 image: const DecorationImage(
            //                     fit: BoxFit.cover,
            //                     image: AssetImage('assets/images/house.jpg')),
            //                 color: AppColors.primaryLight,
            //                 borderRadius: BorderRadius.circular(10)),
            //             height: 150,
            //           ),
            //           const Padding(
            //             padding: EdgeInsets.all(8.0),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Row(
            //                   children: [
            //                     Text(
            //                       'urban-village',
            //                       style: TextStyle(fontSize: 12),
            //                     ),
            //                     Spacer(),
            //                     Text(
            //                       '3 lits | 3 chambre',
            //                       style: TextStyle(fontSize: 12),
            //                     )
            //                   ],
            //                 ),
            //                 Text(
            //                   'Goma-Mabanga Nord - Kindu 2',
            //                   style: TextStyle(
            //                       fontSize: 16, fontWeight: FontWeight.w900),
            //                 ),
            //                 SizedBox(
            //                   height: 5,
            //                 ),
            //                 Row(
            //                   children: [
            //                     Text(
            //                       '\$200',
            //                       style: TextStyle(
            //                         fontSize: 20,
            //                         fontWeight: FontWeight.w900,
            //                         color: AppColors.secondary,
            //                       ),
            //                     ),
            //                     Text(
            //                       ' \\ mois',
            //                       style: TextStyle(
            //                         fontSize: 10,
            //                         fontWeight: FontWeight.w200,
            //                         color: AppColors.secondary,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //                 SizedBox(
            //                   height: 10,
            //                 ),
            //               ],
            //             ),
            //           )
            //         ],
            //       ),
            //     );
            //   },
            // ),
            ),
      ],
    );
  }
}

class Source extends DataTableSource {
  final List<PropertyModel> properties;
  final VoidCallback onSelected;

  Source({required this.properties, required this.onSelected});
  @override
  DataRow2? getRow(int index) {
    var propriete = properties[index];
    return DataRow2(cells: [
      DataCell(properties[index].designation.text),
      DataCell(propriete.type.name.text),
      DataCell(propriete.adresse.text),
      DataCell(propriete.prix.toString().text),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(45, 183, 100, 0.306),
              borderRadius: BorderRadius.circular(5)),
          child: Text(propriete.statut.name),
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
                const DialogWidget(
                  child: SizedBox(),
                ),
              );
            }),
            const Icon(
              Iconsax.trash_outline,
            ).clickable(ontap: () => {})
          ],
        ),
      ),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => properties.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 1;
}
