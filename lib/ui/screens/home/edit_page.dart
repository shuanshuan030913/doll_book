import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doll_app/ui/components/baby_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EditPage extends StatefulWidget {
  final String documentId;
  final CollectionReference collectionReference;

  EditPage({
    required this.documentId,
    required this.collectionReference,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('編輯'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BabyForm(
          documentId: widget.documentId,
          collectionReference: widget.collectionReference,
        ),
      ),
    );
  }
}
