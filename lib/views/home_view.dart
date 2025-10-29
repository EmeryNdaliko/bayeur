import 'package:bayer/costante/app_colors.dart';
import 'package:bayer/costante/extension.dart';
import 'package:bayer/rensponsive/rensponsive.dart';
import 'package:bayer/views/locataire/locataire_view.dart';
import 'package:bayer/views/owner_dashboard.dart';
import 'package:bayer/views/property_view.dart';
import 'package:bayer/views/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;
  List<Map<String, dynamic>> get pages => [
        {
          'widget': const Dashboard(),
          'title': 'Accueil',
          'icon': Icon(Iconsax.home_2_outline)
        },
        // {'widget': const Dashboard(), 'title': 'Actualité'},
        {
          'widget': const LocataireView(),
          'title': 'Locataire',
          'icon': Icon(Iconsax.user_tag_outline),
        },
        {
          'widget': const PropertyView(),
          'title': 'Propriété',
          'icon': Icon(Iconsax.building_3_bold)
        },
        {
          'widget': const SettingView(),
          'title': 'Paramètres',
          'icon': Icon(Iconsax.setting_2_bold),
        },
        {
          'widget': const SettingView(),
          'title': 'Profil',
          'icon': Icon(Iconsax.setting_2_bold),
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Rensponsive(
        desktop: Scaffold(
          body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: Column(children: [
                Container(
                  // color: AppColors.success,
                  // height: 30,
                  child: Row(
                    children: [
                      const Text(
                        '[ Bayeur ]',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 80),
                      ...List.generate(
                          pages.length,
                          (index) => Container(
                                width: 120,
                                padding: const EdgeInsets.all(2),
                                // margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: currentIndex == index
                                        ? AppColors.primaryLight
                                        : null,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  pages[index]['title'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary),
                                ).clickable(
                                    ontap: () =>
                                        setState(() => currentIndex = index)),
                              )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLightAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: pages[currentIndex]['widget'] as Widget,
                  ),
                )
              ])),
        ),
        tablet: const Scaffold(),
        mobile: Scaffold(
            backgroundColor: AppColors.background,
            appBar: appBar(),
            // drawer: const MyDrawer(),
            body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: pages[currentIndex]['widget'] as Widget),
            bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                onTap: (value) {
                  setState(() {
                    currentIndex = value;
                  });
                },
                fixedColor: AppColors.primary,
                // backgroundColor: AppColors.background,
                elevation: 1,
                items: List<BottomNavigationBarItem>.generate(
                  pages.length,
                  (index) => BottomNavigationBarItem(
                      icon: pages[index]['icon'], label: pages[index]['title']),
                ).toList())));
  }

  Column desktopSection() {
    return const Column(children: [
      StatCard(
          name: 'Locataire',
          number: 3939,
          icon: Iconsax.user_add_bold,
          title: 'title',
          subtitle: 'subtitle')
    ]);
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        pages[currentIndex]['title'] as String,
        style: GoogleFonts.dmSans(),
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

class StatCard extends StatelessWidget {
  final String name;
  final int number;
  final IconData icon;
  final String title;
  final String subtitle;

  const StatCard(
      {super.key,
      required this.name,
      required this.number,
      required this.icon,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 80,
      width: 200,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(16)),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(subtitle),
              // const SubmenuButton(menuChildren: [], child: Text('sub bbton'))
            ],
          )
        ],
      ),
    );
  }
}
