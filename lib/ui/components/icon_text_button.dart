import 'package:doll_app/colors.dart';
import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final bool isShowed;
  final String text;
  final Color? color;
  void Function()? onPressed;

  IconTextButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.isShowed,
    this.color,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isShowed ? 1 : 0.5,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              // border: Border.all(
              //   color: primaryColor,
              //   width: 2,
              // ),
            ),
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(
                icon,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
