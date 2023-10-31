import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_project/view/introduction_view.dart';
import 'package:mini_project/view/home_view.dart';

void main() {
  testWidgets('IntroductionView UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: IntroductionView(),
    ));

    // Pastikan teks "Quran App" ditampilkan.
    expect(find.text('Quran App'), findsOneWidget);

    // Ensure that "Learn Quran and\nRecite once everyday" text is displayed.
    expect(find.text('Learn Quran and\nRecite once everyday'), findsOneWidget);

    // Pastikan tombol "Get Started" ditampilkan.
    expect(find.text('Get Started'), findsOneWidget);

    // Pastikan gambar SVG ditampilkan.
    expect(find.byType(SvgPicture), findsOneWidget);

    // Tap the "Get Started" button.
    await tester.tap(find.text('Get Started'));

    // Wait for navigation to complete.
    await tester.pumpAndSettle();

    // Ensure that HomeView is displayed.
    expect(find.byType(HomeView), findsOneWidget);
  });
}
