import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:doll_app/ui/components/upload_image_widget.dart';
import 'package:doll_app/ui/components/item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference items = firestore.collection('items');
class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  // 圖片
  late File _image;
  // 項目名稱
  String _name = '';
  // 購買日期
  TextEditingController dateController = TextEditingController(text: '');
  // 金額
  // 二補
  // 總計
  // 來源
  // 取件
  // 備註
  bool _isChecked = false;
  
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future uploadImage() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('items/${DateTime.now().toString()}');
    UploadTask uploadTask = ref.putFile(_image);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> addItem() async {
    // String imageUrl = await uploadImage();
    Map<String, dynamic> data = {
      'name': _name,
      // 'image': imageUrl,
      'create_date': DateTime.now(),
    };
    print('addItem addItem');
    await items.get().then((event) {
      print('success event');
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");
      }
    });
    // await items.add(data)
    // .then((value) => print("User Added"))
    // .catchError((error) => print("Failed to add user: $error"));
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
              // InkWell(
              //   onTap: () {
              //     getImage();
              //   },
              //   child: Container(
              //     height: 200,
              //     decoration: BoxDecoration(
              //       border: Border.all(color: Colors.grey),
              //     ),
              //     child: _image == null
              //         ? Center(child: Text('Select Image'))
              //         : Image.file(_image, fit: BoxFit.cover),
              //   ),
              // ),
            //   UploadImageWidget(
            //   onImagePicked: (path) {
            //     setState(() {
            //       _image = path;
            //     });
            //   },
            //   child: _image == ""
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
            //               File(_image),
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
              InkWell(
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      dateController.text = '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}';
                    });
                  }
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: '購買日期',
                    ),
                    validator: (value) {
                      if (dateController.text == '') {
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