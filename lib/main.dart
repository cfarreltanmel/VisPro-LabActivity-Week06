import 'package:flutter/material.dart';

import 'viewmodels/library_view_model.dart';
import 'views/library_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final libraryViewModel = LibraryViewModel();

    return MaterialApp(
      title: 'UCM Library Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: LibraryScreen(viewModel: libraryViewModel),
    );
  }
}
