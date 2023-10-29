import 'package:flutter/material.dart';
import 'package:image_exposure/src/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Exposure Image',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
