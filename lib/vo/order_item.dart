class OrderItem {
  String itemId;
  String productName;
  String? category;
  String? subCategory;
  String? imageUrl;
  int qty;

  OrderItem({
    required this.itemId,
    required this.productName,
    required this.qty,
    this.category,
    this.subCategory,
    this.imageUrl,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      itemId: map['itemId'] ?? '',
      productName: map['productName'] ?? '',
      category: map['category'] ?? '',
      subCategory: map['subCategory'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      qty: map['qty'] ?? 0,
    );
  }
}
