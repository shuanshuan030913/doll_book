import 'package:doll_app/colors.dart';
import 'package:flutter/material.dart';

class ImageLabel extends StatelessWidget {
  final String status;

  const ImageLabel({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 24,
      right: 24,
      child: Container(
        height: 20,
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
        child: Center(
          child: Text(
            status,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
