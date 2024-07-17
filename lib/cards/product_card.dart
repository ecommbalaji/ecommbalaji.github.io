import 'package:flutter/material.dart';
import 'package:webcatalog/vo/order_item.dart';

import '../button/add_to_cart_button.dart';
import '../dropdowns/quantity_selector.dart';
import '../image/cached_image.dart';

class ProductCard extends StatefulWidget {
  final OrderItem orderItem;
  int selectedQty = 0;
  ProductCard(this.orderItem);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      child: Card(
        color: Colors.white.withOpacity(0.9),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
              CachedImageWidget(imageUrl: widget.orderItem.imageUrl!),
              const SizedBox(height: 10.0),
              // Item ID
              Text(
                'Item ID: ${widget.orderItem.itemId}',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 5.0),
              // Product Name
              Tooltip(
                message: widget.orderItem.productName,
                child: Text(
                  widget.orderItem.productName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5.0),
              // Product Category
              Text(
                'Category: ${widget.orderItem.category ?? ''}',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 5.0),
              // Product Subcategory
              Text(
                'Subcategory: ${widget.orderItem.subCategory ?? ''}',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 5.0),
              // Add to Cart Button
              Row(
                children: [
                  AddToCartButton(selectedQuantity: widget.selectedQty, orderItem: widget.orderItem),
                  Spacer(),
                  QuantitySelector(onChanged: (int value) {
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

  @override
  bool get wantKeepAlive => true;
}
