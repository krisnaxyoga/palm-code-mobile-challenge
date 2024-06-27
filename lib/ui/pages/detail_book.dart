import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:palmmobilechalenge/shared/theme.dart';
import 'package:palmmobilechalenge/model/book.dart';

// Define the FavBook model
class FavBook {
  final String title;
  final String? coverImageUrl;
  final List<dynamic> authors;
  final List<String> subjects;
  bool isFavorite;

  FavBook({
    required this.title,
    this.coverImageUrl,
    required this.authors,
    required this.subjects,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'coverImageUrl': coverImageUrl,
      'authors': authors,
      'subjects': subjects,
      'isFavorite': isFavorite,
    };
  }

  factory FavBook.fromJson(Map<String, dynamic> json) {
    return FavBook(
      title: json['title'],
      coverImageUrl: json['coverImageUrl'],
      authors: json['authors'],
      subjects: List<String>.from(json['subjects']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}

class DetailBook extends StatefulWidget {
  const DetailBook({Key? key}) : super(key: key);

  @override
  _DetailBookState createState() => _DetailBookState();
}

class _DetailBookState extends State<DetailBook> {
  bool _isFavorite = false; // State variable to track favorite status
  late FavBook _favBook; // Store the current FavBook object
  List<FavBook> _savedFavBooks = []; // List to hold favorite books

  @override
  void initState() {
    super.initState();
    _loadDataFromLocal();
  }

  Future<void> _saveFavoriteBook(Book book) async {
    // Create a FavBook instance from the Book object
    FavBook favBook = FavBook(
      title: book.title,
      coverImageUrl: book.coverImageUrl,
      authors: book.authors,
      subjects: book.subjects,
      isFavorite: !_isFavorite, // Toggle favorite status
    );

    // Update _isFavorite based on the current status
    setState(() {
      _isFavorite = !_isFavorite;
      _favBook = favBook;
    });
    // Get SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteBooksJson = prefs.getStringList('favoriteBooks') ?? [];

    // Convert FavBook to JSON and add/remove from the list
    if (_isFavorite) {
      favoriteBooksJson.add(jsonEncode(favBook.toJson()));
    } else {
      var index = favoriteBooksJson.indexWhere((jsonString) {
        var decoded = jsonDecode(jsonString);
        return decoded['title'] == favBook.title;
      });

      if (index != -1) {
        var decoded = jsonDecode(favoriteBooksJson[index]);
        decoded['isFavorite'] = false;
        favoriteBooksJson[index] = jsonEncode(decoded);
      }

      print('${favBook.isFavorite}');
      // Update local FavBook object's isFavorite
      // Set isFavorite to false locally
      _favBook.isFavorite = false;
    }

    // Save updated list to SharedPreferences
    await prefs.setStringList('favoriteBooks', favoriteBooksJson);

    // Show success message
    if (_isFavorite) {
      _showMessage('Book added to favorites!');
    } else {
      _showMessage('Book removed from favorites!');
    }
  }

  Future<void> _loadDataFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList('favoriteBooks') ?? [];
    List<FavBook> loadedFavBooks = jsonList
        .map((jsonString) => FavBook.fromJson(jsonDecode(jsonString)))
        .toList();

    // Set _savedFavBooks and check if current book is already favorited
    setState(() {
      _savedFavBooks = loadedFavBooks;
      _isFavorite = _savedFavBooks.any((favBook) =>
          favBook.title == _favBook.title && favBook.isFavorite == true);
    });
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
    final Book book = ModalRoute.of(context)!.settings.arguments as Book;
    _favBook = FavBook(
      title: book.title,
      coverImageUrl: book.coverImageUrl,
      authors: book.authors,
      subjects: book.subjects,
      isFavorite: false,
    );

    return Scaffold(
      backgroundColor: blueColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 54,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      height: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            book.coverImageUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              // topRight: Radius.circular(20),
                            ),
                          ),
                          child: IconButton(
                            icon: _isFavorite
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_border),
                            color: _isFavorite ? Colors.red : redColor,
                            iconSize: 50,
                            onPressed: () {
                              _saveFavoriteBook(book);
                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 22,
                      ),
                      decoration: BoxDecoration(
                        color: whiteColor,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            book.title,
                            style: blackTextStyle.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            book.authors[0]['name'],
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Text(
                            book.subjects[0],
                            style: blackTextStyle.copyWith(
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
