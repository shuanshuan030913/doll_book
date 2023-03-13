import 'package:doll_app/ui/screens/list/image_card.dart';
import 'package:flutter/material.dart';
import 'package:doll_app/models/item.dart';

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
            child: ImageCard(
              status: item.status,
              image: item.image,
            ),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
