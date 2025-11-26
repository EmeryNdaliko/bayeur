import 'package:bayer/costante/export.dart';
import 'package:bayer/widget/dialog_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
        setState(() {
          locataires = value.length;
        });
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
    return Rensponsive(
      desktop: Scaffold(
        body: Column(
          children: [
            "Bonjour Emery Ndaliko !"
                .textColor(size: 25, fontweight: FontWeight.w900),
            "Nous sommes ravis de vous revoir!".textColor(size: 18),
            30.height,
            Container(
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryLight)),
              height: 150,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        'Locataire'
                            .textColor(fontweight: FontWeight.w900, size: 14),
                        '$locataires'
                            .textColor(fontweight: FontWeight.w900, size: 30)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        'Propriété'
                            .textColor(fontweight: FontWeight.w900, size: 14),
                        '400k'.textColor(fontweight: FontWeight.w900, size: 30)
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        'Autres'
                            .textColor(fontweight: FontWeight.w900, size: 14),
                        '399'.textColor(fontweight: FontWeight.w900, size: 30)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 200,
                child: SfCartesianChart(
                  annotations: <CartesianChartAnnotation>[
                    CartesianChartAnnotation(
                      xAxisName: 'kkkkokokok',
                      widget: Center(child: Text('')),
                      x: 3,
                      y: 60,
                    ),
                  ],
                )),
            const Text('data'),
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
                        Icons.supervised_user_circle_rounded,
                      ),
                    ),
                    Expanded(
                      child: _buildCard(
                        'Propriétes',
                        locataires.toString(),
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
                        locataires.toString(),
                        Icons.supervised_user_circle_rounded,
                      ),
                    ),
                    Expanded(
                      child: _buildCard(
                        'Caisse',
                        '500\$',
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

  Container _card() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
                blurStyle: BlurStyle.outer,
                offset: Offset(2, 0),
                blurRadius: 5,
                color: AppColors.primaryLight),
          ]),
      child: const Column(
        children: [
          Row(
            children: [
              Text('Locataires'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: AppColors.primary, size: 30),
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
