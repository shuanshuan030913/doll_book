import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Item {
  final String id;
  final String name;
  final String? image;
  final DateTime createDate;
  final String status;
  final double? price;
  final double? priceAdd;
  final String? source;
  final String? remark;

  Item({
    required this.id,
    required this.name,
    this.image,
    required this.createDate,
    required this.status,
    this.price,
    this.priceAdd,
    this.source,
    this.remark,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    final Timestamp createTimestamp = map['createDate'] as Timestamp;
    return Item(
      id: map['id'] as String,
      name: map['name'] as String,
      image: map['image'] as String?,
      createDate: createTimestamp.toDate(),
      status: map['status'] as String,
      price: map['price'] as double?,
      priceAdd: map['priceAdd'] as double?,
      source: map['source'] as String?,
      remark: map['remark'] as String?,
    );
  }
}
