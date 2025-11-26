import 'package:bayer/main.dart';
import 'package:bayer/services/sqlite_manager.dart';
import 'package:flutter/material.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  SqliteManager sql = SqliteManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  // sql.insert('example', {'name': 'emery', 'value': 'ndalos'});

                  // var data = await sql.query('example');
                  // var elements = data
                  //     .map(
                  //       (e) => Map.from(e),
                  //     )
                  //     .toList();
                  // logger.i('Inserted example data : $elements');
                },
                child: const Text('press')),
            const Text('Profil'),
          ],
        ),
      ),
    );
  }
}
