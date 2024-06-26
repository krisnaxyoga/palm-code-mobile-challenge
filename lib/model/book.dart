class Book {
  final int id;
  final String title;
  final List<dynamic> authors;
  final List<String> subjects;
  final String mediaType;
  final Map<String, String> formats;
  final String coverImageUrl;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.subjects,
    required this.mediaType,
    required this.formats,
    required this.coverImageUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    var authorsFromJson = json['authors'] as List;
    List<dynamic> authorList = authorsFromJson.map((author) {
      if (author is String) {
        return author;
      } else {
        return {
          'name': author['name'],
          'birth_year': author['birth_year'],
          'death_year': author['death_year'],
        };
      }
    }).toList();

    List<String> subjectsList = json['subjects'].cast<String>();

    String mediaType = json['media_type'];
    Map<String, String> formats = Map<String, String>.from(json['formats']);
    String coverImageUrl = formats['image/jpeg'] ?? '';

    return Book(
      id: json['id'],
      title: json['title'],
      authors: authorList,
      subjects: subjectsList,
      mediaType: mediaType,
      formats: formats,
      coverImageUrl: coverImageUrl,
    );
  }
}
