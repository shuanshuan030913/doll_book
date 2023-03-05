import 'package:doll_app/colors.dart';
import 'package:doll_app/ui/components/baby_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addItem() async {
    // // Get the current user's ID
    // final User user = FirebaseAuth.instance.currentUser!;
    // final String userId = user.uid;

    // // Create a reference to the user's document with their ID
    // final DocumentReference userDocRef =
    //     FirebaseFirestore.instance.collection('data').doc(userId);

    // // Generate a new unique ID for the item
    // final String itemId = userDocRef.collection('items').doc().id;

    // print('userDocRef: $userDocRef');
    // String? imageUrl = _imageFile == null ? null : await uploadImage();
    // Map<String, dynamic> data = {
    //   'id': itemId,
    //   'name': _name,
    //   'image': imageUrl,
    //   'status': _status,
    //   'price': _price,
    //   'priceAdd': _priceAdd,
    //   'source': _source,
    //   'remark': _remark,
    //   'createDate': _createDate,
    // };

    // // Add a new item to the "items" array field in the user's document
    // final userData = await userDocRef.get().then((doc) => doc.data());
    // if (userData != null) {
    //   await userDocRef
    //       .update({
    //         'items': FieldValue.arrayUnion([data])
    //       })
    //       .then((value) => {print("User Added"), Navigator.pop(context)})
    //       .catchError((error) => print("Failed to add items: $error"));
    // } else {
    //   await userDocRef
    //       .set({
    //         'items': FieldValue.arrayUnion([data])
    //       })
    //       .then((value) => {print("User Added"), Navigator.pop(context)})
    //       .catchError((error) => print("Failed to add items: $error"));
    // }

    // await data.get().then((event) {
    //   print('success event');
    //   for (var doc in event.docs) {
    //     print("${doc.id} => ${doc.data()}");
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
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
