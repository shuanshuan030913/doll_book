import 'package:flutter/material.dart';

class ItemPage extends StatelessWidget {
  final int index;

  const ItemPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item $index'),
      ),
      body: Center(
        child: Text('You selected Item $index'),
      ),
    );
  }
}