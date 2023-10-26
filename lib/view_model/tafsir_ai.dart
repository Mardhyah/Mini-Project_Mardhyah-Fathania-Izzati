import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mini_project/constans/open_ai.dart';
import 'package:mini_project/models/open_ai.dart';

class RecommendationsViewModel {
  Future<GptData> getTafsirQuran(
    BuildContext context,
    String surah,
    // String ayat,
  ) async {
    String promptData =
        "berikan saya tafsir Al-Quran dari kementerian agama republik indonesia berdasarkan $surah ";
    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/completions'),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          'Charset': 'utf-8',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": promptData,
          "temperature": 0.4,
          "max_tokens": 500,
          "top_p": 1,
          "frequency_penalty": 0,
          "presence_penalty": 0,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        return GptData.fromJson(responseData);
      } else {
        print('Failed to make API request: ${response.statusCode}');
        throw Exception('Failed to make API request');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }
}
