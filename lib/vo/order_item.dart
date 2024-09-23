class OrderItem {
  String itemId;
  String productName;
  String? category;
  String? subCategory;
  String? price;
  String? remarks;
  String? imageUrl;
  int qty;

  OrderItem({
    required this.itemId,
    required this.productName,
    required this.qty,
    this.category,
    this.subCategory,
    String? price,
    String? remarks,
    this.imageUrl
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      itemId: map['itemId'] ?? '',
      productName: map['productName'] ?? '',
      category: map['category'] ?? '',
      subCategory: map['subCategory'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: map['price'] ?? '',
      remarks: map['remarks'] ?? '',
      qty: map['qty'] ?? 0,
    );
  }
}
