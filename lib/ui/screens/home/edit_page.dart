import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doll_app/colors.dart';
import 'package:doll_app/ui/widgets/baby_form.dart';
import 'package:doll_app/models/item.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final String documentId;
  final CollectionReference collectionReference;
  final Item data;

  EditPage({
    required this.documentId,
    required this.collectionReference,
    required this.data,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
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
          '編輯',
          style: TextStyle(
            color: primaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BabyForm(
          documentId: widget.documentId,
          collectionReference: widget.collectionReference,
          data: widget.data,
        ),
      ),
    );
  }
}
