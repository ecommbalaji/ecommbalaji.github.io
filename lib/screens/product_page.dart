import 'package:flutter/material.dart';
import '../badge/badge.dart';
import '../cards/product_card.dart';
import '../dropdowns/category_subcategory_filter.dart';
import '../service/order_item_service.dart';
import '../vo/order_item.dart';

class ProductPage extends StatefulWidget  {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>  {
  String _searchQuery = '';
  String _selectedCategory = '';
  String _selectedSubCategory = '';

  late List<OrderItem> orderItemList = [];

  @override
  void initState()  {
    super.initState();
    fetchOrderItemList();
  }

  void fetchOrderItemList() async {
    List<OrderItem> items =  await OrderItemService().fetchOrderItems();
    setState(()  {
      orderItemList = items;
    });

  }

  @override
  Widget build(BuildContext context) {
    // Filter items based on search and filters
    final filteredItems = orderItemList.where((item) {
      final matchesSearch = item.productName
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory.isEmpty || item.category == _selectedCategory;
      final matchesSubCategory = _selectedSubCategory.isEmpty ||
          item.subCategory == _selectedSubCategory;
      return matchesSearch && matchesCategory && matchesSubCategory;
    }).toList();


    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.indigo[900],
        // Dark, professional background
        elevation: 0,
        // Remove shadow for a cleaner look
        titleSpacing: 20,
        // Add spacing before the search bar

        title: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.5,
          // Adjust height as needed
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          // Add horizontal margin
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          // Add padding to input
          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(25.0), // Rounded search bar
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // Subtle shadow
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3)
              ),
            ],
          ),
          child: TextField(

            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search Products',

              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey), // Search icon
            ),
          ),
        ),
        actions: [
          // Category Dropdown
      Padding(
      padding: const EdgeInsets.only(right: 20.0),
          child: CascadingDropdown(orderItems: orderItemList,
              onCategoryChanged: (String? value) {
                setState(() {
                  _selectedCategory = value == 'Select' ? '' : value!;
                });
              },
              onSubCategoryChanged: (String? value) {
                setState(() {
                  _selectedSubCategory = value == 'Select' ? '' : value!;
                });
              }

          )),
          // Subcategory Dropdown (styled similarly to the Category dropdown)
          // ...
          ShoppingCartBadge(),

          SizedBox(width: 16), // Add spacing after print button
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 450, // Set maximum width for each item
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return ProductCard(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


}
