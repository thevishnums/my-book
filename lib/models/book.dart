class Book {
  final String id;
  String title;
  String author;
  String description;
  String coverUrl;
  bool isFavorite;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.description = '',
    this.coverUrl = '',
    this.isFavorite = false,
  });

  // Convert a Book into a Map for SharedPreferences (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverUrl': coverUrl,
      'isFavorite': isFavorite,
    };
  }

  // Convert a Map into a Book object
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
