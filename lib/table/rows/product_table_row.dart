import 'package:flutter/material.dart';
import '../../button/add_to_cart_button_table.dart';
import '../../dropdowns/product_table_qty_selector.dart';
import '../../vo/order_item.dart';

class DataRowWidget extends StatefulWidget {
  final int index;
  final OrderItem item;
  final List<OrderItem> gridItems;
  int selectedQty = 0;

  DataRowWidget({
    required this.index,
    required this.item,
    required this.gridItems,
  });

  @override
  _DataRowWidgetState createState() => _DataRowWidgetState();
}

class _DataRowWidgetState extends State<DataRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDataCell('${widget.index + 1}', 0.1, TextAlign.center),
        _buildDataCell(widget.item.itemId, 0.15, TextAlign.center),
        _buildDataCell(widget.item.productName, 0.2, TextAlign.left),
        _buildDataCell(widget.item.category ?? '', 0.15, TextAlign.center),
        _buildDataCell(widget.item.subCategory ?? '', 0.15, TextAlign.center),
        _buildDataCell('₹${widget.item.price ?? ''}', 0.15, TextAlign.center),
        _buildDataCell(widget.item.remarks ?? '', 0.15, TextAlign.center),
        Expanded(
          flex: (0.10 * 100).toInt(),
          child: ProductTableQtySelector(
            onChanged: (value) {
              setState(() {
                widget.selectedQty = value;
              });
            },
          ),
        ),
        Expanded(
          flex: (0.15 * 100).toInt(),
          child: AddToCartButtonTable(
            orderItem: widget.gridItems[widget.index],
            selectedQuantity: widget.selectedQty,
          ),
        ),
      ],
    );
  }

  Widget _buildDataCell(String text, double flex, TextAlign align) {
    return Expanded(
      flex: (flex * 100).toInt(), // Convert fraction to flex value
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        constraints: BoxConstraints(maxHeight: 60), // Set a max height
        child: Scrollbar(
          thumbVisibility: true, // You can set this to false if you want it to show on scroll
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87, // Data text color
              ),
              textAlign: align,
            ),
          ),
        ),
      ),
    );
  }
}
