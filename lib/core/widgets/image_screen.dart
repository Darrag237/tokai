import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final String title;
  final String assetPath;
  const ImageScreen({super.key, required this.title, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SizedBox.expand(
        child: InteractiveViewer(
          child: Image.asset(assetPath, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
