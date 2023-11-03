import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_project/view/surah_home_view.dart';

void main() {
  testWidgets('Check if AppBar title is displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: HomeView(),
    ));

    expect(find.text('Al-Quran Apps'), findsOneWidget);
  });

  testWidgets('Check if last read section is displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: HomeView(),
    ));

    expect(find.text('Terakhir dibaca'), findsOneWidget);
  });

  testWidgets('Check if refresh button is displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: HomeView(),
    ));

    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  testWidgets('Check if last read data is displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: HomeView(),
    ));

    expect(find.text('Loading..'), findsOneWidget);
  });
}
