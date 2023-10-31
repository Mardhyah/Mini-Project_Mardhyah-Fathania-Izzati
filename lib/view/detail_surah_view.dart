import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/utils/constans/colors.dart';
import 'package:mini_project/models/detail_surah.dart' as detail;
import 'package:mini_project/view_model/detail_surah_viewmodel.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class DetailSurahView extends StatelessWidget {
  final Map<String, dynamic>
      surah; // properti 'surah' yang merupakan data dari surah yang akan ditampilkan di tampilan detail.
  final DetailSurahViewModel viewModel =
      DetailSurahViewModel(); //membuat instansiasi dari kelas DetailSurahViewModel dengan nama viewModel
  final Map<String, dynamic>? bookmark;

  DetailSurahView({super.key, required this.surah, this.bookmark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'SURAH ${surah["name"].toString().toUpperCase()}', //mengambil nilai dari properti "name" dari objek surah
          style: GoogleFonts.poppins(),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<detail.DetailSurah>(
        // panggilan ke fungsi fetchSurah dari objek viewModel, dengan surah["number"] sebagai argumen.
        future: viewModel.fetchSurah(surah["number"]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(appPurpleDark),
              ),
            );
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // Mendapatkan data surah dari snapshot
          detail.DetailSurah? detailSurah = snapshot.data;

          // Cek apakah data surah tidak ditemukan
          if (detailSurah == null) {
            return const Center(
              child: Text('Data Surah tidak ditemukan'),
            );
          }

          // Cek apakah ada bookmark
          if (bookmark != null) {
            viewModel.scrollControl.scrollToIndex(
              bookmark!["index_ayat"] + 2,
              preferPosition: AutoScrollPosition.begin,
            );
          }

          // Membuat list of widgets untuk semua ayat dalam surah
          List<Widget> allAyat =
              List.generate(detailSurah.verses.length, (index) {
            // Mendapatkan detail ayat dari data surah
            detail.Verse? ayat = snapshot.data?.verses[index];

            if (ayat != null) {
              return AutoScrollTag(
                key: ValueKey(index +
                    2), // key unik untuk widget ini, dihasilkan dari indeks ayat
                index: index + 2,
                controller: viewModel
                    .scrollControl, // Controller untuk mengontrol scroll
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 246, 218, 229),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/img/octagonal.png'),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "${index + 1}",
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.grey.shade200,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          title: Center(
                                            child: Text(
                                              "BOOKMARK",
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Pilih jenis bookmark",
                                                style: GoogleFonts.poppins(),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // Menambahkan bookmark "Last Read" ketika tombol "LAST READ" ditekan
                                                      viewModel.addBookmark(
                                                          true,
                                                          detailSurah,
                                                          ayat,
                                                          index,
                                                          context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          appPurple,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "LAST READ",
                                                      style:
                                                          GoogleFonts.poppins(),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      // Menambahkan bookmark biasa ketika tombol "BOOKMARK" ditekan
                                                      viewModel.addBookmark(
                                                          false,
                                                          detailSurah,
                                                          ayat,
                                                          index,
                                                          context);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          appPurple,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "BOOKMARK",
                                                      style:
                                                          GoogleFonts.poppins(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.bookmark_add_outlined),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      ayat.text.arab,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      ayat.text.transliteration.en,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      ayat.translation.id,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          });

          return ListView(
            controller: viewModel.scrollControl,
            padding: const EdgeInsets.all(20),
            children: [
              AutoScrollTag(
                key: const ValueKey(0),
                index: 0,
                controller: viewModel.scrollControl,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          title: Center(
                            child: Text(
                              "TAFSIR ${detailSurah.name.transliteration.id.toUpperCase()}",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          content: Text(
                            detailSurah.tafsir.id,
                            textAlign: TextAlign.justify,
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          appPurpleLight1,
                          appPurpleDark,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            detailSurah.name.transliteration.id.toUpperCase(),
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: appWhite),
                          ),
                          Text(
                            "( ${detailSurah.name.translation.id.toUpperCase()} )",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: appWhite),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${detailSurah.numberOfVerses} Ayat | ${detailSurah.revelation.id}",
                            style: GoogleFonts.poppins(
                                fontSize: 16, color: appWhite),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AutoScrollTag(
                  key: const ValueKey(1),
                  index: 1,
                  controller: viewModel.scrollControl,
                  child: const SizedBox(height: 20)),
              ...allAyat,
            ],
          );
        },
      ),
    );
  }
}
