import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/utils/constans/colors.dart';
import 'package:mini_project/view/detail_surah_view.dart';
import 'package:mini_project/view_model/home_viewmodel.dart';

class BookmarkListView extends StatefulWidget {
  final HomeViewModel viewModel;

  const BookmarkListView({Key? key, required this.viewModel}) : super(key: key);

  @override
  BookmarkListViewState createState() => BookmarkListViewState();
}

class BookmarkListViewState extends State<BookmarkListView> {
//function yang digunakan untuk menghapus bookmark berdasarkan ID.
  void _deleteBookmark(int id) {
    widget.viewModel.deleteBookmark(id);
    setState(() {});
  }

  void _onSurahTap(BuildContext context, Map<String, dynamic> surahData,
      Map<String, dynamic> bookmark) {
    String surahName =
        surahData["name"]; //mengambil nilai "name" dan "number" dari surahData
    int surahNumber = surahData["number"];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailSurahView(
          surah: {
            "name": surahName,
            "number": surahNumber,
          },
          bookmark: bookmark,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.viewModel.fetchBookmark(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(appPurpleDark),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        return ListView.builder(
          itemCount:
              snapshot.data!.length, //Jumlah item adalah panjang dari data
          itemBuilder: (context, index) {
            //Mengambil data pada indeks tertentu dari daftar snapshot
            Map<String, dynamic> data = snapshot.data![index];
            return ListTile(
              onTap: () => _onSurahTap(
                  context,
                  {
                    "name": data["surah"].toString().replaceAll("+", "'"),
                    "number": data["number_surah"],
                    "bookmark": data,
                  },
                  data),
              leading: Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/octagonal.png'),
                  ),
                ),
                child: Center(
                    child: Text(
                  "${index + 1}", // Menampilkan nomor urutan surah
                  style: GoogleFonts.poppins(),
                )),
              ),
              title: Text(
                data['surah']
                    .toString()
                    .replaceAll("+", "'"), // Menampilkan nama surah
                style: GoogleFonts.poppins(),
              ),
              subtitle: Text(
                "Ayat ${data['ayat']} ", // Menampilkan informasi jumlah ayat
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
              trailing: IconButton(
                onPressed: () {
                  _deleteBookmark(data[
                      'id']); // Memanggil fungsi _deleteBookmark dengan parameter id dari data surah
                },
                icon: const Icon(Icons.delete),
              ),
            );
          },
        );
      },
    );
  }
}
