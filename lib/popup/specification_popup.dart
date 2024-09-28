import 'package:flutter/material.dart';

class SpecificationPopup extends StatelessWidget {
  final String specs;
   const SpecificationPopup({super.key, required this.specs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.centerLeft,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Specifications'),
                  content:  Text(specs, style: const TextStyle(fontSize: 14),),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Set the border radius to zero for straight edges
            ),
          ),
          child: const Text('Specifications'),
        ),
      ),
    );
  }
}