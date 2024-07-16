import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
                return ListView.builder(
                  itemCount: orderItems.length,
                  itemBuilder: (context, index) {
                    final item = orderItems[index];
                    return OrderItemWidget(
                      orderItem: item,
                      onRemove: () {
                        context.read<OrderCubit>().removeOrderItem(item);
                      },
                      onQuantityChanged: (newQty) {
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
                final orderItems = context.read<OrderCubit>().state;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceiptPage(orderItems: orderItems, orderNumber: generateCustomString(),),
                  ),
                );
              },
              child: Text('Proceed to CheckOut'),
            ),
          ),
        ],
      ),
    );
  }

  String generateCustomString() {
    // 1. Get current date and time
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('ddMMyyyyHHmmss').format(now);

    // 2. Generate 4 random alphabets
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    Random random = Random();
    String randomAlphabets = String.fromCharCodes(
        Iterable.generate(4, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );

    // 3. Combine date and alphabets
    String result = formattedDate + randomAlphabets;
    return result.toUpperCase();
  }

// Example usage:

}
