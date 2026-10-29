import 'package:flutter/material.dart';

import '../../models/loan.dart';
import '../../viewmodels/library_view_model.dart';
import 'loan_card.dart';

class LoansTab extends StatelessWidget {
  final LibraryViewModel viewModel;

  const LoansTab({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final List<Loan> activeLoans = viewModel.activeLoans;

    if (activeLoans.isEmpty) {
      return const Center(child: Text('No active loans.'));
    }

    return ListView.builder(
      itemCount: activeLoans.length,
      itemBuilder: (context, index) {
        final Loan loan = activeLoans[index];

        return LoanCard(
          loan: loan,
          fineAmount: viewModel.calculateFine(loan),
          status: viewModel.getOverdueStatus(loan),
          onReturnPressed: () {
            final bool success = viewModel.returnBook(loan.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  success
                      ? 'Book returned successfully!'
                      : 'Failed to return book.',
                ),
              ),
            );
          },
        );
      },
    );
  }
}
