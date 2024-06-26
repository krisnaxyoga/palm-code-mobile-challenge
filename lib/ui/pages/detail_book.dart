import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding and decoding
import 'package:palmmobilechalenge/shared/theme.dart';
import 'package:palmmobilechalenge/model/book.dart';

class DetailBook extends StatefulWidget {
  const DetailBook({super.key});

  @override
  State<DetailBook> createState() => _DetailBookState();
}

class _DetailBookState extends State<DetailBook> {
  Future<void> _saveFavoriteBook(Book book) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteBooks = prefs.getStringList('favoriteBooks') ?? [];
    favoriteBooks.add(jsonEncode(book.toJson()));
    await prefs.setStringList('favoriteBooks', favoriteBooks);
  }

  @override
  Widget build(BuildContext context) {
    final Book book = ModalRoute.of(context)!.settings.arguments as Book;

    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 54,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(60),
                  decoration: BoxDecoration(
                    color: purpleColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        book.coverImageUrl ?? 'assets/img_logo_dark.png',
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        book.title,
                        style: whiteTextStyle.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        book.authors[0]['name'],
                        style: whiteTextStyle.copyWith(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        book.subjects[0],
                        style: whiteTextStyle.copyWith(
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                        color: redColor,
                        iconSize: 50,
                        onPressed: () {
                          _saveFavoriteBook(book);
                        },
                      ),
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension BookJson on Book {
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'coverImageUrl': coverImageUrl,
      'authors': authors,
      'subjects': subjects,
    };
  }
}
