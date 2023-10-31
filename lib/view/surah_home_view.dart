import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/utils/constans/colors.dart';
import 'package:mini_project/models/surah.dart';
import 'package:mini_project/view/bookmark_view.dart';
import 'package:mini_project/view/detail_surah_view.dart';
import 'package:mini_project/view/tafsir_form.dart';
import 'package:mini_project/view_model/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel viewModel = HomeViewModel(); // Inisialisasi view model
  // function untuk menangani ketika surah diklik
  void _onSurahTap(BuildContext context, Map<String, dynamic> surahData) {
    String surahName = surahData["name"];
    int surahNumber = surahData["number"];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailSurahView(
          surah: {
            "name": surahName,
            "number": surahNumber,
          },
        ),
      ),
    );
  }

// function untuk menghapus bookmark (lastread)
  void _deleteBookmark(int id) {
    viewModel.deleteBookmark(id);
    setState(() {});
  }

  // function untuk memuat ulang data
  void _refreshData() async {
    await viewModel.fetchSurah();
    await viewModel.fetchLastRead();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPurpleDark,
        title: Text(
          'Al-Quran Apps',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _refreshData, // Buat fungsi untuk merefresh data
            icon: const Icon(Icons.refresh),
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
                future: viewModel
                    .fetchLastRead(), // pemanggilan  fetchLastRead dari objek viewModel
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Tampilan selama data masih dimuat/loading
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
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.menu_book_rounded,
                                      color: appWhite,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Terakhir dibaca",
                                      style:
                                          GoogleFonts.poppins(color: appWhite),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  // Menampilkan pesan "Loading.." selama proses loading
                                  "Loading..",
                                  style: GoogleFonts.poppins(
                                    color: appWhite,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "",
                                  style: GoogleFonts.poppins(
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

                  // Membuat variabel untuk menyimpan data terakhir yang dibaca.
                  Map<String, dynamic>? lastRead = snapshot.data;

                  // Membuat tampilan untuk menampilkan surah terakhir yang dibaca.
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
                            // Menampilkan dialog konfirmasi untuk menghapus surah terakhir yang dibaca.
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
                                      "LAST READ",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Apakah anda yakin untuk menghapus last read?",
                                        style: GoogleFonts.poppins(),
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
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.poppins(
                                                  color: appPurple),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          OutlinedButton(
                                            onPressed: () {
                                              _deleteBookmark(lastRead[
                                                  'id']); //  memanggil function _deleteBookmark dengan parameter lastRead['id'], yang merupakan ID dari surah terakhir yang dibaca
                                              Navigator.of(context)
                                                  .pop(); // Menutup dialog setelah penghapusan
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(appPurple),
                                            ),
                                            child: Text(
                                              "Delete",
                                              style: GoogleFonts.poppins(
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
                            // Jika 'lastRead' tidak null
                            _onSurahTap(
                              //Panggil fungsi '_onSurahTap' yang terdapat 2 argumen yaitu context dan sebuah map.
                              context,
                              {
                                "name": lastRead["surah"].toString().replaceAll(
                                    "+",
                                    "'"), // nama surah yang diambil dari data lastRead, kemudian diubah menjadi string dan karakter "+" diganti dengan tanda petik satu ("'").
                                "number": lastRead[
                                    "number_surah"], //nomor surah yang diambil dari data lastRead
                                "bookmark": lastRead,
                              },
                            );
                            print(lastRead);
                          }
                        },
                        child: SizedBox(
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
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.menu_book_rounded,
                                          color: appWhite,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Terakhir dibaca',
                                          style: GoogleFonts.poppins(
                                            color: appWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    if (lastRead !=
                                        null) // Memeriksa apakah 'lastRead' tidak null
                                      Text(
                                        lastRead[
                                                'surah'] //Menampilkan nama surah dari 'lastRead'
                                            .toString() // Mengonversi ke tipe String
                                            .replaceAll("+",
                                                "'"), // Mengganti karakter '+' dengan tanda petik satu ("'")
                                        style: GoogleFonts.poppins(
                                          color: appWhite,
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    const SizedBox(height: 10),
                                    Text(
                                      lastRead == null
                                          ? "Belum ada data" // Jika lastRead null, maka teks ini akan ditampilkan
                                          : " Ayat ${lastRead['ayat']}", // Jika lastRead tidak null, maka teks ini akan ditampilkan dengan nomor ayat dari lastRead
                                      style: GoogleFonts.poppins(
                                        color: appWhite,
                                        fontSize: 12,
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
              TabBar(
                labelColor: appPurpleDark,
                unselectedLabelColor: Colors.grey,
                indicatorColor: appPurpleDark,
                tabs: [
                  Tab(
                    child: Text(
                      'Surah',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Tafsir',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Bookmark',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // Surah
                    FutureBuilder<List<Surah>>(
                      future: viewModel
                          .fetchSurah(), //Di sini, viewModel.fetchSurah() adalah fungsi yang mengembalikan Future<List<Surah>>.
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          //jika connectionState adalah ConnectionState.waiting (menunggu),
                          return const Center(
                            child: CircularProgressIndicator(
                              // maka FutureBuilder akan mengembalikan widget yang menampilkan indikator loading.
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(appPurpleDark),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          //memeriksa apakah ada kesalahan selama proses pengambilan data.
                          return Center(
                            child: Text(
                                'Error: ${snapshot.error}'), //Teks yang ditampilkan adalah pesan kesalahan yang diambil dari snapshot.error
                          );
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!
                              .length, //snapshot.data berisi data yang diambil dari Future,
                          itemBuilder: (context, index) {
                            Surah surah = snapshot.data![
                                index]; // Mengambil data Surah dari indeks tertentu di dalam data.
                            return ListTile(
                              onTap: () => _onSurahTap(context, {
                                //memanggil fungsi _onSurahTap dengan memberikan konteks dan data terkait Surah (nama dan nomor) sebagai argumen.
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
                                child: Center(
                                    child: Text(
                                  "${surah.number}", // Menampilkan nomor Surah.
                                  style: GoogleFonts.poppins(),
                                )),
                              ),
                              title: Text(
                                surah.name.transliteration.id,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold, color: text),
                              ),
                              subtitle: Text(
                                "${surah.numberOfVerses} ayat | ${surah.revelation.id}",
                                style: GoogleFonts.poppins(),
                              ),
                              trailing: Text(
                                surah.name.short,
                                style: GoogleFonts.amiri(),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    // Tafsir
                    const TafsirForm(),

                    // Bookmark
                    BookmarkListView(
                        viewModel:
                            viewModel), //widget BookmarkListView dengan view model viewModel yang diberikan sebagai properti.
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
