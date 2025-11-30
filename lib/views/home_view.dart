import 'package:bayer/costante/app_colors.dart';
import 'package:bayer/costante/extension.dart';
import 'package:bayer/rensponsive/rensponsive.dart';
import 'package:bayer/views/locataire/locataire_view.dart';
import 'package:bayer/views/dashboard.dart';
import 'package:bayer/views/profil_view.dart';
import 'package:bayer/views/property_view.dart';
import 'package:bayer/views/setting_view.dart';
import 'package:flutter/material.dart';
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
          'icon': Iconsax.home_2_outline
        },
        {
          'widget': const LocataireView(),
          'title': 'Locataire',
          'icon': Iconsax.user_tag_outline,
        },
        {
          'widget': const PropertyView(),
          'title': 'Propriété',
          'icon': Iconsax.building_3_outline,
        },
        {
          'widget': const PropertyView(),
          'title': 'Location',
          'icon': Iconsax.location_outline,
        },
        {
          'widget': const ProfilView(),
          'title': 'Profil',
          'icon': Iconsax.user_outline,
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Rensponsive(
        desktop: Container(
          width: 100,
          child: Scaffold(
            body: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Row(children: [
                  Column(
                    spacing: 8,
                    children: [
                      DrawerHeader(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child:
                                  Image.asset('assets/images/logo-bayeur4.png'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 80),
                      ...List.generate(
                          pages.length,
                          (index) => Container(
                                width: 120,
                                height: 30,
                                padding: const EdgeInsets.all(2),
                                // margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? AppColors.primaryLight
                                      : null,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    5.width,
                                    Icon(
                                      pages[index]['icon'],
                                      size: 20,
                                    ),
                                    5.width,
                                    Text(
                                      pages[index]['title'],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.black,
                                      ),
                                    ).clickable(
                                        ontap: () => setState(
                                            () => currentIndex = index)),
                                  ],
                                ),
                              )),
                    ],
                  ),
                  const SizedBox(width: 10),
                  // const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
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
        ),
        tablet: const Scaffold(),
        mobile: Scaffold(
          backgroundColor: AppColors.background,
          appBar: appBar(),
          // drawer: const MyDrawer(),
          body: Column(
            children: [
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: pages[currentIndex]['widget'] as Widget,
              )),
              Container(
                margin: const EdgeInsets.all(5),
                height: 80,
                color: AppColors.primaryLightAccent,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                        pages.length, (index) => _buildButtomItem(index))),
              )
            ],
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //     type: BottomNavigationBarType.fixed,
          //     currentIndex: currentIndex,
          //     onTap: (value) {
          //       setState(() {
          //         currentIndex = value;
          //       });
          //     },
          //     fixedColor: AppColors.primaryLight,
          //     // backgroundColor: AppColors.cardBackground,
          //     backgroundColor: AppColors.primaryLightAccent,
          //     unselectedItemColor: AppColors.primary,
          //     elevation: 1,
          //     items: List<BottomNavigationBarItem>.generate(
          //       pages.length,
          //       (index) => BottomNavigationBarItem(
          //           icon: CircleAvatar(child: Icon(pages[index]['icon'])),
          //           label: pages[index]['title']),
          //     ).toList())
        ));
  }

  Widget _buildButtomItem(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: currentIndex == index ? AppColors.primaryLight : null,
      ),
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(pages[index]['icon'] as IconData),
          if (currentIndex == index)
            Text(
              pages[index]['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            )
        ],
      ),
    ).clickable(
        ontap: () => setState(() {
              currentIndex = index;
            }));
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
