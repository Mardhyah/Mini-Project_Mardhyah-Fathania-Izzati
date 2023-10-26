import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mini_project/models/detail_surah.dart';
import 'package:mini_project/models/surah.dart';

void main() async {
  Uri url = Uri.parse("https://api.quran.gading.dev/surah");
  var res = await http.get(url);

  //data dari API (raw model) -> Model (yang sudah siapkan)
  List data = (json.decode(res.body) as Map<String, dynamic>)["data"];

  // print(data[113]);

  Surah surahAnnas = Surah.fromJson((data[113]));
  // print(surahAnnas);
  // print(surahAnnas.toJson());

// ini coba masuk ke nested model
// print(surahAnnas.name.long);

  Uri urlAnnas =
      Uri.parse("https://api.quran.gading.dev/surah/${surahAnnas.number}");
  var resAnnas = await http.get(urlAnnas);

  Map<String, dynamic> dataAnnas =
      (json.decode(resAnnas.body) as Map<String, dynamic>)["data"];

  //data dari API (raw model) -> Model (yang sudah siapkan)
  DetailSurah annas = DetailSurah.fromJson(dataAnnas);
  print(annas.verses[0].text.arab);
}
