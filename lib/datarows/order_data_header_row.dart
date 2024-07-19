import 'package:flutter/material.dart';
import '../dropdowns/quantity_selector.dart';
import '../button/add_to_cart_button.dart';
import '../vo/order_item.dart';


class OrderHeaderDataColumns extends StatefulWidget {
  final int index;
  final OrderItem item;
  int selectedQty = 0;
  OrderHeaderDataColumns({required this.index, required this.item});

  @override
  _OrderHeaderDataColumnsState createState() => _OrderHeaderDataColumnsState();
}

class _OrderHeaderDataColumnsState extends State<OrderHeaderDataColumns> {
  @override
  Widget build(BuildContext context) {
    return
          Container(
            child: Row(
              children: [
                Expanded(child: Text('Sr No')),
                Expanded(child: Text('Item ID')),
                Expanded(child: Text('Product Name')),
                Expanded(child: Text('Category')),
                Expanded(child: Text('SubCategory')),
                Expanded(child: Text('Quantity')),
                Expanded(child: Text(''))
              ],
            ),
          );
  }
}
