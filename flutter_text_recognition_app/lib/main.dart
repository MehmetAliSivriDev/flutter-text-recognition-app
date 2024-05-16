import 'package:flutter/material.dart';
import 'package:flutter_text_recognition_app/features/add/viewModel/add_view_model.dart';
import 'package:flutter_text_recognition_app/features/detail/viewModel/detail_view_model.dart';
import 'package:flutter_text_recognition_app/features/home/view/home_view.dart';
import 'package:flutter_text_recognition_app/features/home/viewModel/home_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => HomeViewModel()),
      ChangeNotifierProvider(create: (context) => AddViewModel()),
      ChangeNotifierProvider(create: (context) => DetailViewModel()),
    ],
    builder: (context, child) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Text Recognition App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const HomeView(),
    );
  }
}
