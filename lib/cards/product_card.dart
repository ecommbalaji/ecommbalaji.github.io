import 'package:flutter/material.dart';
import 'package:webcatalog/dropdowns/grid_qty_selector.dart';
import 'package:webcatalog/popup/specification_popup.dart';
import 'package:webcatalog/vo/order_item.dart';

import '../button/add_to_cart_button_grid.dart';
import '../carousal/image_carousal.dart';
import '../image/cached_image.dart';

class ProductCard extends StatefulWidget {
  final OrderItem orderItem;
  int selectedQty = 0;
  String? selectedSlot;
  int slotIndex = 0;
  String? selectedPrice;

  ProductCard(this.orderItem, {super.key});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with AutomaticKeepAliveClientMixin {
  double? selectedPrice;

  @override
  void initState() {
    super.initState();
    if (widget.orderItem.slotPriceMapping != null && widget.orderItem.slotPriceMapping!.isNotEmpty) {
      widget.selectedSlot = widget.orderItem.slotPriceMapping!.keys.first;
      selectedPrice = widget.orderItem.slotPriceMapping![widget.selectedSlot];
    }
  }

  @override
  Widget build(BuildContext context) {
    String orderItmName = widget.orderItem.productName.trim().replaceAll("\n", '');
    List<ZoomableCachedImageWidget> lisTImages = [];
    List<String>? imagePaths = widget.orderItem.images;

    if (imagePaths != null && imagePaths.isNotEmpty) {
      for (var path in imagePaths) {
        lisTImages.add(ZoomableCachedImageWidget(imageUrl: path));
      }
    }

    return Material(
      color: Colors.white,
      elevation: 0,
      child: Card(
        color: Colors.white.withOpacity(0.9),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Increased padding for elegance
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              SizedBox(
                height: 200,
                child: ImageCarousal(images: lisTImages),
              ),
              const SizedBox(height: 12.0),
              // Item ID
              _buildLabel('Item ID: ${widget.orderItem.itemId.trim()}'),
              const SizedBox(height: 6.0),
              // Product Name
              Tooltip(
                message: orderItmName,
                child: Text(
                  orderItmName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0, // Slightly larger font
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6.0),
              // Product Category
              _buildLabel('Category: ${widget.orderItem.category ?? ''}'),
              const SizedBox(height: 6.0),
              // Product Subcategory
              _buildLabel('Subcategory: ${widget.orderItem.subCategory ?? ''}'),
              const SizedBox(height: 6.0),
              // Price Display
              _buildLabel('Price: ₹${selectedPrice?.toString() ?? widget.orderItem.price ?? ''}'),
              const SizedBox(height: 12.0),
              // Dropdown for Slot Selection
              if (widget.orderItem.slotPriceMapping != null && widget.orderItem.slotPriceMapping!.isNotEmpty)
                _buildDropdown(),
              const SizedBox(height: 12.0),
              // Specifications
              Flexible(
                child: SpecificationPopup(specs: 'Specifications: ${widget.orderItem.remarks ?? ''}'),
              ),
              const SizedBox(height: 12.0),
              // Add to Cart Button
              Row(
                children: [
                  AddToCartButtonGrid(
                    selectedQuantity: widget.selectedQty,
                    orderItem: widget.orderItem,
                    slotIndex: widget.slotIndex,
                    slot: widget.selectedSlot,
                    price: widget.selectedPrice,
                  ),
                  const Spacer(),
                  GridQtySelector(onChanged: (int value) {
                    setState(() {
                      widget.selectedQty = value;
                    });
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14.0, color: Colors.black87), // More subdued color
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueAccent, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.selectedSlot != null) // Show the dimension (unit) when a slot is selected
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Text(
                '${widget.orderItem.dimension} (${widget.orderItem.unit})',
                style: const TextStyle(fontSize: 14.0, color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),
            ),
          DropdownButton<String>(
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text('Select ${widget.orderItem.dimension} (${widget.orderItem.unit})'),
            ),
            isExpanded: true,
            value: widget.selectedSlot,
            onChanged: (String? newValue) {
              setState(() {
                widget.selectedSlot = newValue;
                selectedPrice = widget.orderItem.slotPriceMapping![newValue];
                widget.slotIndex = widget.orderItem.slotPriceMapping!.keys.toList().indexOf(newValue!);
                widget.selectedPrice = selectedPrice?.toString();
              });
            },
            items: widget.orderItem.slotPriceMapping!.keys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(value),
                ),
              );
            }).toList(),
            underline: SizedBox(),
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
