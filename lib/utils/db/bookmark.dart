import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DataBaseManager {
  DataBaseManager._private();

  static final DataBaseManager instance = DataBaseManager._private();

  Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDB();
    }
    return _db!;
  }

  Future<Database> _initDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();

    String path = join(docDir.path, "Bookmark.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database database, int version) async {
      await database.execute('''
        CREATE TABLE bookmark (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          surah TEXT NOT NULL,
          number_surah INTEGER NOT NULL,
          ayat INTEGER NOT NULL,
          juz INTEGER NOT NULL,
          via TEXT NOT NULL,
          index_ayat INTEGER NOT NULL,
          last_read INTEGER DEFAULT 0
        )
        ''');
    });
  }

  Future<void> closeDB() async {
    final Database db = await instance.db;
    db.close();
  }
}
