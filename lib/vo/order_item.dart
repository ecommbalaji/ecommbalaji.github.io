class OrderItem {
  String itemId;
  String productName;
  String? category;
  String? subCategory;
  String? price;
  String? remarks;
  List<String>? images;
  int qty;
  String? dimension; // New field for dimension
  String? unit;      // New field for unit
  Map<String, double>? slotPriceMapping; // Assuming this was already added
  int? selectedSlotIndex;
  String? selectedSlot;

  OrderItem({
    required this.itemId,
    required this.productName,
    required this.qty,
    this.category,
    this.subCategory,
    this.price,
    this.remarks,
    this.images,
    this.dimension,
    this.unit,
    this.slotPriceMapping,
    this.selectedSlotIndex,
    this.selectedSlot
  });

  OrderItem.clone(OrderItem original)
      : itemId = original.itemId,
        productName = original.productName,
        qty = original.qty, // This can change if needed
        category = original.category,
        subCategory = original.subCategory,
        price = original.price,
        remarks = original.remarks,
        images = List.from(original.images ?? []), // Clone the list
        dimension = original.dimension,
        unit = original.unit,
        slotPriceMapping = Map.from(original.slotPriceMapping ?? {}),
        selectedSlotIndex = original.selectedSlotIndex,
        selectedSlot = original.selectedSlot;


  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      itemId: map['itemId'] ?? '',
      productName: map['productName'] ?? '',
      category: map['category'] ?? '',
      subCategory: map['subCategory'] ?? '',
      images: map['imageUrl']?.toString().split(","),
      price: map['price'] ?? '',
      remarks: map['remarks'] ?? '',
      qty: map['qty'] ?? 0,
      dimension: map['dimension'] ?? '', // Add dimension
      unit: map['unit'] ?? '',            // Add unit
      slotPriceMapping: map['slotPriceMapping'] ?? {}, // Add slotPriceMapping
    );
  }
}
