import 'package:doll_app/colors.dart';
import 'package:doll_app/ui/components/baby_form.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItemPage extends StatefulWidget {
  final CollectionReference collectionReference;

  AddItemPage({
    required this.collectionReference,
  });

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0, // Remove the shadow on top
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: primaryColor,
        ),
        title: const Text(
          '新增',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BabyForm(
          collectionReference: widget.collectionReference,
        ),
      ),
    );
  }
}
