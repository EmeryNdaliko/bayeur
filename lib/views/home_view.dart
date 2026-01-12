import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bayer/costante/export.dart';
import 'package:bayer/services/cache_manager.dart';
import 'package:bayer/views/login_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;

  /// Tableau complet des pages
  List<Map<String, dynamic>> get pages => [
        {
          'widget': const Dashboard(),
          'title': 'Accueil',
          'icon': Iconsax.home_2_outline
        },
        {
          'widget': const LocataireView(),
          'title': 'Locataires',
          'icon': Iconsax.user_tag_outline,
        },
        {
          'widget': const PropertyView(),
          'title': 'Propriétés',
          'icon': Iconsax.building_3_outline,
        },
        {
          'widget': const LocationView(),
          'title': 'Locations',
          'icon': Iconsax.location_outline,
        },
        {
          'widget': const LocationView(),
          'title': 'Paiements',
          'icon': Iconsax.card_add_outline,
        },
        {
          'widget': const ProfilView(),
          'title': 'Profil',
          'icon': Iconsax.user_outline,
        },
      ];

  /// Menus visibles dans la bottom bar mobile
  final List<int> bottomMenuPages = [0, 1, 4];

  /// Menus envoyés dans le Drawer
  final List<int> drawerMenuPages = [2, 3];

  @override
  Widget build(BuildContext context) {
    return Responsive(
      desktop: _buildDesktop(),
      tablet: const Scaffold(),
      mobile: _buildMobile(),
    );
  }

  // ---------------------------- DESKTOP -----------------------------------

  Widget _buildDesktop() {
    return SizedBox(
      // width: 100,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Row(
            children: [
              _desktopSidebar(),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLightAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: pages[currentIndex]['widget'],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _desktopSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        DrawerHeader(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset('assets/images/logo-bayeur4.png'),
          ),
        ),
        ...List.generate(
          pages.length,
          (index) => Container(
            width: 120,
            height: 30,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: currentIndex == index ? AppColors.primaryLight : null,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                5.width,
                Icon(pages[index]['icon'], size: 20),
                5.width,
                Text(
                  pages[index]['title'],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ).clickable(
                  ontap: () => setState(() => currentIndex = index),
                )
              ],
            ),
          ),
        ),
        Row(children: [
          5.width,
          // AppConstante.powerSvg.toAsset(),
          const Icon(Bootstrap.power, size: 20),
          5.width,
          const Text(
            'Deconnexion',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          )
        ]).clickable(
          ontap: () {
            AwesomeDialog(
              width: 400,
              dialogType: DialogType.question,
              title: 'Deconnexion',
              desc: 'Voulez-vous vous deconnecter?',
              btnOkText: "Oui",
              dismissOnTouchOutside: false,
              btnCancelText: 'Annuler',
              barrierColor: Colors.black.withAlpha(60),
              btnOkColor: AppColors.black,
              btnCancelOnPress: () {},
              context: context,
              btnOkOnPress: () async {
                if (await CacheManager.user.remove()) {
                  Get.offAll(() => const LoginScreen());
                }
              },
            ).show();
          },
        )
      ],
    );
  }

  // ---------------------------- MOBILE -----------------------------------

  Widget _buildMobile() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _appBar(),
      drawer: _buildDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: pages[currentIndex]['widget'],
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        children: [
          _desktopSidebar(),
        ],
      ),
    );
  }

  Widget _bottomNavBar() {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primaryLightAccent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          bottomMenuPages.length,
          (i) => _bottomItem(bottomMenuPages[i]),
        ),
      ),
    );
  }

  Widget _bottomItem(int index) {
    bool isActive = currentIndex == index;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: isActive ? AppColors.primaryLight : null,
      ),
      child: Row(
        spacing: 10,
        children: [
          Icon(pages[index]['icon'], size: 22),
          if (isActive)
            Text(
              pages[index]['title'],
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    ).clickable(
      ontap: () => setState(() => currentIndex = index),
    );
  }

  // ---------------------------- APP BAR -----------------------------------

  AppBar _appBar() {
    return AppBar(
      title: Text(
        pages[currentIndex]['title'],
        style: GoogleFonts.dmSans(fontSize: 20),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        ),
      ],
    );
  }
}

// ---------------------------- STAT CARD -----------------------------------

class StatCard extends StatelessWidget {
  final String name;
  final int number;
  final IconData icon;
  final String title;
  final String subtitle;

  const StatCard({
    super.key,
    required this.name,
    required this.number,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 80,
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.primary,
            child: Icon(icon),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(subtitle),
            ],
          )
        ],
      ),
    );
  }
}
