class Loan {
  final String id;
  final String bookId;
  final String studentId;
  final DateTime borrowingDate;
  final DateTime dueDate;
  final DateTime? returnDate;
  final double fineAmount;

  Loan({
    required this.id,
    required this.bookId,
    required this.studentId,
    required this.borrowingDate,
    required this.dueDate,
    this.returnDate,
    required this.fineAmount,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'] as String,
      bookId: json['bookId'] as String,
      studentId: json['studentId'] as String,
      borrowingDate: DateTime.parse(json['borrowingDate'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      returnDate: json['returnDate'] != null
          ? DateTime.parse(json['returnDate'] as String)
          : null,
      fineAmount: (json['fineAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'studentId': studentId,
      'borrowingDate': borrowingDate.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'fineAmount': fineAmount,
    };
  }
}
