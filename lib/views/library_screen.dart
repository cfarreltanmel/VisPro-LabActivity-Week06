import 'package:flutter/material.dart';

import '../viewmodels/library_view_model.dart';
import 'add_book_screen.dart';
import 'widgets/catalogue_tab.dart';
import 'widgets/loans_tab.dart';

class LibraryScreen extends StatefulWidget {
  final LibraryViewModel viewModel;

  const LibraryScreen({super.key, required this.viewModel});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final vm = widget.viewModel;

        if (vm.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('UCM Library'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Book Catalogue'),
                  Tab(text: 'Active Loans & Fines'),
                ],
              ),
            ),
            body: SafeArea(
              child: TabBarView(
                children: [
                  CatalogueTab(viewModel: vm),
                  LoansTab(viewModel: vm),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddBookScreen(viewModel: vm),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Book'),
            ),
          ),
        );
      },
    );
  }
}
