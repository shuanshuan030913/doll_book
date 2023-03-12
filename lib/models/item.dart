import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doll_app/models/price_item.dart';

class Item {
  final String id;
  final String name;
  final String? image;
  final DateTime? createDate;
  final String status;
  final List<PriceItem>? priceList;
  final double? priceTotal;
  final String? source;
  final String? remark;

  Item({
    required this.id,
    required this.name,
    this.image,
    this.createDate,
    required this.status,
    this.priceList,
    this.priceTotal,
    this.source,
    this.remark,
  });

  factory Item.fromMap(Map<String, dynamic> map, docId) {
    final Timestamp? createTimestamp =
        map['createDate'] != null ? map['createDate'] as Timestamp : null;
    return Item(
      id: docId as String,
      name: map['name'] as String,
      image: map['image'] as String?,
      createDate: createTimestamp != null ? createTimestamp.toDate() : null,
      status: map['status'] as String,
      priceList: List<PriceItem>.from(
        (map['priceList'] ?? []).map(
          (item) => PriceItem.fromMap(item),
        ),
      ),
      priceTotal: map['priceTotal'] as double?,
      source: map['source'] as String?,
      remark: map['remark'] as String?,
    );
  }
}
