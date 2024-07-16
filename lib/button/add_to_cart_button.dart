import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webcatalog/vo/order_item.dart';
import '../statemanagement/cart_counter_cubit.dart';
import '../statemanagement/order_cubit.dart';

class AddToCartButton extends StatefulWidget {
  final int selectedQuantity;
  final OrderItem orderItem;

  const AddToCartButton({super.key, required this.selectedQuantity, required this.orderItem});
  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  void _addProductToCart(BuildContext context) {
  bool canAdd =  context.read<OrderCubit>().addOrderItem(widget.orderItem, widget.selectedQuantity);
  if(!canAdd){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quantity for a given product cannot be more than 100')));
  } else {
    context.read<CartCubit>().addToCart(widget.selectedQuantity);
  }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:  () { _addProductToCart(context); },
      style: ElevatedButton.styleFrom(
        backgroundColor:  Colors.orange, // Change color if needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
      child: Text('Add to cart'), // Toggle button text
    );
  }
}