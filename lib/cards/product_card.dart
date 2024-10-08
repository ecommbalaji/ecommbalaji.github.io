import 'package:flutter/material.dart';
import 'package:webcatalog/dropdowns/grid_qty_selector.dart';
import 'package:webcatalog/popup/specification_popup.dart';
import 'package:webcatalog/snackbar/top_snackbar.dart';
import 'package:webcatalog/vo/order_item.dart';

import '../button/add_to_cart_button_grid.dart';
import '../carousal/image_carousal.dart';
import '../image/cached_image.dart';
import 'package:flutter/services.dart'; // For Clipboard

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

    // If slotPriceMapping is available, initialize the first slot and price
    if (widget.orderItem.slotPriceMapping != null && widget.orderItem.slotPriceMapping!.isNotEmpty) {
      widget.selectedSlot = widget.orderItem.slotPriceMapping!.keys.first; // First slot by default
      selectedPrice = widget.orderItem.slotPriceMapping![widget.selectedSlot]; // Price for the first slot
      widget.selectedPrice = selectedPrice?.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
      elevation: 4.0,
      child: Stack(
        children: [
          Card(
            color: Colors.white.withOpacity(0.95),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  SizedBox(
                    height: 200,
                    child: ImageCarousal(images: lisTImages),
                  ),
                  const SizedBox(height: 12.0),
                  SelectableText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Item ID: ${widget.orderItem.itemId.trim()}\n',
                          style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                        ),
                        TextSpan(
                          text: 'Product Name: $orderItmName\n',
                          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: 'Category: ${widget.orderItem.category ?? ''}\n',
                          style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                        ),
                        TextSpan(
                          text: 'Subcategory: ${widget.orderItem.subCategory ?? ''}\n',
                          style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                        ),
                        TextSpan(
                          text: 'Price: ₹${selectedPrice?.toString() ?? widget.orderItem.price ?? ''}\n',
                          style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                        ),
                        if (widget.orderItem.remarks != null && widget.orderItem.remarks!.isNotEmpty)
                          TextSpan(
                            text: 'Specifications: ${widget.orderItem.remarks}\n',
                            style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                          ),
                      ],
                    ),
                    showCursor: true,
                    cursorColor: Colors.blue,
                    cursorWidth: 2.0,
                    style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                  ),
                  const SizedBox(height: 12.0),
                  if (widget.orderItem.slotPriceMapping != null && widget.orderItem.slotPriceMapping!.isNotEmpty)
                    _buildSelectableButtons(),
                  const Spacer(),
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
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.copy, color: Colors.black54),
              onPressed: () {
                if (imagePaths != null && imagePaths.isNotEmpty) {
                  Clipboard.setData(ClipboardData(text: imagePaths.first));
                  TopSnackBar.show(context, 'Image URL copied to clipboard');
                } else {
                  TopSnackBar.show(context, 'No image available to copy');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectableButtons() {
    return Container(
      height: 90,
      child: Row(
        children: [
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: widget.orderItem.slotPriceMapping!.length,
              itemBuilder: (context, index) {
                String slot = widget.orderItem.slotPriceMapping!.keys.elementAt(index);
                bool isSelected = widget.selectedSlot == slot;

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
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueAccent : Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(
                        color: isSelected ? Colors.blueAccent : Colors.grey.withOpacity(0.6),
                        width: 1.0,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: Colors.blueAccent.withOpacity(0.3), blurRadius: 8)]
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          slot,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                  _scrollController.animateTo(
                    _scrollController.position.pixels - 50,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
              const SizedBox(height: 8.0),
              IconButton(
                icon: const Icon(Icons.arrow_downward),
                onPressed: () {
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
