import 'package:flutter/material.dart';
import 'package:webcatalog/dropdowns/grid_qty_selector.dart';
import 'package:webcatalog/popup/specification_popup.dart';
import 'package:webcatalog/vo/order_item.dart';

import '../button/add_to_cart_button_grid.dart';
import '../carousal/image_carousal.dart';
import '../dropdowns/product_table_qty_selector.dart';
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
    String orderItmName = widget.orderItem.productName.trim().replaceAll("\n", '');
    List<ZoomableCachedImageWidget> lisTImages = [];
    lisTImages.add(ZoomableCachedImageWidget(imageUrl: widget.orderItem.imageUrl!));
    lisTImages.add(ZoomableCachedImageWidget(imageUrl: widget.orderItem.imageUrl!));
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
          padding: const EdgeInsets.only(top: 8.0, left:8.0, right:8.0, bottom: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10.0),
             // ZoomableCachedImageWidget(imageUrl: widget.orderItem.imageUrl!),
              Container(
                height: 200,
                child:   ImageCarousal(images: lisTImages)
              ),

              const SizedBox(height: 10.0),
              // Item ID
              Text(
                'Item ID: ${widget.orderItem.itemId.trim()}',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 5.0),
              // Product Name
           Tooltip(
                message: orderItmName,
                child: Text(
                  orderItmName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  maxLines: 1,
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
              Text(
                'Price: ₹${widget.orderItem.price ?? ''}',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 5.0),
              Flexible(
              child: SpecificationPopup(specs: 'Specifications: ${widget.orderItem.remarks ?? ''}')
              ),
              const SizedBox(height: 5.0),
              // Add to Cart Button
              Row(
                children: [
                  AddToCartButtonGrid(selectedQuantity: widget.selectedQty, orderItem: widget.orderItem),
                  Spacer(),
                  GridQtySelector(onChanged: (int value) {
                    setState(() {
                      widget.selectedQty = value;
                    });
                  }),
                ],
              )
            ],
          ),
        )
        ),

    );
  }

  @override
  bool get wantKeepAlive => true;
}
