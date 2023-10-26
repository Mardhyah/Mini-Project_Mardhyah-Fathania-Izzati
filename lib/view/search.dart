import 'package:flutter/material.dart';
import 'package:mini_project/models/surah.dart';
import 'package:mini_project/view/detail_surah_view.dart';

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<Surah> surahList;

  CustomSearchDelegate(this.surahList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Surah> results = surahList
        .where((surah) => surah.name.transliteration.id
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        Surah surah = results[index];
        return ListTile(
          title: Text(surah.name.transliteration.id),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailSurahView(
                  surah: {
                    "name": surah.name.transliteration.id,
                    "number": surah.number,
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Surah> suggestions = surahList
        .where((surah) => surah.name.transliteration.id
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        Surah surah = suggestions[index];
        return ListTile(
          title: Text(surah.name.transliteration.id),
          onTap: () {
            query = surah.name.transliteration.id;
          },
        );
      },
    );
  }
}
