// sqlite_manager.dart
//
// Version corrigée et stabilisée (2025)
// Compatible Flutter + sqflite
//
// Dépendances à ajouter dans pubspec.yaml :
//   sqflite: ^2.0.0+4
//   path_provider: ^2.0.0
//   path: ^1.8.0
//   archive: ^3.3.0
//

import 'dart:io';
import 'dart:async';
import 'package:bayer/main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';

typedef MigrationStep = Future<void> Function(Database db, int from, int to);

class SqliteManager {
  final String dbName;
  final List<MigrationStep> _migrations = [];
  Database? _db;

  SqliteManager({this.dbName = 'bayeur.db'});

  /// Enregistre une migration (ex: version 1→2, 2→3, etc.)
  void registerMigration(MigrationStep step) {
    _migrations.add(step);
  }

  /// Ouvre la base + applique automatiquement les migrations
  Future<Database> open() async {
    if (_db != null) return _db!;

    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, dbName);

    final version = _migrations.length + 1;

    _db = await openDatabase(
      dbPath,
      version: version,
      onConfigure: (db) async {
        await db.execute('''PRAGMA foreign_keys = ON''');
      },
      onCreate: (db, ver) async {
        await db.execute('''
            CREATE TABLE IF NOT EXISTS locataires (
              locataire_id TEXT PRIMARY KEY,
              nom varchar(100) NOT NULL,
              email varchar(100) NOT NULL,
              password varchar(255) NOT NULL,
              adresse varchar(255),
              telephone varchar(50),
              created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
              updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP
              )
              ''');

        await db.execute('''
            CREATE TABLE IF NOT EXISTS users (
              user_id TEXT PRIMARY KEY,
              user_name varchar(255) NOT NULL,
              email varchar(100) NOT NULL,
              password varchar(255) NOT NULL,             
              created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
              updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP
              )
              ''');
        await db.execute('''
            CREATE TABLE IF NOT EXISTS proprietes (
              propriete_id TEXT PRIMARY KEY,
              designation varchar(255) NOT NULL,
              type varchar(255) NOT NULL,
              adresse varchar(255) NOT NULL,             
              statut varchar(255) NOT NULL,             
              prix DECIMAL(10,2) NOT NULL,
              description varchar(255) NOT NULL,           
              created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
              updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP
              )
              ''');

        await db.execute('''
              CREATE TABLE IF NOT EXISTS location ( 
              location_id TEXT PRIMARY KEY,
              locataire_id TEXT,
              propriete_id TEXT,
              date_debut timestamp NOT NULL,
              date_fin timestamp NOT NULL,
              loyer_mensuel DECIMAL(10,2),
              statut VARCHAR(50) DEFAULT 'Active',                       
              created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
              updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (locataire_id) REFERENCES locataires(locataire_id),
              FOREIGN KEY (propriete_id) REFERENCES proprietes(propriete_id)
              )
              ''');

        await db.execute('''
              CREATE TABLE IF NOT EXISTS dettes (
              dette_id TEXT PRIMARY KEY,
              locataire_id TEXT,
              montant DECIMAL(10,2),
              description TEXT,
              statut VARCHAR(20) DEFAULT 'Non payé',                                
              created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
              updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (locataire_id) REFERENCES locataire(dette_id)
              )
              ''');

        await db.execute('''
              CREATE TABLE IF NOT EXISTS paiements (
              paiement_id TEXT,
              location_id TEXT,
              montant DECIMAL(10,2),             
              mode_paiement VARCHAR(50),
              created_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
              updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (location_id) REFERENCES location(location_id)
              )
              ''');
      },
      onUpgrade: (db, from, to) async {
        for (var v = from; v < to; v++) {
          final migration = _getMigrationForFromVersion(v);
          if (migration != null) {
            await migration(db, v, v + 1);
          }
        }
      },
    );

    logger.d("BDD OPENED");
    return _db!;
  }

  MigrationStep? _getMigrationForFromVersion(int fromVersion) {
    final idx = fromVersion - 1;
    if (idx >= 0 && idx < _migrations.length) {
      return _migrations[idx];
    }
    return null;
  }

  /// Renommer une colonne par recréation de table
  Future<void> renameColumn({
    required Database db,
    required String table,
    required String oldColumn,
    required String newColumn,
    required List<String> newColumnsDefinition,
    required List<String> copyColumnPairs,
  }) async {
    final tempTable = '${table}_temp_${DateTime.now().millisecondsSinceEpoch}';
    final newColsSql = newColumnsDefinition.join(', ');

    await db.execute('CREATE TABLE $tempTable ($newColsSql);');

    // Construction des colonnes
    final newColNames = copyColumnPairs.map((p) => p.split('=')[0]).join(', ');
    final oldColNames = copyColumnPairs
        .map((p) => p.contains('=') ? p.split('=')[1] : p)
        .join(', ');

    await db.execute(
        'INSERT INTO $tempTable ($newColNames) SELECT $oldColNames FROM $table;');

    await db.execute('DROP TABLE $table;');
    await db.execute('ALTER TABLE $tempTable RENAME TO $table;');
  }

  /// Créer un index (corrigé)
  Future<void> createIndex(
      Database db, String indexName, String tableName, List<String> columns,
      {bool unique = false}) async {
    final uniq = unique ? 'UNIQUE' : '';
    final cols = columns.join(', ');
    await db.execute(
        'CREATE $uniq INDEX IF NOT EXISTS $indexName ON $tableName ($cols);');
  }

  /// Ajouter une colonne
  Future<void> addColumn(
      Database db, String tableName, String columnDef) async {
    await db.execute('ALTER TABLE $tableName ADD COLUMN $columnDef;');
  }

  /// Supprimer une colonne (reconstruction)
  Future<void> dropColumn({
    required Database db,
    required String table,
    required List<String> keepColumnDefinitions,
    required List<String> copyColumnNames,
  }) async {
    final tempTable = '${table}_temp_${DateTime.now().millisecondsSinceEpoch}';
    final newColsSql = keepColumnDefinitions.join(', ');

    await db.execute('CREATE TABLE $tempTable ($newColsSql);');

    final cols = copyColumnNames.join(', ');
    await db
        .execute('INSERT INTO $tempTable ($cols) SELECT $cols FROM $table;');

    await db.execute('DROP TABLE $table;');
    await db.execute('ALTER TABLE $tempTable RENAME TO $table;');
  }

  /// CRUD — insert
  Future<int> insert(String table, Map<String, Object?> values) async {
    final db = await open();
    return await db.insert(table, values);
  }

  /// CRUD — update
  Future<int> update(
      {required String table,
      required Map<String, Object?> values,
      required String where,
      required List<Object?> whereArgs}) async {
    final db = await open();
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  /// CRUD — delete
  Future<int> delete(
      {required String table,
      required String where,
      required List<Object?> whereArgs}) async {
    final db = await open();
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  /// CRUD — query
  Future<List<Map<String, Object?>>> query(String table,
      {String? where, List<Object?>? whereArgs}) async {
    final db = await open();
    return await db.query(table, where: where, whereArgs: whereArgs);
  }

  /// Importer une base depuis un ZIP
  Future<void> importFromZip(File zipFile) async {
    final dir = await getApplicationDocumentsDirectory();
    final bytes = await zipFile.readAsBytes();

    final archive = ZipDecoder().decodeBytes(bytes);

    for (final file in archive) {
      if (file.isFile) {
        final filename = file.name;

        if (filename == dbName ||
            filename.endsWith('.db') ||
            filename.endsWith('.sqlite')) {
          final outPath = p.join(dir.path, filename);
          await File(outPath).writeAsBytes(file.content as List<int>);
        }
      }
    }
  }

  /// Fermer la base
  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}

// // sqlite_manager.dart
// //
// // A self-contained SQLite manager for Flutter (sqflite) that:
// // - opens the database
// // - applies migrations (with ability to rename column, create index, add/drop columns)
// // - provides simple CRUD helpers
// // - exports the DB file into a ZIP archive
// //
// // Dependencies:
// //   sqflite: ^2.0.0+4
// //   path_provider: ^2.0.0
// //   path: ^1.8.0
// //   archive: ^3.3.0
// //
// // Add these to your pubspec.yaml before using this class.
// //
// import 'dart:io';
// import 'dart:async';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:archive/archive.dart';
// import 'package:archive/archive_io.dart';

// typedef MigrationStep = Future<void> Function(Database db, int from, int to);

// class SqliteManager {
//   final String dbName;
//   final List<MigrationStep> _migrations = [];
//   Database? _db;

//   SqliteManager({this.dbName = 'bayeur.db'});

//   /// Register a migration step. Each entry corresponds to upgrading
//   /// from version N to N+1 for the order they are added.
//   void registerMigration(MigrationStep step) {
//     _migrations.add(step);
//   }

//   /// Initialize and open the database. This applies migrations in order.
//   Future<Database> open() async {
//     if (_db != null) return _db!;
//     final dir = await getApplicationDocumentsDirectory();
//     final dbPath = p.join(dir.path, dbName);
//     final version = _migrations.length + 1; // base schema version = 1
//     _db =
//         await openDatabase(dbPath, version: version, onCreate: (db, ver) async {
//       // Initial schema (version 1). If you want to customize,
//       // register a migration that runs for from==0 -> to==1.
//       await db.execute('''
//         CREATE TABLE IF NOT EXISTS example (
//           id INTEGER PRIMARY KEY AUTOINCREMENT,
//           name TEXT,
//           value INTEGER
//         );
//       ''');
//     }, onUpgrade: (db, from, to) async {
//       // Apply migrations sequentially
//       for (var i = from; i < to; i++) {
//         final idx =
//             i; // migration index maps: migrate from i -> i+1 at _migrations[i-1]
//         final migration = _getMigrationForFromVersion(i);
//         if (migration != null) {
//           await migration(db, i, i + 1);
//         }
//       }
//     });
//     return _db!;
//   }

//   MigrationStep? _getMigrationForFromVersion(int fromVersion) {
//     // migrations registered in order: index 0 handles 1->2 (from=1), index 1 handles 2->3 (from=2), ...
//     final idx = fromVersion - 1;
//     if (idx >= 0 && idx < _migrations.length) return _migrations[idx];
//     return null;
//   }

//   /// Helper: rename a column in a table by creating a new table with desired schema,
//   /// copying data, dropping old table, renaming new table.
//   /// NOTE: SQLite < 3.25 doesn't support ALTER TABLE RENAME COLUMN; this method is generic.
//   Future<void> renameColumn({
//     required Database db,
//     required String table,
//     required String oldColumn,
//     required String newColumn,
//     required List<String>
//         newColumnsDefinition, // entire column definitions for the new table, e.g. ["id INTEGER PRIMARY KEY", "newName TEXT", "value INTEGER"]
//     required List<String>
//         copyColumnPairs, // mapping from new column names to old column names, e.g. ["newName=oldName", "value=value"]
//   }) async {
//     final tempTable =
//         '${table}_temp_${DateTime.now().millisecondsSinceEpoch}';
//     final newColsSql = newColumnsDefinition.join(', ');
//     await db.execute('CREATE TABLE $tempTable ($newColsSql);');
//     // Build copy list
//     final cols = copyColumnPairs.map((p) {
//       final parts = p.split('=');
//       final newC = parts[0];
//       final oldC = parts.length > 1 ? parts[1] : parts[0];
//       return '$newC = $oldC';
//     }).toList();
//     // Insert data
//     final newColNames = copyColumnPairs.map((p) => p.split('=')[0]).join(', ');
//     final oldColNames = copyColumnPairs
//         .map((p) => (p.split('=')[1] ?? p.split('=')[0]))
//         .join(', ');
//     await db.execute(
//         'INSERT INTO $tempTable ($newColNames) SELECT $oldColNames FROM $table;');
//     await db.execute('DROP TABLE $table;');
//     await db.execute('ALTER TABLE $tempTable RENAME TO $table;');
//   }

//   /// Create an index if not exists
//   Future<void> createIndex(
//       Database db, String indexName, String tableName, List<String> columns,
//       {bool unique = false}) async {
//     final uniq = unique ? 'UNIQUE' : '';
//     final cols = columns.join(', ');
//     await db.execute(
//         'CREATE \$uniq INDEX IF NOT EXISTS \$indexName ON \$tableName (\$cols);');
//   }

//   /// Add a column (simple ALTER TABLE ADD COLUMN)
//   Future<void> addColumn(
//       Database db, String tableName, String columnDef) async {
//     await db.execute('ALTER TABLE $tableName ADD COLUMN $columnDef;');
//   }

//   /// Drop a column (SQLite doesn't support DROP COLUMN directly).
//   /// This performs: create temp table without column, copy data, swap.
//   Future<void> dropColumn({
//     required Database db,
//     required String table,
//     required List<String>
//         keepColumnDefinitions, // full column defs for new table
//     required List<String>
//         copyColumnNames, // columns to copy from old table to new table (in same order)
//   }) async {
//     final tempTable = '${table}_temp_${DateTime.now().millisecondsSinceEpoch}';
//     final newColsSql = keepColumnDefinitions.join(', ');
//     await db.execute('CREATE TABLE $tempTable ($newColsSql);');
//     final cols = copyColumnNames.join(', ');
//     await db
//         .execute('INSERT INTO $tempTable ($cols) SELECT $cols FROM $table;');
//     await db.execute('DROP TABLE $table;');
//     await db.execute('ALTER TABLE $tempTable RENAME TO $table;');
//   }

//   /// Simple CRUD helpers
//   Future<int> insert(String table, Map<String, Object?> values) async {
//     final db = await open();
//     return await db.insert(table, values);
//   }

//   Future<int> update(String table, Map<String, Object?> values, String where,
//       List<Object?> whereArgs) async {
//     final db = await open();
//     return await db.update(table, values, where: where, whereArgs: whereArgs);
//   }

//   Future<int> delete(
//       String table, String where, List<Object?> whereArgs) async {
//     final db = await open();
//     return await db.delete(table, where: where, whereArgs: whereArgs);
//   }

//   Future<List<Map<String, Object?>>> query(String table,
//       {String? where, List<Object?>? whereArgs}) async {
//     final db = await open();
//     return await db.query(table, where: where, whereArgs: whereArgs);
//   }

//   /// Export the database file to a ZIP archive. Returns the zip File path.
//   // Future<String> exportToZip({String? targetZipName}) async {
//   //   final db = await open();
//   //   // close DB to ensure file is flushed
//   //   await db.close();
//   //   _db = null;

//   //   final dir = await getApplicationDocumentsDirectory();
//   //   final dbPath = p.join(dir.path, dbName);
//   //   final zipName = targetZipName ?? '\${p.basenameWithoutExtension(dbName)}_\${DateTime.now().toIso8601String().replaceAll(':', '-')}.zip';
//   //   final zipPath = p.join(dir.path, zipName);

//   //   final bytes = await File(dbPath).readAsBytes();
//   //   final archive = Archive();
//   //   archive.addFile(ArchiveFile(p.basename(dbPath), bytes.length, bytes));
//   //   final zipData = ZipEncoder().encode(archive)!;
//   //   final outFile = File(zipPath);
//   //   await outFile.writeAsBytes(zipData);

//   //   return zipPath;
//   // }

//   /// Restore DB from a ZIP file containing the dbName file at root
//   Future<void> importFromZip(File zipFile) async {
//     final dir = await getApplicationDocumentsDirectory();
//     final bytes = await zipFile.readAsBytes();
//     final archive = ZipDecoder().decodeBytes(bytes);
//     for (final file in archive) {
//       if (file.isFile) {
//         final filename = file.name;
//         if (filename == dbName ||
//             filename.endsWith('.db') ||
//             filename.endsWith('.sqlite')) {
//           final data = file.content as List<int>;
//           final outPath = p.join(dir.path, filename);
//           await File(outPath).writeAsBytes(data, flush: true);
//         }
//       }
//     }
//   }

//   /// Close DB
//   Future<void> close() async {
//     if (_db != null) {
//       await _db!.close();
//       _db = null;
//     }
//   }
// }
