/// 金額轉字串
String formatPrice(double? price) {
  if (price == null) {
    return '';
  }
  if (price == price.toInt()) {
    return price.toInt().toString();
  }
  return price.toString();
}
