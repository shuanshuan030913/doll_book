class PriceItem {
  // final String id;
  final String name;
  final String type;
  final double price;

  PriceItem({
    // required this.id,
    required this.name,
    required this.type,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'name: $name, price: $price, type: $type';
  }

  factory PriceItem.fromMap(Map<String, dynamic> map) {
    return PriceItem(
      // id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      price: map['price'] as double,
    );
  }
}
