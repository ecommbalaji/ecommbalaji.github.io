import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:webcatalog/button/add_to_cart_button_table.dart';
import 'package:webcatalog/table/rows/product_table_row.dart';
import 'package:webcatalog/vo/order_item.dart';

import '../button/add_to_cart_button_grid.dart';
import '../dropdowns/product_table_qty_selector.dart';

class ProductTable extends StatelessWidget {
  final List<OrderItem> gridItems;
  int selectedQty = 0;

  ProductTable({required this.gridItems});

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    logger.d('build called');
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200], // Header background color
          ),
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _buildHeaderCell('Sr No', 0.1, TextAlign.center), // Width as a fraction of available space
              _buildHeaderCell('Item ID', 0.15, TextAlign.center), // Width as a fraction of available space
              _buildHeaderCell('Product Name', 0.2, TextAlign.center), // Width as a fraction of available space
              _buildHeaderCell('Category', 0.15, TextAlign.center), // Width as a fraction of available space
              _buildHeaderCell('SubCategory', 0.15, TextAlign.center), // Width as a fraction of available space
              _buildHeaderCell('Price', 0.15, TextAlign.center),
              _buildHeaderCell('Remarks', 0.15, TextAlign.center),
              _buildHeaderCell('Quantity', 0.1, TextAlign.center), // Width as a fraction of available space
              _buildHeaderCell('Add to Cart', 0.15, TextAlign.center), // Width as a fraction of available space
            ],
          ),
        ),
        Divider(thickness: 2, color: Colors.grey[400]),
        Expanded(
          child: ListView.builder(
            itemCount: gridItems.length,
            itemBuilder: (context, index) {
              return _buildRow(index, index % 2 == 0 ? Colors.grey[100]! : Colors.white!);
            },
          ),
        )
      ],
    );
  }

  Widget _buildHeaderCell(String title, double flex, TextAlign textAlign) {
    return Expanded(
      flex: (flex * 100).toInt(), // Convert fraction to flex value
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue, // Header text color
            ),
            textAlign: textAlign,
          ),
        ),
      ),
    );
  }

  Widget _buildRow(int index, Color color) {
    final item = gridItems[index];
    logger.d('Building row for index: $index with item: ${item.itemId}');
    return Container(
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: DataRowWidget(index: index, item: item, gridItems: gridItems),
      ),
    );
  }


}
