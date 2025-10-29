import "package:bayer/models/locataire_model.dart";
import "package:flutter/material.dart";

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
        title: Text('Detail de ${widget.locataire.nom}'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Details'),
        ),
      ),
    );
  }
}
