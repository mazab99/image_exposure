import 'package:flutter/material.dart';
import 'package:image_exposure/src/widgets/exposure_image.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exposure Image'),
      ),
      body: ExposureImage(
        image: const AssetImage(
          'assets/me3.jpeg',
        ),
        onImageError: (exception, stackTrace) {
          print('onImageError');
        },
      ),
    );
  }
}
