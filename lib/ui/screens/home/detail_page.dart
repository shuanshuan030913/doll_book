import 'package:doll_app/colors.dart';
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
  late final Item data;

  @override
  void initState() {
    super.initState();
    data = widget.data;
  }

  void _onReturnedData(dynamic returnedData) {
    if (returnedData != null) {
      setState(() {
        data = returnedData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              data.image != null
                  ? Image.network(
                      data.image!,
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
                  onTap: () async {
                    final returnedData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPage(
                          documentId: data.id,
                          collectionReference: widget.collectionReference,
                          data: data,
                        ),
                      ),
                    );
                    _onReturnedData(returnedData);
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
                          data.name,
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
                          '\$${data.priceTotal?.toString() ?? '0'}',
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
                    '購買日期： ${data.createDate != null ? DateFormat('yyyy/MM/dd').format(data.createDate!) : ""}',
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
                    '狀態： ${data.status}',
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
                    '備註： ${data.remark ?? ""}',
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
