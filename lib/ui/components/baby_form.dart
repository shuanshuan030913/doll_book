import 'dart:io';

import 'package:doll_app/colors.dart';
import 'package:doll_app/constants.dart';
import 'package:doll_app/ui/components/dropdown_widget.dart';
import 'package:doll_app/ui/components/item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

/// 金額品項
class PriceItem {
  String name;
  double price;

  PriceItem({
    required this.name,
    required this.price,
  });
}

class BabyForm extends StatefulWidget {
  final CollectionReference collectionReference;
  final String? documentId;
  final Item? data;
  BabyForm({
    required this.collectionReference,
    this.documentId,
    this.data,
  });

  @override
  _BabyFormState createState() => _BabyFormState();
}

class _BabyFormState extends State<BabyForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  // 圖片
  File? _imageFile;
  String? _image; // 來自編輯的路徑
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

  @override
  void initState() {
    super.initState();
    _image = widget.data?.image;
    _name = widget.data != null ? widget.data!.name : '';
    _createDate = widget.data?.createDate;
    _status = widget.data != null ? widget.data!.status : '數調中';
    _price = widget.data?.price;
    _priceAdd = widget.data?.priceAdd;
    _source = widget.data?.source;
    _remark = widget.data?.remark;
  }

  Future<CroppedFile?> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressQuality: 50,
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

  void _onOptionSelected(String option) {
    setState(() {
      _status = option;
    });
  }

  String _formatPrice(double? price) {
    if (price == null) {
      return '';
    }
    if (price == price.toInt()) {
      return price.toInt().toString();
    }
    return price.toString();
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              getImage();
            },
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                border: _imageFile != null || _image != null
                    ? null
                    : Border.all(
                        color: primaryColor, // Set the border color to pink
                        width: 2.0,
                      ),
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                child: _imageFile == null && _image == null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 60.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      primaryColor, // Set the background color of the circle
                                ),
                                child: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 30.0, // Set the size of the icon
                                    color: Colors
                                        .white, // Set the color of the icon
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '選擇圖片',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _imageFile != null
                        ? Image.file(_imageFile!)
                        : Image.network(_image!),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: '項目名稱'),
            initialValue: _name,
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
                initialDate: _createDate ?? DateTime.now(),
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
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: 16.0),
          DropdownWidget(
            onOptionSelected: _onOptionSelected,
            status: _status,
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
          //   height: 50.0,
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(6.0),
          //     color: Color.fromARGB(255, 255, 217, 182),
          //   ),
          //   child: DropdownButtonHideUnderline(
          //     child: DropdownButton<String>(
          //       value: _status,
          //       items: statusOptions.map((option) {
          //         return DropdownMenuItem<String>(
          //           value: option,
          //           child: Text(option),
          //         );
          //       }).toList(),
          //       onChanged: (value) {
          //         if (value != null) {
          //           setState(() {
          //             _status = value;
          //           });
          //         }
          //       },
          //     ),
          //   ),
          // ),
          SizedBox(height: 6.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextFormField(
                    initialValue: _formatPrice(_price),
                    decoration: InputDecoration(
                      labelText: '金額',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    initialValue: _formatPrice(_priceAdd),
                    decoration: InputDecoration(
                      labelText: '二補',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            initialValue: _source ?? null,
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
            initialValue: _remark ?? null,
            maxLines: 2,
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
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 60.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all<double>(0),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(primaryColor),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.symmetric(
                        vertical:
                            12.0, // Set the vertical padding to increase the button height
                      ),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30.0), // Set the border radius
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      if (widget.documentId == null) {
                        // Add new document
                        await addItem();
                      } else {
                        // Update existing document
                      }
                      Navigator.pop(context);
                    }
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text('新增成功'),
                    //   ),
                    // );
                    // Navigator.pop(
                    //   context,
                    //   Item(name: _name, path: _path, date: dateController.text),
                    // );
                  },
                  child: Text(
                    '送出',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
