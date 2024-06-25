class Book {
  final int id;
  final String title;
  final List<String> authors;

  Book({required this.id, required this.title, required this.authors});

  factory Book.fromJson(Map<String, dynamic> json) {
    var authorsFromJson = json['authors'] as List;
    List<String> authorList =
        authorsFromJson.map((author) => author['name'] as String).toList();

    return Book(
      id: json['id'],
      title: json['title'],
      authors: authorList,
    );
  }
}
