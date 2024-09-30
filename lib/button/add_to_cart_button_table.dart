import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webcatalog/vo/order_item.dart';
import '../statemanagement/cart_counter_cubit.dart';
import '../statemanagement/order_cubit.dart';

class AddToCartButtonTable extends StatefulWidget {
  final int selectedQuantity;
  final OrderItem orderItem;

  const AddToCartButtonTable({super.key, required this.selectedQuantity, required this.orderItem});
  @override
  _AddToCartButtonTableState createState() => _AddToCartButtonTableState();
}

class _AddToCartButtonTableState extends State<AddToCartButtonTable> {
  void _addProductToCart(BuildContext context) {
  bool canAdd =  context.read<OrderCubit>().addOrderItem(widget.orderItem, widget.selectedQuantity, 0, "", "");
  if(!canAdd){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quantity for a given product cannot be more than 1000')));
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
      child: const Text('Add to cart'), // Toggle button text
    );
  }
}