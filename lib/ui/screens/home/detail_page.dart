import 'package:doll_app/colors.dart';
import 'package:doll_app/ui/widgets/baby_form.dart';
import 'package:doll_app/models/item.dart';
import 'package:doll_app/ui/screens/home/edit_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final CollectionReference collectionReference;
  final Item data;

  DetailPage({
    required this.collectionReference,
    required this.data,
  });

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              widget.data.image != null
                  ? Image.network(
                      widget.data.image!,
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: Card(
                        margin: EdgeInsets.zero,
                        color: Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: const Center(
                          child: Text(
                            'No Pic',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 60,
                            ),
                          ),
                        ),
                      ),
                    ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 30,
                child: Container(
                  decoration: BoxDecoration(
                    color: primaryColor,
                    border: Border.all(color: primaryColor, width: 1),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 70.0,
                right: 20.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPage(
                          documentId: widget.data.id,
                          collectionReference: widget.collectionReference,
                          data: widget.data,
                        ),
                      ),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: primaryColor,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          top: 6.0,
                        ),
                        width: double.infinity,
                        child: Text(
                          widget.data.name,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 255, 249, 249),
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                          bottom: 46.0,
                        ),
                        width: double.infinity,
                        child: Text(
                          '\$${widget.data.priceTotal?.toString() ?? '0'}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 30,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 30,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 6.0,
                  ),
                  width: double.infinity,
                  child: Text(
                    '購買日期： ${widget.data.createDate != null ? DateFormat('yyyy/MM/dd').format(widget.data.createDate!) : ""}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 6.0,
                  ),
                  width: double.infinity,
                  child: Text(
                    '狀態： ${widget.data.status}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 6.0,
                  ),
                  width: double.infinity,
                  child: Text(
                    '備註： ${widget.data.remark ?? ""}',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
