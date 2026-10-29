import 'package:flutter/foundation.dart';

import '../models/book.dart';
import '../models/loan.dart';
import '../services/library_service.dart';

enum LoanStatus { onTime, overdue, missing, returned }

class LibraryViewModel extends ChangeNotifier {
  final LibraryService _libraryService;

  static const int missingStatusThreshold = 180;

  LibraryViewModel({LibraryService? libraryService})
    : _libraryService = libraryService ?? LibraryService();

  List<Book> _books = [];
  List<Loan> _loans = [];
  bool _isLoading = false;

  List<Book> get books => List.unmodifiable(_books);
  List<Loan> get loans => List.unmodifiable(_loans);
  bool get isLoading => _isLoading;

  List<Loan> get activeLoans =>
      _loans.where((loan) => loan.returnDate == null).toList();

  List<Loan> get overdueLoans => _loans
      .where(
        (loan) =>
            loan.returnDate == null &&
            getOverdueStatus(loan) == LoanStatus.overdue,
      )
      .toList();

  Future<void> loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _books = await _libraryService.fetchBooks();
      _loans = await _libraryService.fetchLoans();
    } catch (e) {
      debugPrint("Error loading data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  LoanStatus getOverdueStatus(Loan loan, {DateTime? customCurrentDate}) {
    final DateTime checkDate =
        loan.returnDate ?? customCurrentDate ?? DateTime.now();

    if (loan.returnDate != null) {
      return LoanStatus.returned;
    }

    if (checkDate.isBefore(loan.dueDate) ||
        checkDate.isAtSameMomentAs(loan.dueDate)) {
      return LoanStatus.onTime;
    }

    final int overdueDays = checkDate.difference(loan.dueDate).inDays;

    if (overdueDays >= missingStatusThreshold) {
      return LoanStatus.missing;
    }

    return LoanStatus.overdue;
  }

  double calculateFine(Loan loan, {DateTime? customCurrentDate}) {
    if (loan.returnDate != null) {
      return loan.fineAmount;
    }

    final DateTime checkDate = customCurrentDate ?? DateTime.now();

    final LoanStatus status = getOverdueStatus(
      loan,
      customCurrentDate: checkDate,
    );

    if (status == LoanStatus.missing) {
      final Book? book = _findBookById(loan.bookId);
      return book?.replacementPrice ?? 0.0;
    }

    if (status == LoanStatus.onTime) {
      return 0.0;
    }

    final int overdueDays = checkDate.difference(loan.dueDate).inDays;

    if (overdueDays <= 6) {
      return 0.0;
    }

    double totalFine = 0.0;
    int remainingFineableDays = overdueDays - 6;
    int currentWeek = 1;

    while (remainingFineableDays > 0) {
      final int daysInThisWeek = remainingFineableDays > 7
          ? 7
          : remainingFineableDays;
      final double weekDailyRate = currentWeek * 5000.0;

      totalFine += daysInThisWeek * weekDailyRate;

      remainingFineableDays -= daysInThisWeek;
      currentWeek++;
    }

    return totalFine;
  }

  bool borrowBook(String bookId, String studentId, {int quantity = 1}) {
    final Book? book = _findBookById(bookId);

    if (book == null || quantity <= 0 || book.stock < quantity) {
      return false;
    }

    final DateTime now = DateTime.now();
    final DateTime dueDate = now.add(const Duration(days: 7));

    for (int i = 0; i < quantity; i++) {
      _loans.add(
        Loan(
          id: 'L${DateTime.now().millisecondsSinceEpoch}_$i',
          bookId: bookId,
          studentId: studentId,
          borrowingDate: now,
          dueDate: dueDate,
          returnDate: null,
          fineAmount: 0.0,
        ),
      );
    }

    _updateBookStock(bookId, book.stock - quantity);
    notifyListeners();
    return true;
  }

  bool returnBook(String loanId) {
    final int loanIndex = _loans.indexWhere((l) => l.id == loanId);
    if (loanIndex == -1) return false;

    final Loan loan = _loans[loanIndex];
    if (loan.returnDate != null) return false;

    final DateTime now = DateTime.now();
    final double finalFine = calculateFine(loan, customCurrentDate: now);

    _loans[loanIndex] = Loan(
      id: loan.id,
      bookId: loan.bookId,
      studentId: loan.studentId,
      borrowingDate: loan.borrowingDate,
      dueDate: loan.dueDate,
      returnDate: now,
      fineAmount: finalFine,
    );

    final Book? book = _findBookById(loan.bookId);
    if (book != null) {
      _updateBookStock(loan.bookId, book.stock + 1);
    }

    notifyListeners();
    return true;
  }

  Book? _findBookById(String bookId) {
    try {
      return _books.firstWhere((b) => b.id == bookId);
    } catch (_) {
      return null;
    }
  }

  void _updateBookStock(String bookId, int newStock) {
    final int bookIndex = _books.indexWhere((b) => b.id == bookId);
    if (bookIndex != -1) {
      _books[bookIndex] = _books[bookIndex].copyWith(stock: newStock);
    }
  }
}
