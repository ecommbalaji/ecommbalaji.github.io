import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'receipt_page.dart';
import '../statemanagement/order_cubit.dart';
import '../vo/order_item.dart';

class CustomerFormWidget extends StatefulWidget {
  const CustomerFormWidget({super.key});

  @override
  _CustomerFormWidgetState createState() => _CustomerFormWidgetState();
}

class _CustomerFormWidgetState extends State<CustomerFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameBranchController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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
            email: _emailController.text.isNotEmpty ? _emailController.text : 'N/A',
            address: _addressController.text.isNotEmpty ? _addressController.text : 'N/A',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: BlocBuilder<OrderCubit, List<OrderItem>>(
                builder: (context, orderItems) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle('Enter your details'),
                        const SizedBox(height: 20.0),
                        _buildTextField(
                          controller: _nameBranchController,
                          labelText: 'Name / Branch',
                          hintText: 'Enter your name or branch name',
                          icon: Icons.person,
                          validatorMessage: 'Please enter your name or branch name',
                        ),
                        const SizedBox(height: 20.0),
                        _buildTextField(
                          controller: _mobileController,
                          labelText: 'Mobile Number',
                          hintText: 'Enter your mobile number',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          validatorMessage: 'Please enter your mobile number',
                          additionalValidator: (value) {
                            if (!RegExp(r'^\+?[0-9]{10,}$').hasMatch(value!)) {
                              return 'Please enter a valid mobile number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        _buildTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          hintText: 'Enter your email (optional)',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          additionalValidator: (value) {
                            // Email field is optional, only validate if it's not empty
                            if (value != null && value.isNotEmpty && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        _buildTextField(
                          controller: _addressController,
                          labelText: 'Address',
                          hintText: 'Enter your address (optional)',
                          icon: Icons.location_on,
                          maxLines: 5,
                          validatorMessage: null, // Address is not mandatory
                        ),
                        const SizedBox(height: 30.0),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              )),
                            onPressed: () => _navigateToOrderReceipt(context),
                            child: const Text(
                              'Proceed To Checkout',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurpleAccent,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    String? validatorMessage,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? additionalValidator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.deepPurpleAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.deepPurpleAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
        ),
        contentPadding: const EdgeInsets.all(16.0),
      ),
      validator: (value) {
        if (validatorMessage != null && (value == null || value.isEmpty)) {
          return validatorMessage;
        }
        if (additionalValidator != null) {
          return additionalValidator(value);
        }
        return null;
      },
    );
  }

  String generateCustomString() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('ddMMyyyyHHmmss').format(now);
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    Random random = Random();
    String randomAlphabets = String.fromCharCodes(
      Iterable.generate(4, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
    return (formattedDate + randomAlphabets).toUpperCase();
  }
}
