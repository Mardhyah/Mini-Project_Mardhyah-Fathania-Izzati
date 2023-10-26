import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini_project/models/jus.dart' as detail;
import 'package:mini_project/models/surah.dart';
import 'package:mini_project/utils/db/bookmark.dart';
import 'package:sqflite/sqflite.dart';

class HomeViewModel {
  List<Surah> allsurah = [];
  DataBaseManager database = DataBaseManager.instance;
  List<Surah> surahList = [];

  Future<Map<String, dynamic>?> fetchLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> dataLastRead =
        await db.query("bookmark", where: "last_read = 1");
    if (dataLastRead.isEmpty) {
      // tidak ada data lastread
      return null;
    } else {
      // ada data -> ambil index ke 0
      return dataLastRead.first;
    }
  }

  void deleteBookmark(int id) async {
    Database db = await database.db;
    await db.delete("bookmark", where: "id = $id");
  }

  Future<List<Map<String, dynamic>>> fetchBookmark() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allbookmarks =
        await db.query("bookmark", where: "last_read = 0", orderBy: "surah");
    return allbookmarks;
  }

  Future<List<Surah>> fetchSurah() async {
    Uri url = Uri.parse("https://api.quran.gading.dev/surah");
    var res = await http.get(url);

    List? data = (json.decode(res.body) as Map<String, dynamic>)["data"];

    if (data == null || data.isEmpty) {
      return [];
    } else {
      allsurah = data.map((e) => Surah.fromJson(e)).toList();
      surahList = List.from(allsurah); // Copy data ke surahList
      return allsurah;
    }
  }

  List<Surah> searchSurahByName(String query) {
    return surahList
        .where((surah) => surah.name.transliteration.id
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  Future<List<detail.Juz>> fetchJuz() async {
    List<detail.Juz> juzs = [];

    for (int i = 1; i <= 15; i++) {
      Uri url = Uri.parse("https://api.quran.gading.dev/juz/$i");
      var res = await http.get(url);

      if (res.statusCode == 200) {
        Map<String, dynamic> data = json.decode(res.body)["data"];
        detail.Juz juz = detail.Juz.fromJson(data);
        juzs.add(juz);
      } else {
        throw Exception('Failed to load Juz $i');
      }
    }

    return juzs;
  }
}
