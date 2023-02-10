import 'package:flutter/material.dart';

class ItemPage extends StatelessWidget {
  final String name;

  const ItemPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item $name'),
      ),
      body: Center(
        child: Text('You selected $name'),
      ),
    );
  }
}