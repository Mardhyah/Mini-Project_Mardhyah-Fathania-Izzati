import 'package:flutter/material.dart';
import 'package:mini_project/models/jus.dart' as juz_model;

class DetailJuzViewModel {
  juz_model.Juz juz;

  void addBookmark(
    bool isLastRead,
    juz_model.Juz juz,
    juz_model.Verses ayat,
    int index,
    BuildContext context,
  ) {
    // Implementasi dari metode addBookmark
  }

  DetailJuzViewModel({required this.juz});
}
