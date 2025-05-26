import 'package:flutter/material.dart';
import 'dart:io';

class PhotoViewPage extends StatelessWidget {
  final String imagePath;

  const PhotoViewPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Photo"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Delete':
                  break;
                case 'Share':
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Delete', 'Share'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Center(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}