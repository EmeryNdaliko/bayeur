import 'package:bayer/costante/export.dart';
import 'package:bayer/models/location_model.dart';
import 'package:bayer/models/property_model.dart';
import 'package:bayer/views/location/new_location.dart';
import 'package:bayer/widget/dialog_widget.dart';

class LocationView extends StatefulWidget {
  const LocationView({super.key});

  @override
  State<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends State<LocationView> {
  var properties = <PropertyModel>[];
  var locations = <LocationModel>[];

  bool isLoading = false;

  Future<void> fetchData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    var sqlManager = SqliteManager();
    await sqlManager.query('location').then((value) {
      if (mounted) {
        setState(() {
          locations = value
              .map(
                (e) => LocationModel.fromJson(e),
              )
              .toList();
          logger.i(locations);
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
        NewLocation(
          onSave: fetchData,
          onBack: () {
            setState(() {
              pageIndex = 0;
            });
          },
        )
      ];

  @override
  void initState() {
    fetchData();
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
              label: "Nouvelle location",
              showIcon: false,
              width: 200,
              borderSize: 50,
              onTap: () {
                setState(() {
                  pageIndex = 1;
                });
              },
            ),
          ],
        ),
        Expanded(
          child: Theme(
            data: Theme.of(context).copyWith(
                cardTheme: const CardThemeData(
              color: Colors.white,
            )),
            child: PaginatedDataTable2(
              header: const Text('data'),
              empty: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const EmptyState(title: 'Aucune Location trouvé'),
              actions: [
                IconButton.filled(
                    color: Colors.white,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () async {
                      await SqliteManager()
                          .execute(query: 'DELETE FROM location');
                    },
                    icon: const Icon(Icons.delete_outline))
              ],
              columns: [
                'Locataire',
                'Propriete',
                'Date debut',
                'Date fin',
                'Statut',
                'Action'
              ]
                  .map((label) => DataColumn2(
                      label: label.textColor(fontweight: FontWeight.w600)))
                  .toList(),
              source: LocationSource(
                properties: properties,
                onSelected: () {},
                locataire: [],
                locations: locations,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LocationSource extends DataTableSource {
  final List<PropertyModel> properties;
  final List<LocationModel> locations;
  final List<LocataireModel> locataire;
  final VoidCallback onSelected;

  LocationSource({
    required this.locataire,
    required this.locations,
    required this.properties,
    required this.onSelected,
  });
  @override
  DataRow2? getRow(int index) {
    var location = locations[index];

    return DataRow2(cells: [
      DataCell(FutureBuilder(
          future: LocataireModel.getLocataireById(location.locataireId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator.adaptive();
            }
            if (snapshot.hasData) {
              return Text(snapshot.data!.nom.firstMaj());
            }
            return const SizedBox();
          })),
      DataCell(FutureBuilder(
          future: PropertyModel.getPropertyById(location.proprieteId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data!.designation.firstMaj());
            }
            return const SizedBox();
          })),
      DataCell(location.dateDebut.format.text),
      DataCell(location.dateFin.format.text),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(45, 183, 100, 0.306),
              borderRadius: BorderRadius.circular(5)),
          child: Text(location.statut.name),
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
            ).clickable(ontap: () async {})
          ],
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => locations.length;

  @override
  int get selectedRowCount => 1;
}
