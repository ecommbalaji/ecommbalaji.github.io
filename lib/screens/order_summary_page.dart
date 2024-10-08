
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:webcatalog/statemanagement/cart_counter_cubit.dart';
import 'contact_details.dart';
import '../ordersummary/order_summary_widget.dart';
import '../statemanagement/order_cubit.dart';
import '../vo/order_item.dart';
// Import the ReceiptPage

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Summary')),
      body: Column(
        children: [
          Flexible(
            flex: 2,
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
                        context.read<OrderCubit>().removeOrderItem(item, item.selectedSlotIndex!);
                      },
                      onQuantityChanged: (newQty) {
                        context.read<CartCubit>().addToCart(newQty!-item.qty);
                        context.read<OrderCubit>().updateOrderQty(item, newQty, item.selectedSlotIndex!);
                      },
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(1.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerFormWidget(),
                  ),
                );
              },
              child: const Text('Contact Details'),
            ),
          )

        ],
      ),
    );
  }



// Example usage:

}
