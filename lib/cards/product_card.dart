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
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.orderItem.slotPriceMapping != null && widget.orderItem.slotPriceMapping!.isNotEmpty) {
      widget.selectedSlot = widget.orderItem.slotPriceMapping!.keys.first;
      selectedPrice = widget.orderItem.slotPriceMapping![widget.selectedSlot];
      widget.selectedPrice = selectedPrice.toString();
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
              // Selectable Buttons for Slot Selection
              if (widget.orderItem.slotPriceMapping != null && widget.orderItem.slotPriceMapping!.isNotEmpty)
                _buildSelectableButtons(),

              // Specifications
              if (widget.orderItem.remarks != null && widget.orderItem.remarks!.isNotEmpty) ...[
                const SizedBox(height: 12.0),
                Expanded(
                  child: SpecificationPopup(specs: 'Specifications: ${widget.orderItem.remarks ?? ''}'),
                ),
              ],


              // Add to Cart Button
              Row(
                children: [
                  AddToCartButtonGrid(
                    selectedQuantity: widget.selectedQty,
                    orderItem: widget.orderItem,
                    slotIndex: widget.slotIndex,
                    slot: widget.selectedSlot,
                    price: widget.selectedPrice ?? widget.orderItem.price,
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

  Widget _buildSelectableButtons() {
    return Container(
      height: 90, // Set a fixed height for the scrollable area
      child: Row(
        children: [
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // At least 3 buttons in a row
                childAspectRatio: 4, // Adjusted aspect ratio for oval shape
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: widget.orderItem.slotPriceMapping!.length,
              itemBuilder: (context, index) {
                String slot = widget.orderItem.slotPriceMapping!.keys.elementAt(index);
                bool isSelected = widget.selectedSlot == slot; // Check if the slot is selected
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.selectedSlot = slot;
                      selectedPrice = widget.orderItem.slotPriceMapping![slot];
                      widget.slotIndex = index;
                      widget.selectedPrice = selectedPrice?.toString();
                    });
                  },
                  child: Container(
                  //  padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 3), // Smaller padding for smaller buttons
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent : Colors.white, // Highlight if selected
                      borderRadius: BorderRadius.circular(30.0), // Oval shape
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        slot,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black, // Change text color based on selection
                          //fontWeight: FontWeight.bold,
                          fontSize: 16.0, // Smaller font size
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                onPressed: () {
                  // Scroll up
                  _scrollController.animateTo(
                    _scrollController.position.pixels - 50,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              const SizedBox(height: 8.0), // Space between the button and the arrows
              IconButton(
                icon: const Icon(Icons.arrow_downward),
                onPressed: () {
                  // Scroll down
                  _scrollController.animateTo(
                    _scrollController.position.pixels + 50,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
