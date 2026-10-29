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

    if (status == LoanStatus.onTime) {
      return 0.0;
    }

    final int overdueDays = checkDate.difference(loan.dueDate).inDays;

    double accumulatedFine = 0.0;

    if (overdueDays > 6) {
      int remainingFineableDays = overdueDays - 6;
      int currentWeek = 1;

      while (remainingFineableDays > 0) {
        final int daysInThisWeek = remainingFineableDays > 7
            ? 7
            : remainingFineableDays;
        final double weekDailyRate = currentWeek * 5000.0;

        accumulatedFine += daysInThisWeek * weekDailyRate;

        remainingFineableDays -= daysInThisWeek;
        currentWeek++;
      }
    }

    if (status == LoanStatus.missing) {
      final Book? book = _findBookById(loan.bookId);
      final double replacementPrice = book?.replacementPrice ?? 0.0;
      return accumulatedFine + replacementPrice;
    }

    return accumulatedFine;
  }

  bool borrowBook(
    String bookId,
    String studentId, {
    int quantity = 1,
    DateTime? customDueDate,
  }) {
    final bookIndex = _books.indexWhere((b) => b.id == bookId);
    if (bookIndex == -1 || _books[bookIndex].stock < quantity) {
      return false;
    }

    final String newLoanId = 'L${DateTime.now().millisecondsSinceEpoch}';

    final newLoan = Loan(
      id: newLoanId,
      bookId: bookId,
      studentId: studentId,
      borrowingDate: DateTime.now(),
      dueDate: customDueDate ?? DateTime.now().add(const Duration(days: 7)),
      fineAmount: 0.0,
    );

    _books[bookIndex] = _books[bookIndex].copyWith(
      stock: _books[bookIndex].stock - quantity,
    );

    _loans.add(newLoan);

    notifyListeners();
    return true;
  }

  bool returnBook(String loanId) {
    final loanIndex = _loans.indexWhere((l) => l.id == loanId);
    if (loanIndex == -1) return false;

    final loan = _loans[loanIndex];
    final double finalFine = calculateFine(loan);

    final bookIndex = _books.indexWhere((b) => b.id == loan.bookId);
    if (bookIndex != -1) {
      _books[bookIndex] = _books[bookIndex].copyWith(
        stock: _books[bookIndex].stock + 1,
      );
    }

    _loans[loanIndex] = loan.copyWith(
      returnDate: DateTime.now(),
      fineAmount: finalFine,
    );

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

  void addBook(Book newBook) {
    _books.add(newBook);
    notifyListeners();
  }
}
