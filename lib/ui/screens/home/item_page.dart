import 'package:doll_app/ui/components/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:doll_app/ui/components/item.dart';
import 'package:doll_app/ui/components/image_card.dart';

class ItemPage extends StatelessWidget {
  final Item item;

  const ItemPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: const <Widget>[
          IconButton(
            icon: Icon(
              CupertinoIcons.pen,
              color: Colors.white,
            ),
            onPressed: null,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
              child: ImageCard(image: item.image),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "項目名稱: ${item.name}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "購買日期: ${item.createDate != null ? "${item.createDate?.year}/${item.createDate?.month}/${item.createDate?.day}" : ''}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
      // body: Center(
      //   child: item.path == ""
      //       ? const Text("No picture")
      //       : Image.asset(item.path),
      // ),
    );
  }
}
