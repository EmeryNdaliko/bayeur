import 'package:bayer/costante/app_colors.dart';
import 'package:bayer/models/property_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PropertyForm extends StatefulWidget {
  const PropertyForm({super.key});

  @override
  State<PropertyForm> createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm> {
  int selectedIndex = 0;
  String selectedProperty = '';
  void onSeleceted(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 5,
          children: [
            const BarreWidget(),
            const Text(
              'Nouvelle propriété',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Wrap(
              runSpacing: 5,
              spacing: 5,
              children: TypePropriete.values
                  .map((e) => InputChip(
                        selectedColor: AppColors.primary,
                        checkmarkColor:
                            selectedIndex == TypePropriete.values.indexOf(e)
                                ? AppColors.background
                                : null,
                        selected:
                            selectedIndex == TypePropriete.values.indexOf(e),
                        label: Text(
                          e.name.substring(0, 1).toUpperCase() +
                              e.name.substring(1),
                          style: TextStyle(
                              color: selectedIndex ==
                                      TypePropriete.values.indexOf(e)
                                  ? AppColors.background
                                  : null),
                        ),
                        onPressed: () {
                          onSeleceted(TypePropriete.values.indexOf(e));
                          setState(() {
                            selectedProperty = e.name;
                          });

                          print(e.name);
                        },
                      ))
                  .toList(),
            ),
            const TextField(
              decoration: InputDecoration(
                isDense: true,
                hint: Text('Surface'),
                border: OutlineInputBorder(),
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                isDense: true,
                hint: Text('Nombre de chambre'),
                border: OutlineInputBorder(),
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                isDense: true,
                hint: Text('Adresse'),
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                EasyLoading.showToast('Ajout propriété');
              },
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                    child: Text(
                  'Enregister',
                  style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BarreWidget extends StatelessWidget {
  const BarreWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: 40,
      height: 5,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(10)),
    );
  }
}
