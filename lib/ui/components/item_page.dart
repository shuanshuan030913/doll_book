import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:doll_app/ui/components/item.dart';


class ItemPage extends StatelessWidget {
  final Item item;

  const ItemPage({required this.item});

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
      body: Center(
        child: item.path == ""
            ? Text("No picture")
            : Image.asset(item.path),
      ),
    );
  }
}