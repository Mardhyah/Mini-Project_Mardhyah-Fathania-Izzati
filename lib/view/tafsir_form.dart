import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/constans/colors.dart';
import 'package:mini_project/models/open_ai.dart';
import 'package:mini_project/view_model/tafsir_ai.dart';

class TafsirForm extends StatefulWidget {
  const TafsirForm({Key? key}) : super(key: key);

  @override
  State<TafsirForm> createState() => _TafsirFormState();
}

class _TafsirFormState extends State<TafsirForm> {
  final RecommendationsViewModel modelview = RecommendationsViewModel();
  final TextEditingController budgetController = TextEditingController();
  // final TextEditingController cameraController = TextEditingController();
  List<Choice> responseData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: budgetController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: 'Surah',
                          labelStyle: GoogleFonts.poppins(
                            color: text,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(255, 238, 221, 232)),
                    ),
                    const SizedBox(height: 5),
                    // TextFormField(
                    //   controller: cameraController,
                    //   keyboardType: TextInputType.phone,
                    //   decoration: const InputDecoration(
                    //     labelText: 'Ayat',
                    //     labelStyle: TextStyle(
                    //       color: Colors.black,
                    //     ),
                    //     enabledBorder: UnderlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //     filled: true,
                    //     fillColor: Color(0xFFe7e0eC),
                    //   ),
                    // ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (budgetController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        title: Text(
                          "Peringatan",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          "Mohon isi terlebih dahulu.",
                          style: GoogleFonts.poppins(),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(appPurple),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15.0), // Atur angka sesuai keinginan Anda
                                ),
                              ),
                            ),
                            child: Text(
                              "OK",
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        ],
                      ),
                    );
                    return; // Tidak melanjutkan eksekusi jika ada teks yang kosong
                  }

                  try {
                    GptData newResponseData = await modelview.getTafsirQuran(
                      context,
                      budgetController.text,
                      // cameraController.text,
                    );

                    setState(() {
                      responseData = newResponseData.choices;
                    });
                  } catch (error) {
                    print(error);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(appPurple),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15.0), // Atur angka sesuai keinginan Anda
                    ),
                  ),
                ),
                child: Text(
                  "CARI TAFSIR",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
              if (responseData.isNotEmpty) ...[
                // const SizedBox(height: 30),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var choice in responseData)
                        ListTile(
                          title: Text(
                            choice.text,
                            textAlign: TextAlign.justify,
                            selectionColor: appPurple,
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
