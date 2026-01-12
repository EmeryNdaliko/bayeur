import "package:bayer/costante/export.dart";
import "package:bayer/models/location_model.dart";

class LocataireDetails extends StatefulWidget {
  final LocataireModel locataire;
  final VoidCallback? onBack;
  const LocataireDetails({super.key, required this.locataire, this.onBack});

  @override
  State<StatefulWidget> createState() => _LocataireDetails();
}

class _LocataireDetails extends State<LocataireDetails> {
  int tabIndex = 0;
  List<String> get tabTitle => [
        'Paiement actuel',
        'Historique de paiement',
        'Information de location',
        'Dettes'
      ];

  List<Widget> get detailsPages => [
        const Center(child: Text('Statut du paiement')),
        paiementsDetailsContents(),
        const Center(child: Text('data')),
        const Center(child: Text('data')),
        const Center(child: Text('data')),
      ];

      

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: Scaffold(
        body: Center(
          child: const Text('Mobile locataire details').clickable(
            ontap: () => Get.back(),
          ),
        ),
      ),
      tablet: const Scaffold(
        body: Center(
          child: Text('Tablette locataire details'),
        ),
      ),
      desktop: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
            color: AppColors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              spacing: 10,
              children: [
                IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.keyboard_backspace_outlined)),
                const Text(
                  'Details du locataire',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                )
              ],
            ),
            10.height,
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(child: AppConstante.customerSvg.toAsset(width: 25)),
                    Text(
                      widget.locataire.nom.firstMaj(),
                      style: GoogleFonts.dmSans(),
                    ),
                  ],
                ),
                10.width,
                const SizedBox(
                  height: 50,
                  child: VerticalDivider(),
                ),
                const Icon(Iconsax.edit_2_outline).clickable(
                  ontap: () {},
                ),
                10.width,
                const Icon(
                  Iconsax.trash_outline,
                  color: AppColors.red,
                )
              ],
            ),
            10.height,
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder(
                      future: widget.locataire.getAllPaiements(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasData) {
                          return _buildCard(
                              title: 'Total payé', value: '6799,58');
                        }
                        return _buildCard(title: 'Total payé', value: '0,00');
                      },
                    ),
                    const SizedBox(
                      height: 25,
                      child: VerticalDivider(),
                    ),
                    _buildCard(title: 'Dette totale', value: '40,089'),
                  ],
                )),
            10.height,
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: List.generate(
                  tabTitle.length,
                  (index) => SizedBox(
                        child: InputChip(
                          elevation: 0,
                          onPressed: () => setState(() => tabIndex = index),
                          mouseCursor: SystemMouseCursors.click,
                          backgroundColor:
                              tabIndex == index ? AppColors.blue : null,
                          label: Text(
                            tabTitle[index],
                            style: TextStyle(
                              color: tabIndex == index ? AppColors.white : null,
                            ),
                          ),
                        ),
                      )),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 10,
              children: [
                Text(
                  tabTitle[tabIndex],
                  style: GoogleFonts.dmSans(
                    fontSize: 20,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(12)),
              child: SingleChildScrollView(
                child: detailsPages[tabIndex],
              ),
            ))
          ],
        ),
      ),
    );
  }

  Column paiementsDetailsContents() {
    return Column(
      children: List.generate(
        10,
        (index) => Column(
          children: [
            ListTile(
              leading: const Icon(Iconsax.card_outline),
              title: Text(
                'Paiement garantie N°${index + 1}'.toUpperCase(),
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(),
              ),
              subtitle: Text(
                '${DateTime.now().format} • ${DateTime.now().add(50.days).format}',
                style: GoogleFonts.dmSans(
                    color: AppColors.textSecondary, fontSize: 12),
              ),
              trailing: Text(
                '\$908 >',

                style: GoogleFonts.dmSans(
                    fontSize: 18,
                    color: index % 2 == 0 ? AppColors.red : AppColors.success),
                // fontWeight: FontWeight.w900,
              ),
            ),
            const Divider()
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String value}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        Text(
          '\$$value',
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.dmSans(
            fontSize: 25,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
