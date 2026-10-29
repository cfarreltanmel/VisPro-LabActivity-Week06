import 'package:flutter/material.dart';

import '../../models/loan.dart';
import '../../viewmodels/library_view_model.dart';

class LoanCard extends StatelessWidget {
  final Loan loan;
  final double fineAmount;
  final LoanStatus status;
  final VoidCallback onReturnPressed;

  const LoanCard({
    super.key,
    required this.loan,
    required this.fineAmount,
    required this.status,
    required this.onReturnPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isOverdue =
        status == LoanStatus.overdue || status == LoanStatus.missing;

    final now = DateTime.now();
    final overdueDays = now.difference(loan.dueDate).inDays;

    final dueDateStr =
        "${loan.dueDate.year}-${loan.dueDate.month.toString().padLeft(2, '0')}-${loan.dueDate.day.toString().padLeft(2, '0')}";

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isNarrow = constraints.maxWidth < 250;

            final content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    Text(
                      'Loan ID: ${loan.id}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isOverdue
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status.name.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isOverdue
                              ? theme.colorScheme.onError
                              : theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Book ID: ${loan.bookId} | Student: ${loan.studentId}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 4),

                Text(
                  'Due Date: $dueDateStr'
                  '${overdueDays > 0 ? " ($overdueDays days overdue)" : ""}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isOverdue
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fine: Rp ${fineAmount.toStringAsFixed(0)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: fineAmount > 0
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );

            final returnButton = FilledButton(
              onPressed: onReturnPressed,
              child: const Text('Return'),
            );

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [content, const SizedBox(height: 12), returnButton],
              );
            }

            return Row(
              children: [
                Expanded(child: content),
                const SizedBox(width: 8),
                returnButton,
              ],
            );
          },
        ),
      ),
    );
  }
}
