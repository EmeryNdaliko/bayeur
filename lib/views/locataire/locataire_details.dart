import "package:bayer/costante/export.dart";
import "package:bayer/widget/dialog_widget.dart";

class LocataireDetails extends StatefulWidget {
  final LocataireModel locataire;
  const LocataireDetails({super.key, required this.locataire});

  @override
  State<StatefulWidget> createState() => _LocataireDetails();
}

class _LocataireDetails extends State<LocataireDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail du locataire'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry>[
              const PopupMenuItem(child: Text('Export pdf')),
              const PopupMenuItem(child: Text('Export xls')),
            ],
          ),
          20.width
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            children: [
              ListTile(
                title: widget.locataire.nom
                    .firstMaj()
                    .textColor(fontweight: FontWeight.w900, size: 20),
                leading: const Icon(Iconsax.user_outline),
                subtitle:
                    'Adresse : ${widget.locataire.adresse.firstMaj()}'.text,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Get.dialog(const DialogWidget(
                      child: Center(child: Text('more details'))));
                },
              ),
              Container(
                  decoration: BoxDecoration(
                      color: AppColors.primaryLightAccent,
                      borderRadius: BorderRadius.circular(15)),
                  width: 500,
                  height: 100,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      10.width,
                      _buildCard(title: 'Dette totale', value: '40,089'),
                      10.width,
                      _buildCard(title: 'Total payé', value: '6799,58'),
                      10.width,
                    ],
                  )),
              10.height,
              Row(
                spacing: 10,
                children: [
                  const Text(
                    'Details de paiements',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: MyButton(
                      label: 'Nouveau',
                      icon: Icons.add,
                      onTap: () {},
                      borderSize: 50,
                    ),
                  )
                ],
              ),
              const Divider(),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    10,
                    (index) => Column(
                      children: [
                        ListTile(
                          leading: const Icon(Iconsax.card_outline),
                          title: Text(
                            'Paiement garantie N°${index + 1}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 18),
                          ),
                          subtitle: Text(
                              '${DateTime.now().format} • ${DateTime.now().add(50.days).format}'),
                          trailing: Text(
                            '\$908 >',
                            style: GoogleFonts.dmSans(
                                fontSize: 18,
                                color: index % 2 == 0
                                    ? AppColors.red
                                    : AppColors.success),
                            // fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Divider()
                      ],
                    ),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildCard({required String title, required String value}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.primary, borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        height: 100,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: AppColors.primaryLight),
              ),
              Text(
                '\$$value',
                style: GoogleFonts.dmSans(
                  fontSize: 25,
                  color: AppColors.primaryLight,
                  // fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
