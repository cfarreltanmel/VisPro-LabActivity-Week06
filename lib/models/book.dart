class Book {
  final String id;
  final String title;
  final String author;
  final double replacementPrice;
  final bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.replacementPrice,
    required this.isAvailable,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      replacementPrice: (json['replacementPrice'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'replacementPrice': replacementPrice,
      'isAvailable': isAvailable,
    };
  }
}
