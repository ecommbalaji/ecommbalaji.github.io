import 'package:flutter/material.dart';
import '../dropdowns/quantity_selector.dart';
import '../button/add_to_cart_button.dart';
import '../vo/order_item.dart';


class OrderDataRow extends StatefulWidget {
  final int index;
  final OrderItem item;
  int selectedQty = 0;
  OrderDataRow({required this.index, required this.item});

  @override
  _OrderDataRowState createState() => _OrderDataRowState();
}

class _OrderDataRowState extends State<OrderDataRow> {
  @override
  Widget build(BuildContext context) {
    return
          Container(
            child: Row(
              children: [
                Expanded(child: Text('${widget.index + 1}')),
                Expanded(child: Text(widget.item.itemId)),
                Expanded(child: Text(widget.item.productName)),
                Expanded(child: Text(widget.item.category ?? '')),
                Expanded(child: Text(widget.item.subCategory ?? '')),
                Expanded(
                  child: QuantitySelector(
                    onChanged: (value) {
                      setState(() {
                        widget.selectedQty = value;

                      });
                    },
                  ),
                ),
                Expanded(
                  child: AddToCartButton(orderItem: widget.item, selectedQuantity: widget.selectedQty),
                ),
              ],
            ),
          );
  }
}
