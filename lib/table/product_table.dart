import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:webcatalog/table/rows/product_table_row.dart';
import 'package:webcatalog/vo/order_item.dart';

class ProductTable extends StatelessWidget {
  final List<OrderItem> gridItems;
  int selectedQty = 0;

  ProductTable({super.key, required this.gridItems});

  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    logger.d('build called');
    return Padding(
      padding: const EdgeInsets.all(16.0), // Overall padding for the table
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 16), // Spacing between header and divider
          Divider(thickness: 2, color: Colors.grey[300]), // Subtle divider
          const SizedBox(height: 8), // Spacing between divider and list
          Expanded(
            child: ListView.builder(
              itemCount: gridItems.length,
              itemBuilder: (context, index) {
                return _buildRow(index, index % 2 == 0 ? Colors.grey[50]! : Colors.white);
              },
            ),
          ),
          const SizedBox(height: 16), // Spacing after the table
          _buildActions(), // Dropdown and button actions
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[50], // Light background color for header
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0), // Increased padding for header
      child: Row(
        children: [
          _buildHeaderCell('Sr No', 0.1, TextAlign.center),
          _buildHeaderCell('Item ID', 0.15, TextAlign.center),
          _buildHeaderCell('Product Name', 0.25, TextAlign.center),
          _buildHeaderCell('Category', 0.15, TextAlign.center),
          _buildHeaderCell('Sub Category', 0.15, TextAlign.center),
          _buildHeaderCell('Price', 0.15, TextAlign.center),
          _buildHeaderCell('Specs', 0.15, TextAlign.center),
          _buildHeaderCell('Dimension', 0.15, TextAlign.center),
          _buildHeaderCell('Unit', 0.15, TextAlign.center),
          _buildHeaderCell('Slot', 0.15, TextAlign.center),
          _buildHeaderCell('Quantity', 0.15, TextAlign.center),
          _buildHeaderCell('Add to Cart', 0.15, TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, double flex, TextAlign textAlign) {
    return Expanded(
      flex: (flex * 100).toInt(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0), // More padding for header cells
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18, // Slightly larger font size for header
              color: Colors.blueAccent, // Changed header text color for contrast
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
        padding: const EdgeInsets.symmetric(vertical: 8.0), // Increased vertical padding for rows
        child: DataRowWidget(index: index, item: item, gridItems: gridItems),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spacing between dropdown and button
      children: [
        DropdownButton<String>(
          items: <String>['Option 1', 'Option 2', 'Option 3']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {},
          hint: Text('Select an option'),
          style: TextStyle(color: Colors.blueAccent),
          underline: Container(
            height: 2,
            color: Colors.blueAccent,
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text('Submit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent, // Button background color
            overlayColor: Colors.white, // Button text color
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // Button padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded button
            ),
          ),
        ),
      ],
    );
  }
}
