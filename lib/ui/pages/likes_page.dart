import 'package:flutter/material.dart';
import 'package:palmmobilechalenge/ui/pages/detail_book.dart';
import 'package:palmmobilechalenge/ui/widgets/home_book_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding and decoding
import 'package:palmmobilechalenge/shared/theme.dart';
import 'package:palmmobilechalenge/model/book.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  late Future<List<Book>> _favoriteBooksFuture;
  List<FavBook> _savedFavBooks = []; // List to hold favorite books
  @override
  void initState() {
    super.initState();
    // Load saved favorite books when the page initializes
    _loadDataFromLocal();
  }

  Future<void> _loadDataFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList('favoriteBooks') ?? [];
    List<FavBook> loadedFavBooks = jsonList
        .map((jsonString) => FavBook.fromJson(jsonDecode(jsonString)))
        .toList();
    setState(() {
      _savedFavBooks = loadedFavBooks;
    });
  }

  Future<void> _deleteFavoriteBook(FavBook favBook) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList('favoriteBooks') ?? [];
    jsonList.remove(jsonEncode(favBook.toJson())); // Remove from list
    await prefs.setStringList('favoriteBooks', jsonList); // Save updated list

    // Update UI
    setState(() {
      _savedFavBooks.remove(favBook); // Remove from local list
    });

    _showMessage('Book removed from favorites!');
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      appBar: AppBar(
        title: Text(
          'Favorite Books',
          style: blackTextStyle.copyWith(fontWeight: semiBold),
        ),
        backgroundColor: whiteColor,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: _savedFavBooks.isEmpty
                  ? [
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'No favorite books yet.',
                          style: blackTextStyle.copyWith(fontSize: 18),
                        ),
                      ),
                    ]
                  : _savedFavBooks
                      .where((favBook) => favBook.isFavorite)
                      .map((favBook) {
                      return LikeCard(
                        title: favBook.title,
                        subtitle: favBook.authors[0]['name'],
                        imageUrl:
                            favBook.coverImageUrl ?? 'assets/img_logo_dark.png',
                        onTap: () {
                          _deleteFavoriteBook(favBook);
                        },
                      );
                    }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

extension BookFromJson on Book {
  static Book fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? '',
      coverImageUrl: json['coverImageUrl'],
      authors: List<Map<String, String>>.from(json['authors'] ?? []),
      subjects: List<String>.from(json['subjects'] ?? []),
      id: json['id'] ?? null,
      mediaType: json['mediaType'] ?? '',
      formats: Map<String, String>.from(json['formats'] ?? {}),
    );
  }
}
