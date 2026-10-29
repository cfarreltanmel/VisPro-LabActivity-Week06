import 'package:flutter/material.dart';

import '../models/book.dart';
import '../viewmodels/library_view_model.dart';
import 'widgets/add_book_form.dart';

class AddBookScreen extends StatefulWidget {
  final LibraryViewModel viewModel;

  const AddBookScreen({super.key, required this.viewModel});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _handleSaveBook() {
    final id = _idController.text.trim();
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;

    if (id.isEmpty || title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Book ID and Title are required.'),
        ),
      );
      return;
    }

    final newBook = Book(
      id: id,
      title: title,
      author: author,
      stock: stock,
      replacementPrice: price,
    );

    widget.viewModel.addBook(newBook);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Book')),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AddBookForm(
                idController: _idController,
                titleController: _titleController,
                authorController: _authorController,
                stockController: _stockController,
                priceController: _priceController,
              ),
              const SizedBox(height: 24),
              FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _handleSaveBook,
                child: const Text('Save Book'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
