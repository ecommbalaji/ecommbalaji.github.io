import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'receipt_page.dart';
import '../statemanagement/order_cubit.dart';
import '../vo/order_item.dart';

class CustomerFormWidget extends StatefulWidget {
  @override
  _CustomerFormWidgetState createState() => _CustomerFormWidgetState();
}

class _CustomerFormWidgetState extends State<CustomerFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameBranchController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _navigateToOrderReceipt(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final orderItems = context.read<OrderCubit>().state;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptPage(
              orderItems: orderItems,
              orderNumber: generateCustomString(),
              nameOrBranch: _nameBranchController.text,
              mobile: _mobileController.text,
              email: _emailController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(child: BlocBuilder<OrderCubit, List<OrderItem>>(
            builder: (context, orderItems) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameBranchController,
                  decoration: InputDecoration(
                    labelText: 'Name / Branch ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name or branch name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () => _navigateToOrderReceipt(context),
                  child: Text('Proceed To Checkout'),
                ),
              ],
            ),
          );
        })),
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
    String randomAlphabets = String.fromCharCodes(Iterable.generate(
        4, (_) => chars.codeUnitAt(random.nextInt(chars.length))));

    // 3. Combine date and alphabets
    String result = formattedDate + randomAlphabets;
    return result.toUpperCase();
  }
}
