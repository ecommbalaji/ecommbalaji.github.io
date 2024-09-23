import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  final String ordernum;
  const SuccessPage({super.key, required this.ordernum});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Your order request number was successfully submitted by email to Balaji Print Media',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Please save the request number for future reference : '+ ordernum,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}