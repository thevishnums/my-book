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
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      coverUrl: json['coverUrl']?.toString() ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Create a copy of Book with updated values
  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverUrl,
    bool? isFavorite,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverUrl: coverUrl ?? this.coverUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'Book(id: $id, title: $title, author: $author, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          author == other.author &&
          description == other.description &&
          coverUrl == other.coverUrl &&
          isFavorite == other.isFavorite;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      author.hashCode ^
      description.hashCode ^
      coverUrl.hashCode ^
      isFavorite.hashCode;
}
