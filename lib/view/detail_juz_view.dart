// import 'package:flutter/material.dart';
// import 'package:mini_project/models/jus.dart' as juz_model;

// class DetailJuzView extends StatelessWidget {
//   final juz_model.Juz juz;

//   const DetailJuzView({Key? key, required this.juz}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'JUZ ${juz.juz}',
//         ),
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(20),
//         itemCount: juz.verses?.length ??
//             0, // Menggunakan verses untuk menentukan jumlah ayat
//         itemBuilder: (context, index) {
//           if (juz.verses == null || juz.verses!.isEmpty) {
//             return const Center(
//               child: Text("Tidak ada data"),
//             );
//           }

//           juz_model.Verses ayat =
//               juz.verses![index]; // Mengakses ayat dari list verses
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   borderRadius: BorderRadius.circular(
//                       20), // Sesuaikan dengan sudut yang Anda inginkan
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 5,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         height: 35,
//                         width: 35,
//                         decoration: const BoxDecoration(
//                             image: DecorationImage(
//                                 image: AssetImage('assets/img/octagonal.png'))),
//                         child: Center(
//                           child: Text("${ayat.number?.inSurah}"),
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           IconButton(
//                             onPressed: () {},
//                             icon: const Icon(Icons.bookmark_add_outlined),
//                           ),
//                           IconButton(
//                             onPressed: () {},
//                             icon: const Icon(Icons.play_arrow),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 ayat.text?.arab ??
//                     '', // Menambahkan null check dan memberikan nilai default
//                 textAlign: TextAlign.end,
//                 style: const TextStyle(
//                   fontSize: 25,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 ayat.text?.transliteration?.en ??
//                     '', // Menambahkan null check dan memberikan nilai default
//                 textAlign: TextAlign.justify,
//                 style:
//                     const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 ayat.translation?.id ??
//                     '', // Menambahkan null check dan memberikan nilai default
//                 textAlign: TextAlign.justify,
//                 style: const TextStyle(
//                   fontSize: 18,
//                 ),
//               ),
//               const SizedBox(height: 50),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
