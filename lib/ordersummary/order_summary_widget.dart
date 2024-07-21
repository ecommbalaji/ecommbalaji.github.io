import 'package:flutter/material.dart';

import '../vo/order_item.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderItem orderItem;
  final VoidCallback onRemove;
  final ValueChanged<int?>? onQuantityChanged; // Nullable ValueChanged<int?>

  const OrderItemWidget({
    required this.orderItem,
    required this.onRemove,
    this.onQuantityChanged, // Nullable ValueChanged<int?>
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              image: orderItem.imageUrl != null
                  ? DecorationImage(
                image: NetworkImage(orderItem.imageUrl!),
                fit: BoxFit.cover,
              )
                  : null,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  orderItem.productName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                // Product Description
                if (orderItem.productName != null)
                  Text(
                    orderItem.productName!,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                SizedBox(height: 6),
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
                      items: List.generate(1000, (i) => i)
                          .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      ))
                          .toList(),
                      underline: Container(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                // Divider
                Divider(color: Colors.grey[300]),
                // Remove Button
                TextButton(
                  onPressed: onRemove,
                  child: Text(
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
