import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mini_project/utils/constans/colors.dart';
import 'dart:convert';
import 'package:mini_project/models/detail_surah.dart' as detail;
import 'package:mini_project/models/detail_surah.dart' hide Text;
import 'package:mini_project/utils/db/bookmark.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sqflite/sqflite.dart';

class DetailSurahViewModel {
  AutoScrollController scrollControl = AutoScrollController();
  DataBaseManager database = DataBaseManager.instance;

  Future<bool> addBookmark(bool lastRead, DetailSurah surah, Verse ayat,
      int indexAyat, BuildContext context) async {
    Database db = await DataBaseManager.instance.db;

    bool flagExist = false;

    if (lastRead) {
      await db.delete("bookmark", where: "last_read = 1");
    } else {
      List<Map<String, dynamic>> checkData = await db.query("bookmark",
          where:
              "surah = ? AND number_surah = ? AND ayat = ? AND juz = ? AND via = ? AND index_ayat = ? AND last_read = ?",
          whereArgs: [
            surah.name.transliteration.id.replaceAll("'", "+"),
            surah.number,
            ayat.number.inSurah,
            ayat.meta.juz,
            'surah',
            indexAyat,
            0,
          ]);

      if (checkData.isNotEmpty) {
        flagExist = true;
      }
    }

    if (!flagExist) {
      await db.insert(
        "bookmark",
        {
          "surah": surah.name.transliteration.id.replaceAll("'", "+"),
          "number_surah": surah.number,
          "ayat": ayat.number.inSurah,
          "juz": ayat.meta.juz,
          "via": "surah",
          "index_ayat": indexAyat,
          "last_read": lastRead ? 1 : 0,
        },
      );

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Berhasil menambahkan",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: appPurple,
          duration: Duration(seconds: 2),
        ),
      );
      return true; // Bookmark berhasil ditambahkan
    } else {
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Gagal menambahkan bookmark, bookmark telah tersedia",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: appPurple,
          duration: Duration(seconds: 4),
        ),
      );
      return false; // Gagal menambahkan bookmark karena sudah ada
    }
  }

  Future<detail.DetailSurah> fetchSurah(int surahNumber) async {
    Uri url = Uri.parse("https://api.quran.gading.dev/surah/$surahNumber");
    var res = await http.get(url);

    Map<String, dynamic> data = json.decode(res.body)["data"];

    detail.DetailSurah detailSurah = detail.DetailSurah.fromJson(data);

    return detailSurah;
  }
}
