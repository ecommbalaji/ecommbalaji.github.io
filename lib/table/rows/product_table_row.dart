import 'package:flutter/material.dart';
import '../../button/add_to_cart_button_table.dart';
import '../../dropdowns/product_table_qty_selector.dart';
import '../../vo/order_item.dart';

class DataRowWidget extends StatefulWidget {
  final int index;
  final OrderItem item;
  final List<OrderItem> gridItems;
  int selectedQty = 0;
  String? selectedSlot; // Field to store the selected slot
  int slotIndex = 0;
  String? slotPrice;

  DataRowWidget({
    super.key,
    required this.index,
    required this.item,
    required this.gridItems,
  });

  @override
  _DataRowWidgetState createState() => _DataRowWidgetState();
}

class _DataRowWidgetState extends State<DataRowWidget> {
  List<String> slotOptions = [];
  String? selectedSlot;

  @override
  void initState() {
    super.initState();
    // Populate slot options from SlotPriceMapping
    if (widget.item.slotPriceMapping != null) {
      slotOptions = widget.item.slotPriceMapping!.keys.toList();

      // Automatically select the first slot if available
      if (slotOptions.isNotEmpty) {
        selectedSlot = slotOptions[0];
        widget.selectedSlot = selectedSlot; // Set the default selected slot
        widget.slotIndex = 0;
        widget.slotPrice = _getPriceBasedOnSlot(); // Set the default price based on the first slot
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDataCell('${widget.index + 1}', 0.1, TextAlign.center),
        _buildDataCell(widget.item.itemId, 0.15, TextAlign.center),
        _buildDataCell(widget.item.productName, 0.2, TextAlign.left),
        _buildDataCell(widget.item.category ?? '', 0.15, TextAlign.center),
        _buildDataCell(widget.item.subCategory ?? '', 0.15, TextAlign.center),
        _buildDataCell('₹${_getPriceBasedOnSlot()}', 0.15, TextAlign.center), // Updated price based on slot
        _buildDataCell(widget.item.remarks ?? '', 0.15, TextAlign.center),
        _buildDataCell(widget.item.dimension ?? '', 0.15, TextAlign.center),
        _buildDataCell(widget.item.unit ?? '', 0.15, TextAlign.center),
        _buildSlotDropdown(), // Slot dropdown
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
            slotIndex: widget.slotIndex,
            slotValue: widget.selectedSlot,
            slotPrice: widget.slotPrice ?? widget.item.price,
          ),
        ),
      ],
    );
  }

  Widget _buildSlotDropdown() {
    return Expanded(
      flex: (0.10 * 100).toInt(),
      child: DropdownButton<String>(
        hint: const Text("Select Slot"),
        value: selectedSlot,
        isExpanded: true,
        items: slotOptions.map((String slot) {
          return DropdownMenuItem<String>(
            value: slot,
            child: Text(slot),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedSlot = value;
            widget.selectedSlot = value; // Update the selected slot in the parent widget
            widget.slotIndex = slotOptions.indexOf(value!);
            widget.slotPrice = _getPriceBasedOnSlot();
          });
        },
      ),
    );
  }

  String _getPriceBasedOnSlot() {
    if (selectedSlot != null && widget.item.slotPriceMapping != null) {
      return widget.item.slotPriceMapping![selectedSlot!].toString() ?? '0';
    }
    return widget.item.price?.toString() ?? '0';
  }

  Widget _buildDataCell(String text, double flex, TextAlign align) {
    return Expanded(
      flex: (flex * 100).toInt(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        constraints: const BoxConstraints(maxHeight: 60),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
          textAlign: align,
        ),
      ),
    );
  }
}
