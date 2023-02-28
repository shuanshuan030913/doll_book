import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String? image;

  const ImageCard({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return image == null
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
              image!,
              fit: BoxFit.cover,
            ),
          );
  }
}
