import 'package:flutter/material.dart';
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

  Future<List<Book>> _loadFavoriteBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteBooksJson = prefs.getStringList('favoriteBooks');
    if (favoriteBooksJson == null) {
      return [];
    }
    return favoriteBooksJson
        .map((bookJson) {
          try {
            return Book.fromJson(jsonDecode(bookJson));
          } catch (e) {
            // Log error and skip this entry if JSON parsing fails
            print('Error parsing book JSON: $e');
            return null;
          }
        })
        .where((book) => book != null)
        .toList()
        .cast<Book>();
  }

  @override
  void initState() {
    super.initState();
    _favoriteBooksFuture = _loadFavoriteBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      appBar: AppBar(
        title: Text('Favorite Books'),
        backgroundColor: purpleColor,
      ),
      body: FutureBuilder<List<Book>>(
        future: _favoriteBooksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child:
                    Text('Failed to load favorite books: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite books found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                return ListTile(
                  leading: Image.network(
                      book.coverImageUrl ?? 'assets/img_logo_dark.png'),
                  title: Text(book.title),
                  subtitle: Text(book.authors[0]['name']),
                );
              },
            );
          }
        },
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
