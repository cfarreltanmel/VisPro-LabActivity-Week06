import 'package:flutter/material.dart';

class AddBookForm extends StatelessWidget {
  final TextEditingController idController;
  final TextEditingController titleController;
  final TextEditingController authorController;
  final TextEditingController stockController;
  final TextEditingController priceController;

  const AddBookForm({
    super.key,
    required this.idController,
    required this.titleController,
    required this.authorController,
    required this.stockController,
    required this.priceController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: idController,
            decoration: const InputDecoration(
              labelText: 'Book ID',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: authorController,
            decoration: const InputDecoration(
              labelText: 'Author',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: stockController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Stock',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Replacement Price',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
