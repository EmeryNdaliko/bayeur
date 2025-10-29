import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocataireForm extends StatefulWidget {
  const LocataireForm({super.key});

  @override
  State<LocataireForm> createState() => _LocataireFormState();
}

class _LocataireFormState extends State<LocataireForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Nouveau Locataire",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Expanded(
            child: Form(
              child: Column(
                spacing: 5,
                children: [
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Noms",
                        isDense: true,
                        border: OutlineInputBorder()),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Email",
                        isDense: true,
                        border: OutlineInputBorder()),
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Mot de passe",
                        isDense: true,
                        border: OutlineInputBorder()),
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('Enregistrer'))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
