import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini_project/models/surah.dart';
import 'package:mini_project/utils/db/bookmark.dart';
import 'package:sqflite/sqflite.dart';

class HomeViewModel {
  List<Surah> allsurah = [];
  DataBaseManager database = DataBaseManager.instance;

  // function asinkron yang mengambil data terakhir yang dibaca dari database.
  Future<Map<String, dynamic>?> fetchLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> dataLastRead = await db.query("bookmark",
        where:
            "last_read = 1"); //Mengambil data dari tabel "bookmark" di mana last_read adalah 1. mengindikasikan surah terakhir yang dibaca.
    if (dataLastRead.isEmpty) {
      // tidak ada data lastread
      return null;
    } else {
      return dataLastRead
          .first; //Jika ada, maka data pertama dari hasil query akan dikembalikan.
    }
  }

  //function ini menghapus bookmark berdasarkan ID dari database.
  void deleteBookmark(int id) async {
    Database db = await database.db;
    await db.delete("bookmark",
        where:
            "id = $id"); //Menghapus entri di tabel "bookmark" berdasarkan ID.
  }

// function ini mengambil semua bookmark dari database.
  Future<List<Map<String, dynamic>>> fetchBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allbookmarks =
        await db.query("bookmark", where: "last_read = 0", orderBy: "surah");
    return allbookmarks;
  }

// function ini mengambil data Surah
  Future<List<Surah>> fetchSurah() async {
    try {
      final Uri url = Uri.parse("https://api.quran.gading.dev/surah");
      var res = await http.get(url);

      if (res.statusCode == 200) {
        List? data = (json.decode(res.body) as Map<String, dynamic>)["data"];

        if (data == null || data.isEmpty) {
          return [];
        } else {
          allsurah = data.map((e) => Surah.fromJson(e)).toList();
          return allsurah;
        }
      } else {
        throw Exception('Gagal memuat data surah: ${res.statusCode}');
      }
    } catch (error) {
      return [];
    }
  }
}
