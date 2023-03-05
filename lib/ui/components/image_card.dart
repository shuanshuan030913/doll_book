import 'package:doll_app/ui/components/image_label.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String? image;
  final String status;

  const ImageCard({super.key, required this.image, required this.status});

  @override
  Widget build(BuildContext context) {
    return image == null
        ? Stack(
            children: [
              Card(
                margin: EdgeInsets.zero,
                color: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    'No Pic',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Label box
              ImageLabel(status: status),
            ],
          )
        : Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                child: Image.network(
                  image!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              // Label box
              ImageLabel(status: status),
            ],
          );
  }
}
