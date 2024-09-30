import 'package:flutter/material.dart';
import '../vo/order_item.dart';

class OrderSummaryWidget extends StatelessWidget {
  final OrderItem orderItem;
  final VoidCallback onRemove;
  final ValueChanged<int?>? onQuantityChanged; // Nullable ValueChanged<int?>

  const OrderSummaryWidget({
    required this.orderItem,
    required this.onRemove,
    this.onQuantityChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              image: orderItem.images != null && orderItem.images!.isNotEmpty
                  ? DecorationImage(
                image: NetworkImage(orderItem.images![0]),
                fit: BoxFit.cover,
              )
                  : null,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  orderItem.productName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Product ID
                Text(
                  'Product ID: ${orderItem.itemId}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                // Selected Slot + Unit
                Text(
                  'Selected Slot: ${orderItem.selectedSlot ?? 'N/A'} ${orderItem.unit ?? ''}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                // Price
                Text(
                  'Price: ₹${orderItem.price ?? '0'}',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 6),
                // Quantity Selector
                Row(
                  children: [
                    Text(
                      'Quantity: ',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                    DropdownButton<int>(
                      value: orderItem.qty,
                      onChanged: onQuantityChanged,
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
                  ],
                ),
                const SizedBox(height: 6),
                // Divider
                Divider(color: Colors.grey[300]),
                // Remove Button
                TextButton(
                  onPressed: onRemove,
                  child: const Text(
                    'Remove',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
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
