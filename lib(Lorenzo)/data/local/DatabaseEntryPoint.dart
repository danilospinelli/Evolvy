import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabaseService {
  AppDatabaseService._();

  static final AppDatabaseService instance = AppDatabaseService._();
  static const String _dbName = 'app_nutrition.db';
  static const int _dbVersion = 1;

  Future<Database>? _databaseFuture;

  Future<Database> get database {
    _databaseFuture ??= _open();
    return _databaseFuture!;
  }

  Future<Database> _open() async {
    if (!kIsWeb &&
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbFolder = await getDatabasesPath();
    final dbPath = p.join(dbFolder, _dbName);

    return openDatabase(
      dbPath,
      version: _dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
					CREATE TABLE alimenti (
						id INTEGER PRIMARY KEY AUTOINCREMENT,
						nome TEXT NOT NULL,
						kcal REAL NOT NULL,
						proteine REAL,
						carboidrati REAL,
						grassi REAL
					)
				''');

        await db.execute('''
					CREATE TABLE diario_alimentare (
						id INTEGER PRIMARY KEY AUTOINCREMENT,
						alimento_id INTEGER NOT NULL,
						quantita_grammi REAL NOT NULL,
						pasto TEXT NOT NULL,
						data_log DATE DEFAULT CURRENT_DATE,
						FOREIGN KEY (alimento_id) REFERENCES alimenti (id)
					)
				''');

        await db.execute(
          'CREATE INDEX idx_diario_data ON diario_alimentare(data_log)',
        );
        await db.execute(
          'CREATE INDEX idx_diario_pasto ON diario_alimentare(pasto)',
        );
        await db.execute(
          'CREATE INDEX idx_diario_alimento ON diario_alimentare(alimento_id)',
        );

        await _seedAlimenti(db);
      },
    );
  }

  Future<void> _seedAlimenti(DatabaseExecutor db) async {
    final alimenti = <Map<String, dynamic>>[
      {
        'nome': 'Pasta di semola',
        'kcal': 353,
        'proteine': 13.0,
        'carboidrati': 72.0,
        'grassi': 1.5,
      },
      {
        'nome': 'Pane bianco',
        'kcal': 265,
        'proteine': 9.0,
        'carboidrati': 49.0,
        'grassi': 3.2,
      },
      {
        'nome': 'Pane integrale',
        'kcal': 250,
        'proteine': 13.0,
        'carboidrati': 43.0,
        'grassi': 3.5,
      },
      {
        'nome': 'Patate',
        'kcal': 85,
        'proteine': 2.0,
        'carboidrati': 17.0,
        'grassi': 0.1,
      },
      {
        'nome': 'Avena',
        'kcal': 389,
        'proteine': 16.9,
        'carboidrati': 66.3,
        'grassi': 6.9,
      },
      {
        'nome': 'Gallette di riso',
        'kcal': 382,
        'proteine': 8.2,
        'carboidrati': 81.5,
        'grassi': 2.8,
      },
      {
        'nome': 'Uova intere',
        'kcal': 155,
        'proteine': 13.0,
        'carboidrati': 1.1,
        'grassi': 11.0,
      },
      {
        'nome': 'Salmone fresco',
        'kcal': 208,
        'proteine': 20.0,
        'carboidrati': 0.0,
        'grassi': 13.0,
      },
      {
        'nome': 'Tonno in scatola (sgocciolato)',
        'kcal': 116,
        'proteine': 26.0,
        'carboidrati': 0.0,
        'grassi': 1.0,
      },
      {
        'nome': 'Manzo (taglio magro)',
        'kcal': 250,
        'proteine': 26.0,
        'carboidrati': 0.0,
        'grassi': 15.0,
      },
      {
        'nome': 'Tofu',
        'kcal': 76,
        'proteine': 8.0,
        'carboidrati': 1.9,
        'grassi': 4.8,
      },
      {
        'nome': 'Latte intero',
        'kcal': 61,
        'proteine': 3.2,
        'carboidrati': 4.8,
        'grassi': 3.6,
      },
      {
        'nome': 'Yogurt greco 0%',
        'kcal': 52,
        'proteine': 10.0,
        'carboidrati': 3.0,
        'grassi': 0.0,
      },
      {
        'nome': 'Parmigiano Reggiano',
        'kcal': 392,
        'proteine': 33.0,
        'carboidrati': 0.0,
        'grassi': 28.4,
      },
      {
        'nome': 'Mozzarella di vacca',
        'kcal': 253,
        'proteine': 18.0,
        'carboidrati': 1.0,
        'grassi': 19.5,
      },
      {
        'nome': 'Banana',
        'kcal': 89,
        'proteine': 1.1,
        'carboidrati': 22.8,
        'grassi': 0.3,
      },
      {
        'nome': 'Arancia',
        'kcal': 47,
        'proteine': 0.9,
        'carboidrati': 11.8,
        'grassi': 0.1,
      },
      {
        'nome': 'Zucchine',
        'kcal': 17,
        'proteine': 1.2,
        'carboidrati': 3.1,
        'grassi': 0.3,
      },
      {
        'nome': 'Broccoli',
        'kcal': 34,
        'proteine': 2.8,
        'carboidrati': 6.6,
        'grassi': 0.4,
      },
      {
        'nome': 'Spinaci',
        'kcal': 23,
        'proteine': 2.9,
        'carboidrati': 3.6,
        'grassi': 0.4,
      },
      {
        'nome': 'Pomodori',
        'kcal': 18,
        'proteine': 0.9,
        'carboidrati': 3.9,
        'grassi': 0.2,
      },
      {
        'nome': 'Burro di arachidi',
        'kcal': 588,
        'proteine': 25.0,
        'carboidrati': 20.0,
        'grassi': 50.0,
      },
      {
        'nome': 'Noci',
        'kcal': 654,
        'proteine': 15.2,
        'carboidrati': 13.7,
        'grassi': 65.2,
      },
      {
        'nome': 'Cioccolato fondente 70%',
        'kcal': 598,
        'proteine': 7.8,
        'carboidrati': 36.6,
        'grassi': 42.6,
      },
      {
        'nome': 'Avocado',
        'kcal': 160,
        'proteine': 2.0,
        'carboidrati': 8.5,
        'grassi': 14.7,
      },
      {
        'nome': 'Burro',
        'kcal': 717,
        'proteine': 0.8,
        'carboidrati': 0.1,
        'grassi': 81.0,
      },
    ];

    final batch = db.batch();
    for (final alimento in alimenti) {
      batch.insert('alimenti', alimento);
    }
    await batch.commit(noResult: true);
  }
}
