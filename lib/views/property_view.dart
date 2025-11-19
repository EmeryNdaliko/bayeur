import 'package:bayer/views/forms/property_form.dart';
import 'package:bayer/widget/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:bayer/costante/app_colors.dart';
import 'package:get/get.dart';

class PropertyView extends StatefulWidget {
  const PropertyView({super.key});

  @override
  State<PropertyView> createState() => _PropertyViewState();
}

class _PropertyViewState extends State<PropertyView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: SearchField()),
            const SizedBox(width: 5),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Get.dialog(const Dialog(
                    child: PropertyForm(),
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 40,
                  width: 80,
                  child: const Center(
                    child: Text(
                      'Nouveau',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemCount: 30,
            itemBuilder: (context, index) {
              return Card(
                elevation: 0,
                color: AppColors.cardBackground,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/house.jpg')),
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10)),
                      height: 150,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'urban-village',
                                style: TextStyle(fontSize: 12),
                              ),
                              Spacer(),
                              Text(
                                '3 lits | 3 chambre',
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          Text(
                            'Goma-Mabanga Nord - Kindu 2',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                '\$200',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.secondary,
                                ),
                              ),
                              Text(
                                ' \\ mois',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w200,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
