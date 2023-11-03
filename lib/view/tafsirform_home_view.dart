import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_project/utils/constans/colors.dart';
import 'package:mini_project/models/open_ai.dart';
import 'package:mini_project/view_model/tafsir_ai_viewmodel.dart';

class TafsirForm extends StatefulWidget {
  const TafsirForm({Key? key}) : super(key: key);

  @override
  State<TafsirForm> createState() => _TafsirFormState();
}

class _TafsirFormState extends State<TafsirForm> {
  final TafsirViewModel modelview = TafsirViewModel();
  final TextEditingController tafsirController = TextEditingController();
  List<Choice> responseData = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: tafsirController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Mohon isi surah terlebih dahulu.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Nama Surah',
                        focusedBorder: InputBorder.none,
                        labelStyle: GoogleFonts.poppins(
                          color: text,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: appPurpleDark),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 238, 221, 232),
                        suffixIcon: tafsirController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    tafsirController.clear();
                                    responseData = [];
                                  });
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      GptData newResponseData = await modelview.getTafsirQuran(
                        context,
                        tafsirController.text,
                      );

                      setState(() {
                        responseData = newResponseData.choices;
                      });
                    } catch (error) {
                      print(error);
                    }
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(appPurple),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                child: Text(
                  "CARI TAFSIR",
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
              ),
              if (responseData.isNotEmpty) ...[
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
