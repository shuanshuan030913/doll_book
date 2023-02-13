import 'package:flutter/material.dart';
import 'package:doll_app/ui/components/item.dart';

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
            child: item.path == ""
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
                  item.path,
                    fit: BoxFit.cover,
                  ),
                ),
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
    return Container(
      child: Card(
        child: Column(
          children: [
            Container(
              // width: double.infinity,
              child: item.path == ""
                  ? Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Text('No picture'),
                      ),
                    )
                  : Image.asset(
                      item.path,
                      fit: BoxFit.cover,
                    ),
            ),
            // SizedBox(
            //   height: 10,
            // ),
            // Text(
            //   item.name,
            //   style: TextStyle(fontSize: 18),
            // ),
          ],
        ),
      ),
    );
  }
}