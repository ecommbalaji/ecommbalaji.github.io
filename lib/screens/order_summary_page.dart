
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:webcatalog/statemanagement/cart_counter_cubit.dart';
import 'contact_details.dart';
import '../ordersummary/order_summary_widget.dart';
import '../statemanagement/order_cubit.dart';
import '../vo/order_item.dart';
import 'receipt_page.dart'; // Import the ReceiptPage

class OrderSummaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Summary')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<OrderCubit, List<OrderItem>>(
              builder: (context, orderItems) {
                final orderItems = context.read<OrderCubit>().state;
                return ListView.builder(
                  itemCount: orderItems.length,
                  itemBuilder: (context, index) {
                    final item = orderItems[index];
                    return OrderSummaryWidget(
                      orderItem: item,
                      onRemove: () {
                        context.read<CartCubit>().removeFromCart(item.qty);
                        context.read<OrderCubit>().removeOrderItem(item);
                      },
                      onQuantityChanged: (newQty) {
                        context.read<CartCubit>().addToCart(newQty!-item.qty);
                        context.read<OrderCubit>().updateOrderQty(item, newQty!);
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerFormWidget(),
                  ),
                );
              },
              child: Text('Contact Details'),
            ),
          ),
        ],
      ),
    );
  }



// Example usage:

}
