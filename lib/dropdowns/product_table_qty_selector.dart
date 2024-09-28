import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ProductTableQtySelector extends StatefulWidget {
  final ValueChanged<int> onChanged;

  const ProductTableQtySelector({super.key, required this.onChanged});

  @override
  _ProductTableQtySelectorState createState() => _ProductTableQtySelectorState();
}

class _ProductTableQtySelectorState extends State<ProductTableQtySelector> {
  int selectedValue = 0; // Initial selected quantity

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: DropdownButton2<int>(
        isExpanded: false,
        isDense: true,
        items: List.generate(1001, (index) => index)
            .map((value) => DropdownMenuItem<int>(
          value: value,
          child: Text('$value'),
        ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value!;
            widget.onChanged(selectedValue);
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: 100,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Colors.white,
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_downward_rounded,
          ),
          iconSize: 14,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300, // Adjust maxHeight to fit your needs
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          )
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
