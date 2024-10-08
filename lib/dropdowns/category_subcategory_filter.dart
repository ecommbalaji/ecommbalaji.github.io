import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../vo/order_item.dart';

class CascadingDropdown extends StatefulWidget {
  final List<OrderItem> orderItems;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onSubCategoryChanged;

  const CascadingDropdown({super.key,
    required this.orderItems,
    required this.onCategoryChanged,
    required this.onSubCategoryChanged,
  });

  @override
  _CascadingDropdownState createState() => _CascadingDropdownState();
}

class _CascadingDropdownState extends State<CascadingDropdown> {
  String? selectedCategory;
  String? selectedSubCategory;

  @override
  void initState() {
    super.initState();
    if (widget.orderItems.isNotEmpty) {
      selectedCategory = 'All';
      selectedSubCategory = 'All';
    }
  }

  Map<String, List<String>> getCategorySubCategoryMap() {
    Map<String, List<String>> categorySubCategoryMap = {'All': ['All']};
    for (var item in widget.orderItems) {
      if (!categorySubCategoryMap.containsKey(item.category)) {
        categorySubCategoryMap[item.category!] = ['All'];
      }
      if (!categorySubCategoryMap[item.category]!.contains(item.subCategory)) {
        categorySubCategoryMap[item.category]!.add(item.subCategory!);
      }
    }
    return categorySubCategoryMap;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<String>> categorySubCategoryMap = getCategorySubCategoryMap();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Category: ",
          style: TextStyle(
              color: Colors.white, fontFamily: 'Times New Roman', fontSize: 16),
        ),
        _buildDropdown(
          hint: 'Select',
          value: selectedCategory,
          items: categorySubCategoryMap.keys.toList(),
          onChanged: (newValue) {
            setState(() {
              selectedCategory = newValue;
              selectedSubCategory = 'All';
              widget.onCategoryChanged(newValue);
            });
          },
        ),
        const SizedBox(width: 12), // Adjusted space between dropdowns
        const Text(
          "Sub-Category: ",
          style: TextStyle(
              color: Colors.white, fontFamily: 'Times New Roman', fontSize: 16),
        ),
        _buildDropdown(
          hint: 'Select',
          value: selectedSubCategory,
          items: selectedCategory != null
              ? categorySubCategoryMap[selectedCategory]!
              : ['All'],
          onChanged: (newValue) {
            setState(() {
              selectedSubCategory = newValue;
              widget.onSubCategoryChanged(newValue);
            });
          },
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 40, // Set height to match the search box
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // Adjust margin for spacing
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0), // Make it oval
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Subtle shadow
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          hint: Text(hint, style: const TextStyle(fontSize: 14)), // Adjusted font size
          value: value,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)), // Adjusted font size
            );
          }).toList(),
        ),
      ),
    );
  }
}
