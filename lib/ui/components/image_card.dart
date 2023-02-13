import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String path;

  const ImageCard({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return path == ""
      ? Center(
          child: Text(
            "No Pic",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        )
      : ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
        child: Image.asset(
        path,
          fit: BoxFit.cover,
        ),
      );
  }
}