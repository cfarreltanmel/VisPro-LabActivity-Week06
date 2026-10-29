import 'package:flutter/material.dart';

import '../../models/book.dart';
import '../../viewmodels/library_view_model.dart';
import '../borrow_book_screen.dart';
import 'book_list_tile.dart';

class CatalogueTab extends StatelessWidget {
  final LibraryViewModel viewModel;

  const CatalogueTab({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (viewModel.books.isEmpty) {
      return const Center(child: Text('No books available.'));
    }

    return ListView.builder(
      itemCount: viewModel.books.length,
      itemBuilder: (context, index) {
        final Book book = viewModel.books[index];
        return BookListTile(
          book: book,
          onBorrowPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    BorrowBookScreen(viewModel: viewModel, selectedBook: book),
              ),
            );
          },
        );
      },
    );
  }
}
