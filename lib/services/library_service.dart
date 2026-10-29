import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/book.dart';
import '../models/loan.dart';

class LibraryService {
  Future<List<Book>> fetchBooks() async {
    final String response = await rootBundle.loadString(
      'assets/data/books.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((item) => Book.fromJson(item)).toList();
  }

  Future<List<Loan>> fetchLoans() async {
    final String response = await rootBundle.loadString(
      'assets/data/loans.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((item) => Loan.fromJson(item)).toList();
  }
}
