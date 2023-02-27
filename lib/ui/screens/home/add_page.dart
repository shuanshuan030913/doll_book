import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:doll_app/ui/components/upload_image_widget.dart';
import 'package:doll_app/ui/components/item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;


FirebaseFirestore firestore = FirebaseFirestore.instance;
class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  // 圖片
  File? _imageFile;
  // 項目名稱
  String _name = '';
  // 購買日期
  DateTime? _createDate;
  TextEditingController dateController = TextEditingController(text: '');
  // 金額
  // 二補
  // 總計
  // 來源
  // 取件
  // 備註
  bool _isChecked = false;

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
    print('getImage() _imageFile: $_imageFile');
  }

  Future uploadImage() async {
    final User user = FirebaseAuth.instance.currentUser!;
    final String userId = user.uid;
    
    final String fileName = DateTime.now().toString() + path.extension(_imageFile!.path);

    Reference storageRef = 
      FirebaseStorage.instance.ref().child('items/$userId/images/$fileName');

    print('uploadImage() _imageFile: $_imageFile');
    await storageRef.putFile(_imageFile!);
    // Get the download URL for the uploaded image
    final String imageUrl = await storageRef.getDownloadURL();
    print('uploadImage() imageUrl: $imageUrl');
    return imageUrl;
  }

  Future<void> addItem() async {

    // Get the current user's ID
    final User user = FirebaseAuth.instance.currentUser!;
    final String userId = user.uid;

    // Create a reference to the user's document with their ID
    final DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('data').doc(userId);

    // Generate a new unique ID for the item
    final String itemId = userDocRef.collection('items').doc().id;

    String imageUrl = await uploadImage();
    Map<String, dynamic> data = {
      'id': itemId,
      'name': _name,
      'image': imageUrl,
      'create_date': _createDate,
    };

    // Add a new item to the "items" array field in the user's document
    await userDocRef.update({
      'items': FieldValue.arrayUnion([data])
    })
    .then((value) => print("User Added"))
    .catchError((error) => print("Failed to add user: $error"));
    Navigator.pop(context);

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
      appBar: AppBar(
        title: Text("新增"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  getImage();
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _imageFile == null
                    ? Center(child: Text('選擇圖片')) : Image.file(_imageFile!),
                ),
              ),
            //   UploadImageWidget(
            //   onImagePicked: (path) {
            //     setState(() {
            //       _imageFile = path as File;
            //     });
            //   },
            //   child: _imageFile == ""
            //       ? Container(
            //           height: 100,
            //           width: 100,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(13),
            //             color: const Color(0xFFCCCCCC),
            //           ),
            //           child: Icon(Icons.collections_outlined),
            //         )
            //       : SizedBox(
            //           height: 100,
            //           width: 100,
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.circular(13),
            //             child: Image.file(
            //               File(_imageFile as String),
            //               fit: BoxFit.cover,
            //             ),
            //           ),
            //         ),
              // ),
              TextFormField(
                decoration: InputDecoration(labelText: '項目名稱'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '必填項目';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              GestureDetector(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  setState(() {
                    _createDate = selectedDate;
                  });
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '購買日期',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: _createDate != null
                          ? "${_createDate?.year}/${_createDate?.month}/${_createDate?.day}"
                          : '',
                    ),
                    validator: (value) {
                      if (_createDate == null) {
                        return '請選擇日期';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.all(16.0),
              //   child: InkWell(
              //     onTap: () {
              //       setState(() {
              //         _isChecked = !_isChecked;
              //       });
              //     },
              //     child: Row(
              //       children: [
              //         Checkbox(
              //           value: _isChecked,
              //           onChanged: (value) {
              //             setState(() {
              //               _isChecked = value!;
              //             });
              //           },
              //         ),
              //         Text('已取件'),
              //       ],
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      addItem();
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text('新增成功'),
                      //   ),
                      // );
                      // Navigator.pop(
                      //   context,
                      //   Item(name: _name, path: _path, date: dateController.text),
                      // );
                    }
                  },
                  child: Text('送出'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}