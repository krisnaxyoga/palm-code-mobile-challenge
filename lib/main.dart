import 'package:flutter/material.dart';
import 'package:palmmobilechalenge/shared/theme.dart';
import 'package:palmmobilechalenge/ui/pages/detail_book.dart';
import 'package:palmmobilechalenge/ui/pages/home_page.dart';
import 'package:palmmobilechalenge/ui/pages/likes_page.dart';
import 'package:palmmobilechalenge/ui/pages/onboarding_page.dart';
import 'package:palmmobilechalenge/ui/pages/splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: lightBackgroundColor,
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: blackColor,
          ),
          titleTextStyle: blackTextStyle.copyWith(
            fontSize: 20,
            fontWeight: bold,
          ),
          backgroundColor: lightBackgroundColor,
        ),
      ),
      // home: SplashPage(),
      routes: {
        '/': (context) => const SplashPage(),
        '/oboarding': (context) => const OnboardingPage(),
        '/home-page': (context) => const HomePage(),
        '/detail-book': (context) => const DetailBook(),
        '/likes': (context) => const LikesPage(),
      },
    );
  }
}
