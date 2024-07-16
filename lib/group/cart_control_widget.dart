import 'package:flutter/material.dart';
import 'package:webcatalog/vo/order_item.dart';

import '../button/add_to_cart_button.dart';
import '../dropdowns/quantity_selector.dart';

class CartControlsWidget extends StatefulWidget {
  int quantity = 0;
  final OrderItem orderItem;

  CartControlsWidget(this.orderItem);

  @override
  _CartControlsWidgetState createState() => _CartControlsWidgetState();
}

class _CartControlsWidgetState extends State<CartControlsWidget> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AddToCartButton(selectedQuantity: widget.quantity, orderItem: widget.orderItem),
        Spacer(),
        QuantitySelector(
          onChanged: (int value) {
            setState(() {
              widget.quantity = value;
            });

          },
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
