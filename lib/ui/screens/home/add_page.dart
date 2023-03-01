import 'dart:io';

import 'package:doll_app/ui/components/upload_image_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:doll_app/ui/components/item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:doll_app/constants.dart';

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
  // TextEditingController dateController = TextEditingController(text: '');
  // 當前狀態
  String _status = '數調中';
  // 金額
  double? _price;
  // 二補
  double? _priceAdd;
  // 總計
  // 來源
  String? _source;
  // 取件
  bool _isChecked = false;
  // 備註
  String? _remark;

  Future<CroppedFile?> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: Colors.deepOrange,
          toolbarTitle: '裁切',
          statusBarColor: Colors.deepOrange.shade900,
          backgroundColor: Colors.white,
        ),
        IOSUiSettings(
          title: '裁切',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    return croppedFile;
  }

  Future getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;
    final croppedFile = await _cropImage(File(pickedFile.path));

    if (croppedFile != null) {
      setState(() {
        _imageFile = File(croppedFile.path);
      });
    }
    print('getImage() _imageFile: $_imageFile');
  }

  Future uploadImage() async {
    final User user = FirebaseAuth.instance.currentUser!;
    final String userId = user.uid;

    final String fileName =
        DateTime.now().toString() + path.extension(_imageFile!.path);

    Reference storageRef =
        FirebaseStorage.instance.ref().child('items/$userId/images/$fileName');

    await storageRef.putFile(_imageFile!);
    // Get the download URL for the uploaded image
    final String imageUrl = await storageRef.getDownloadURL();
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

    print('userDocRef: $userDocRef');
    String? imageUrl = _imageFile == null ? null : await uploadImage();
    Map<String, dynamic> data = {
      'id': itemId,
      'name': _name,
      'image': imageUrl,
      'status': _status,
      'price': _price,
      'priceAdd': _priceAdd,
      'source': _source,
      'remark': _remark,
      'createDate': _createDate,
    };

    // Add a new item to the "items" array field in the user's document
    final userData = await userDocRef.get().then((doc) => doc.data());
    if (userData != null) {
      await userDocRef
          .update({
            'items': FieldValue.arrayUnion([data])
          })
          .then((value) => {print("User Added"), Navigator.pop(context)})
          .catchError((error) => print("Failed to add items: $error"));
    } else {
      await userDocRef
          .set({
            'items': FieldValue.arrayUnion([data])
          })
          .then((value) => {print("User Added"), Navigator.pop(context)})
          .catchError((error) => print("Failed to add items: $error"));
    }

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
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                  child: ClipRRect(
                    child: _imageFile == null
                        ? Center(child: Text('選擇圖片'))
                        : Image.file(_imageFile!),
                  ),
                ),
              ),
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
              SizedBox(height: 12.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Color.fromARGB(255, 255, 217, 182),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _status,
                    items: statusOptions.map((option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _status = value;
                        });
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 6.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '金額',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          return null;
                        },
                        onSaved: (value) {
                          _price = double.tryParse(value!);
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '二補',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          return null;
                        },
                        onSaved: (value) {
                          _priceAdd = double.tryParse(value!);
                        },
                      ),
                    ),
                  )
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: '來源',
                  hintText: 'https://',
                ),
                validator: (value) {
                  // if (value!.startsWith('https://')) {
                  //   return '請輸入來源網址';
                  // }
                  return null;
                },
                onSaved: (value) => _source = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '備註'),
                validator: (value) {
                  return null;
                },
                onSaved: (value) => _remark = value!,
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
