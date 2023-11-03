import 'package:flutter/material.dart';
import 'package:mini_project/utils/constans/colors.dart';
import 'package:mini_project/view/introduction_view.dart';
import 'package:mini_project/view/surah_home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appLight,
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroductionView(),
        '/home': (context) => const HomeView(),
      },
    );
  }
}
