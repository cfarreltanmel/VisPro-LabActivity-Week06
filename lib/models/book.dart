class Book {
  final String id;
  final int stock;
  final String title;
  final String author;
  final double replacementPrice;

  Book({
    required this.id,
    required this.stock,
    required this.title,
    required this.author,
    required this.replacementPrice,
  });

  bool get isAvailable => stock > 0;

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      stock: json['stock'] as int? ?? 0,
      title: json['title'] as String,
      author: json['author'] as String,
      replacementPrice: (json['replacementPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stock': stock,
      'title': title,
      'author': author,
      'replacementPrice': replacementPrice,
    };
  }

  Book copyWith({
    String? id,
    int? stock,
    String? title,
    String? author,
    double? replacementPrice,
  }) {
    return Book(
      id: id ?? this.id,
      stock: stock ?? this.stock,
      title: title ?? this.title,
      author: author ?? this.author,
      replacementPrice: replacementPrice ?? this.replacementPrice,
    );
  }
}
