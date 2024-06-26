import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:palmmobilechalenge/model/book.dart';

class ApiService {
  static const String apiUrl = 'https://gutendex.com/books/';

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      await _saveBooksToLocal(data); // Simpan data ke local storage
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<void> _saveBooksToLocal(List<dynamic> books) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(books);
    await prefs.setString('books', encodedData);
  }

  Future<List<Book>> getBooksFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('books');
    if (encodedData != null) {
      final List<dynamic> data = json.decode(encodedData);
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('No books found in local storage');
    }
  }

  Future<List<Book>> fetchBooksWithFallback() async {
    try {
      return await fetchBooks();
    } catch (e) {
      return await getBooksFromLocal();
    }
  }
}
