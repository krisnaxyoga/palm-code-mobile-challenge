import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:palmmobilechalenge/model/book.dart';

class ApiService {
  static const String apiUrl = 'https://gutendex.com/books/';

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
