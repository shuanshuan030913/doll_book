import 'package:flutter/material.dart';
import 'package:doll_app/ui/components/item.dart';
import 'package:doll_app/ui/components/image_card.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            child: ImageCard(image: item.image),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            item.name,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
