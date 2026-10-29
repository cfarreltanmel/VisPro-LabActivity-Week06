import 'package:flutter/material.dart';

import '../models/book.dart';
import '../viewmodels/library_view_model.dart';

class BorrowBookScreen extends StatefulWidget {
  final LibraryViewModel viewModel;
  final Book selectedBook;

  const BorrowBookScreen({
    super.key,
    required this.viewModel,
    required this.selectedBook,
  });

  @override
  State<BorrowBookScreen> createState() => _BorrowBookScreenState();
}

class _BorrowBookScreenState extends State<BorrowBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();

  int _selectedQuantity = 1;
  late DateTime _selectedDueDate;

  @override
  void initState() {
    super.initState();
    _selectedDueDate = DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    super.dispose();
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime initialDate = _selectedDueDate;
    final DateTime firstDate = DateTime.now();
    final DateTime lastDate = DateTime.now().add(const Duration(days: 365));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  void _submitBorrow() {
    if (_formKey.currentState!.validate()) {
      final success = widget.viewModel.borrowBook(
        widget.selectedBook.id,
        _studentIdController.text.trim(),
        quantity: _selectedQuantity,
        customDueDate: _selectedDueDate,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Book borrowed successfully!'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Failed to borrow book. Out of stock.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDueDate =
        "${_selectedDueDate.year}-${_selectedDueDate.month.toString().padLeft(2, '0')}-${_selectedDueDate.day.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(title: Text('Borrow ${widget.selectedBook.title}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: theme.colorScheme.surfaceContainerLow,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.selectedBook.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Available Stock: ${widget.selectedBook.stock}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _studentIdController,
                decoration: const InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter student ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              const Text('Select Quantity'),
              const SizedBox(height: 6),
              DropdownButtonFormField<int>(
                initialValue: _selectedQuantity,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixText: 'Copies to borrow: ',
                ),
                items: List.generate(
                  widget.selectedBook.stock,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('${index + 1}'),
                  ),
                ),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedQuantity = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () => _selectDueDate(context),
                borderRadius: BorderRadius.circular(4),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formattedDueDate, style: theme.textTheme.bodyMedium),
                      Text(
                        'Change',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              FilledButton(
                onPressed: _submitBorrow,
                child: const Text('Confirm Borrow'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
