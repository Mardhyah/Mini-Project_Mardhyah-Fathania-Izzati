import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mini_project/constans/colors.dart';
import 'package:mini_project/models/jus.dart' as detail;
import 'package:mini_project/models/surah.dart';
import 'package:mini_project/view/detail_juz_view.dart';
import 'package:mini_project/view/detail_surah_view.dart';
import 'package:mini_project/view/search.dart';
import 'package:mini_project/view/tafsir_form.dart';
import 'package:mini_project/view_model/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel viewModel = HomeViewModel(); // Inisialisasi view model
  final searchController = TextEditingController();

  void _onSurahTap(BuildContext context, Map<String, dynamic> surahData) {
    String surahName = surahData["name"];
    int surahNumber =
        surahData["number"]; // Pastikan ada "number" dalam data surah
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailSurahView(surah: {
          "name": surahName,
          "number": surahNumber,
          // Kirimkan "number" juga
        }),
      ),
    );
  }

  void _onJuzTap(BuildContext context, detail.Juz juz) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailJuzView(juz: juz),
      ),
    );
  }

  void _deleteBookmark(int id) {
    viewModel.deleteBookmark(id);
    setState(() {
      // Lakukan pembaruan tampilan atau data yang diperlukan di sini
    });
  }

  void _startSearch() {
    showSearch(
      context: context,
      delegate: CustomSearchDelegate(viewModel.surahList),
    );
  }

  void _refreshData() async {
    await viewModel.fetchSurah();
    await viewModel.fetchLastRead();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Al-Quran Apps "),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _refreshData, // Buat fungsi untuk merefresh data
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: _startSearch,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<Map<String, dynamic>?>(
                future: viewModel.fetchLastRead(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            appPurpleLight1,
                            appPurpleDark,
                          ],
                        ),
                      ),
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -38,
                            right: 0,
                            child: SizedBox(
                              width: 180,
                              height: 180,
                              child: SvgPicture.asset('assets/svgs/quran.svg'),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.menu_book_rounded,
                                      color: appWhite,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "Terakhir dibaca",
                                      style: TextStyle(color: appWhite),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Text(
                                  "Loading..",
                                  style: TextStyle(
                                    color: appWhite,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "",
                                  style: TextStyle(
                                    color: appWhite,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  Map<String, dynamic>? lastRead = snapshot.data;
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          appPurpleLight1,
                          appPurpleDark,
                        ],
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onLongPress: () {
                          if (lastRead != null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey.shade200,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  title: const Center(
                                    child: Text(
                                      "LAST READ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Apakah anda yakin untuk menghapus last read?",
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Menutup dialog
                                            },
                                            child: const Text(
                                              "Cancel",
                                              style:
                                                  TextStyle(color: appPurple),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          OutlinedButton(
                                            onPressed: () {
                                              _deleteBookmark(lastRead['id']);
                                              Navigator.of(context)
                                                  .pop(); // Menutup dialog setelah penghapusan
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(appPurple),
                                            ),
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          if (lastRead != null) {
                            _onSurahTap(
                              context,
                              {
                                "name": lastRead["surah"]
                                    .toString()
                                    .replaceAll("+", "'"),
                                "number": lastRead["number_surah"],
                                "bookmark": lastRead,
                              },
                            );
                            print(lastRead);
                          }
                        },
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: -38,
                                right: 0,
                                child: SizedBox(
                                  width: 180,
                                  height: 180,
                                  child:
                                      SvgPicture.asset('assets/svgs/quran.svg'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.menu_book_rounded,
                                          color: appWhite,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Terakhir dibaca",
                                          style: TextStyle(color: appWhite),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    if (lastRead != null)
                                      Text(
                                        lastRead['surah']
                                            .toString()
                                            .replaceAll("+", "'"),
                                        style: const TextStyle(
                                          color: appWhite,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    const SizedBox(height: 10),
                                    Text(
                                      lastRead == null
                                          ? "Belum ada data"
                                          : " Ayat ${lastRead['ayat']}",
                                      style: const TextStyle(
                                        color: appWhite,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const TabBar(
                labelColor: appPurpleDark,
                unselectedLabelColor: Colors.grey,
                indicatorColor: appPurpleDark,
                tabs: [
                  Tab(text: "Surah"),
                  Tab(text: "Tafsir"),
                  Tab(text: "Bookmark"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Surah
                    FutureBuilder<List<Surah>>(
                      future: viewModel.fetchSurah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Surah surah = snapshot.data![index];
                            return ListTile(
                              onTap: () => _onSurahTap(context, {
                                "name": surah.name.transliteration.id,
                                "number": surah.number,
                              }),
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/img/octagonal.png'),
                                  ),
                                ),
                                child: Center(child: Text("${surah.number}")),
                              ),
                              title: Text(
                                surah.name.transliteration.id,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "${surah.numberOfVerses} ayat | ${surah.revelation.id}",
                              ),
                              trailing: Text(surah.name.short),
                            );
                          },
                        );
                      },
                    ),

                    // Juz
                    TafsirForm(),
                    // FutureBuilder<List<detail.Juz>>(
                    //   future: viewModel.fetchJuz(),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.connectionState ==
                    //         ConnectionState.waiting) {
                    //       return Center(
                    //         child: CircularProgressIndicator(),
                    //       );
                    //     }
                    //     if (snapshot.hasError) {
                    //       return Center(
                    //         child: Text('Error: ${snapshot.error}'),
                    //       );
                    //     }

                    //     List<detail.Juz> juzs = snapshot.data!;

                    //     return ListView.builder(
                    //       itemCount: juzs.length,
                    //       itemBuilder: (context, index) {
                    //         detail.Juz juz = juzs[index];

                    //         return ListTile(
                    //           leading: Container(
                    //             height: 40,
                    //             width: 40,
                    //             decoration: BoxDecoration(
                    //               image: DecorationImage(
                    //                 image:
                    //                     AssetImage('assets/img/octagonal.png'),
                    //               ),
                    //             ),
                    //             child: Center(child: Text("${index + 1}")),
                    //           ),
                    //           title: Text("Juz ${juz.juz}"),
                    //           isThreeLine: true,
                    //           subtitle: Column(
                    //             mainAxisSize: MainAxisSize.min,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Text(
                    //                 "Mulai dari ${juz.juzStartInfo} ",
                    //                 style:
                    //                     TextStyle(color: Colors.grey.shade500),
                    //               ),
                    //               Text(
                    //                 "Sampai ${juz.juzEndInfo} ",
                    //                 style:
                    //                     TextStyle(color: Colors.grey.shade500),
                    //               ),
                    //             ],
                    //           ),
                    //           onTap: () => _onJuzTap(context, juz),
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
                    // Bookmark
                    BookmarkListView(viewModel: viewModel),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookmarkListView extends StatefulWidget {
  final HomeViewModel viewModel;

  const BookmarkListView({Key? key, required this.viewModel}) : super(key: key);

  @override
  _BookmarkListViewState createState() => _BookmarkListViewState();
}

class _BookmarkListViewState extends State<BookmarkListView> {
  void _deleteBookmark(int id) {
    widget.viewModel.deleteBookmark(id);
    setState(() {
      // Lakukan pembaruan tampilan atau data yang diperlukan di sini
    });
  }

  void _onSurahTap(BuildContext context, Map<String, dynamic> surahData,
      Map<String, dynamic>? bookmark) {
    String surahName = surahData["name"];
    int surahNumber =
        surahData["number"]; // Pastikan ada "number" dalam data surah
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailSurahView(
          surah: {
            "name": surahName,
            "number": surahNumber,
            // Kirimkan "number" juga
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
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (context, index) {
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
                child: Center(child: Text("${index + 1}")),
              ),
              title: Text("${data['surah'].toString().replaceAll("+", "'")}"),
              subtitle: Text(
                "Ayat ${data['ayat']} - via ${data['via']} ",
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                onPressed: () {
                  _deleteBookmark(data['id']);
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
