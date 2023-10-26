import 'package:flutter/material.dart';
import 'package:mini_project/constans/colors.dart';
import 'package:mini_project/models/detail_surah.dart' as detail;
import 'package:mini_project/view_model/detail_surah_viewmodel.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class DetailSurahView extends StatelessWidget {
  final Map<String, dynamic> surah;
  final DetailSurahViewModel viewModel = DetailSurahViewModel();
  final Map<String, dynamic>? bookmark;
  final Map<String, dynamic>? lastRead;

  DetailSurahView(
      {super.key, required this.surah, this.bookmark, this.lastRead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SURAH ${surah["name"].toString().toUpperCase()}'),
        centerTitle: true,
      ),
      body: FutureBuilder<detail.DetailSurah>(
        future: viewModel.fetchSurah(surah["number"]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          detail.DetailSurah? detailSurah = snapshot.data;
          if (detailSurah == null) {
            return const Center(
              child: Text('Data Surah tidak ditemukan'),
            );
          }

          if (bookmark != null) {
            viewModel.scrollControl.scrollToIndex(
              bookmark!["index_ayat"] + 2,
              preferPosition: AutoScrollPosition.begin,
            );
          }
          print(bookmark);

          List<Widget> allAyat =
              List.generate(detailSurah.verses.length, (index) {
            detail.Verse? ayat = snapshot.data?.verses[index];
            if (ayat != null) {
              return AutoScrollTag(
                key: ValueKey(index + 2),
                index: index + 2,
                controller: viewModel.scrollControl,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
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
                                child: Text("${index + 1}"),
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
                                          title: const Center(
                                            child: Text(
                                              "BOOKMARK",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                "Pilih jenis bookmark",
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
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
                                                    child:
                                                        const Text("LAST READ"),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
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
                                                    child:
                                                        const Text("BOOKMARK"),
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
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.play_arrow),
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
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      ayat.text.transliteration.en,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      ayat.translation.id,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          content: Text(
                            detailSurah.tafsir.id,
                            textAlign: TextAlign.justify,
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
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: appWhite),
                          ),
                          Text(
                            "( ${detailSurah.name.translation.id.toUpperCase()} )",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: appWhite),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "${detailSurah.numberOfVerses} Ayat | ${detailSurah.revelation.id}",
                            style:
                                const TextStyle(fontSize: 16, color: appWhite),
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
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemCount: detailSurah.verses.length,
              //   itemBuilder: (context, index) {
              //     detail.Verse? ayat = snapshot.data?.verses[index];
              //     if (ayat != null) {
              //       return AutoScrollTag(
              //         key: ValueKey(index + 2),
              //         index: index + 2,
              //         controller: viewModel.scrollControl,
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.end,
              //           children: [
              //             Container(
              //               decoration: BoxDecoration(
              //                 color: Colors.grey.shade200,
              //                 borderRadius: BorderRadius.circular(20),
              //               ),
              //               child: Padding(
              //                 padding: const EdgeInsets.symmetric(
              //                   horizontal: 10,
              //                   vertical: 5,
              //                 ),
              //                 child: Row(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Container(
              //                       height: 35,
              //                       width: 35,
              //                       decoration: const BoxDecoration(
              //                         image: DecorationImage(
              //                           image: AssetImage(
              //                               'assets/img/octagonal.png'),
              //                         ),
              //                       ),
              //                       child: Center(
              //                         child: Text("${index + 1}"),
              //                       ),
              //                     ),
              //                     Row(
              //                       children: [
              //                         IconButton(
              //                           onPressed: () {
              //                             showDialog(
              //                               context: context,
              //                               builder: (BuildContext context) {
              //                                 return AlertDialog(
              //                                   backgroundColor:
              //                                       Colors.grey.shade200,
              //                                   shape: RoundedRectangleBorder(
              //                                     borderRadius:
              //                                         BorderRadius.circular(
              //                                             20.0),
              //                                   ),
              //                                   title: const Center(
              //                                     child: Text(
              //                                       "BOOKMARK",
              //                                       style: TextStyle(
              //                                         fontWeight:
              //                                             FontWeight.bold,
              //                                       ),
              //                                     ),
              //                                   ),
              //                                   content: Column(
              //                                     mainAxisSize:
              //                                         MainAxisSize.min,
              //                                     children: [
              //                                       const Text(
              //                                         "Pilih jenis bookmark",
              //                                       ),
              //                                       const SizedBox(height: 10),
              //                                       Row(
              //                                         mainAxisAlignment:
              //                                             MainAxisAlignment
              //                                                 .spaceBetween,
              //                                         children: [
              //                                           ElevatedButton(
              //                                             onPressed: () {
              //                                               viewModel
              //                                                   .addBookmark(
              //                                                       true,
              //                                                       detailSurah,
              //                                                       ayat,
              //                                                       index,
              //                                                       context);
              //                                             },
              //                                             child:
              //                                                 Text("LAST READ"),
              //                                             style: ElevatedButton
              //                                                 .styleFrom(
              //                                               primary: appPurple,
              //                                               shape:
              //                                                   RoundedRectangleBorder(
              //                                                 borderRadius:
              //                                                     BorderRadius
              //                                                         .circular(
              //                                                             10),
              //                                               ),
              //                                             ),
              //                                           ),
              //                                           ElevatedButton(
              //                                             onPressed: () {
              //                                               viewModel
              //                                                   .addBookmark(
              //                                                       false,
              //                                                       detailSurah,
              //                                                       ayat,
              //                                                       index,
              //                                                       context);
              //                                             },
              //                                             child: const Text(
              //                                                 "BOOKMARK"),
              //                                             style: ElevatedButton
              //                                                 .styleFrom(
              //                                               primary: appPurple,
              //                                               shape:
              //                                                   RoundedRectangleBorder(
              //                                                 borderRadius:
              //                                                     BorderRadius
              //                                                         .circular(
              //                                                             10),
              //                                               ),
              //                                             ),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 );
              //                               },
              //                             );
              //                           },
              //                           icon: const Icon(
              //                               Icons.bookmark_add_outlined),
              //                         ),
              //                         IconButton(
              //                           onPressed: () {},
              //                           icon: const Icon(Icons.play_arrow),
              //                         ),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //             const SizedBox(height: 20),
              //             Text(
              //               "${ayat.text.arab}",
              //               textAlign: TextAlign.end,
              //               style: const TextStyle(
              //                 fontSize: 25,
              //               ),
              //             ),
              //             const SizedBox(height: 5),
              //             Text(
              //               ayat.text.transliteration.en,
              //               textAlign: TextAlign.justify,
              //               style: const TextStyle(
              //                 fontSize: 18,
              //                 fontStyle: FontStyle.italic,
              //               ),
              //             ),
              //             const SizedBox(height: 20),
              //             Text(
              //               ayat.translation.id,
              //               textAlign: TextAlign.justify,
              //               style: const TextStyle(
              //                 fontSize: 18,
              //               ),
              //             ),
              //             const SizedBox(height: 50),
              //           ],
              //         ),
              //       );
              //     } else {
              //       return const SizedBox.shrink();
              //     }
              //   },
              // ),
            ],
          );
        },
      ),
    );
  }
}
