import 'package:flutter/material.dart';

import '../../models/book.dart';

class BookListTile extends StatelessWidget {
  final Book book;
  final VoidCallback onBorrowPressed;

  const BookListTile({
    super.key,
    required this.book,
    required this.onBorrowPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = book.stock > 0;
    final theme = Theme.of(context);

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
                Text(
                  book.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Author: ${book.author}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Chip(
                  labelPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  label: Text(
                    isAvailable ? 'Stock: ${book.stock}' : 'Out of Stock',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isAvailable
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onErrorContainer,
                    ),
                  ),
                  backgroundColor: isAvailable
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.errorContainer,
                ),
              ],
            );

            final borrowButton = FilledButton.tonal(
              onPressed: isAvailable ? onBorrowPressed : null,
              child: const Text('Borrow'),
            );

            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [content, const SizedBox(height: 8), borrowButton],
              );
            }

            return Row(
              children: [
                Expanded(child: content),
                const SizedBox(width: 8),
                borrowButton,
              ],
            );
          },
        ),
      ),
    );
  }
}
