import 'package:bayer/costante/export.dart';
import 'package:bayer/widget/dialog_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  SqliteManager database = SqliteManager();
  int locataires = 0;
  int properties = 0;

  Future<void> initialise() async {
    await database.query('locataires').then(
      (value) {
        if (mounted) {
          setState(() {
            locataires = value.length;
          });
        }
      },
    );

    await database.query('proprietes').then(
      (value) {
        if (mounted) {
          setState(() {
            properties = value.length;
          });
        }
      },
    );
  }

  @override
  void initState() {
    initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: Container(
        padding: const EdgeInsets.only(top: 30),
        decoration: BoxDecoration(
            color: AppColors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            // SvgPicture.asset('assets/icons/edit.svg'),
            "Bonjour ${UserModel.current.toString()} !"
                .textColor(size: 25, fontweight: FontWeight.w600),
            "Nous sommes ravis de vous revoir!".textColor(size: 18),
            30.height,
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: AppColors.primaryLightAccent,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.user_tag_outline, size: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            'Locataire'.textColor(
                                fontweight: FontWeight.w400, size: 14),
                            '00$locataires'.textColor(
                                fontweight: FontWeight.w600, size: 30)
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      spacing: 20,
                      children: [
                        const Icon(Iconsax.house_outline, size: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            'Propriété'.textColor(
                                fontweight: FontWeight.w400, size: 14),
                            '00$properties'.textColor(
                                fontweight: FontWeight.w600, size: 30)
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      spacing: 20,
                      children: [
                        const Icon(Iconsax.dollar_circle_outline, size: 30),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            'Solde'.textColor(
                                fontweight: FontWeight.w400, size: 14),
                            '399'.textColor(
                                fontweight: FontWeight.w600, size: 30)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      tablet: const Scaffold(),
      mobile: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.background,
                ),
                onPressed: () {
                  Get.dialog(
                      DialogWidget(child: LocataireForm(onSave: initialise)));
                },
                label: const Text('Nouveau'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                        'Locataires',
                        locataires.toString(),
                        Iconsax.user_tag_bold,
                      ),
                    ),
                    Expanded(
                      child: _buildCard(
                        'Propriétes',
                        properties.toString(),
                        Iconsax.building_3_bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildCard(
                        'Appartements',
                        '0000',
                        Iconsax.house_2_bold,
                      ),
                    ),
                    Expanded(
                      child: _buildCard(
                        'Caisse',
                        '50\$',
                        Icons.monetization_on,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: AppColors.primaryLight, size: 30),
            Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.dmSans(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
