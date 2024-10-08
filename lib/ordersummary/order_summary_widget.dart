import 'package:flutter/material.dart';
import '../vo/order_item.dart';

class OrderSummaryWidget extends StatefulWidget {
  final OrderItem orderItem;
  final VoidCallback onRemove;
  final ValueChanged<int?>? onQuantityChanged;

  const OrderSummaryWidget({
    required this.orderItem,
    required this.onRemove,
    this.onQuantityChanged,
    super.key,
  });

  @override
  _OrderSummaryWidgetState createState() => _OrderSummaryWidgetState();
}

class _OrderSummaryWidgetState extends State<OrderSummaryWidget> {
  int? selectedQuantity;

  @override
  void initState() {
    super.initState();
    selectedQuantity = widget.orderItem.qty;
  }

  // Convert price from String to double, handling nulls or invalid values
  double getPrice() {
    final priceStr = widget.orderItem.price;
    if (priceStr == null || priceStr.isEmpty) return 0.0;
    return double.tryParse(priceStr) ?? 0.0; // Safely parse the price string to double
  }

  // Calculate total price
  double getTotalPrice() {
    final unitPrice = getPrice();
    final quantity = selectedQuantity ?? 1;
    return unitPrice * quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      image: widget.orderItem.images != null && widget.orderItem.images!.isNotEmpty
                          ? DecorationImage(
                        image: NetworkImage(widget.orderItem.images![0]),
                        fit: BoxFit.cover,
                      )
                          : null,
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey[200], // Placeholder color
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          widget.orderItem.productName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Product ID
                        Text(
                          'Product ID: ${widget.orderItem.itemId}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Selected Slot + Unit
                        Text(
                          'Selected Slot: ${widget.orderItem.selectedSlot ?? 'N/A'} ${widget.orderItem.unit ?? ''}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Unit Price
                        Text(
                          'Unit Price: ₹${getPrice().toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Quantity Selector and Total Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Quantity: ',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 15,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: DropdownButton<int>(
                                    value: selectedQuantity,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedQuantity = value;
                                      });
                                      if (widget.onQuantityChanged != null) {
                                        widget.onQuantityChanged!(value);
                                      }
                                    },
                                    items: List.generate(1000, (i) => i + 1)
                                        .map((value) => DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(value.toString()),
                                    ))
                                        .toList(),
                                    underline: Container(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Total Price
                            Text(
                              'Total: ₹${getTotalPrice().toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(color: Colors.grey[300]),
                        // Remove Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: widget.onRemove,
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            label: const Text(
                              'Remove',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
