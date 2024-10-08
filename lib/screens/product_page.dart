import 'package:flutter/material.dart';
import '../badge/badge.dart';
import '../cards/product_card.dart';
import '../dropdowns/category_subcategory_filter.dart';
import '../service/order_item_service.dart';
import '../table/product_table.dart';
import '../vo/order_item.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedCategory = '';
  String _selectedSubCategory = '';

  late List<OrderItem> orderItemList = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchOrderItemList();
  }

  void fetchOrderItemList() async {
    List<OrderItem> items = await OrderItemService().fetchOrderItems();
    setState(() {
      orderItemList = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter items based on search and filters
    final filteredItems = orderItemList.where((item) {
      final matchesSearch = item.productName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.itemId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.subCategory!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory.isEmpty || item.category == _selectedCategory;
      final matchesSubCategory = _selectedSubCategory.isEmpty || item.subCategory == _selectedSubCategory;
      return matchesSearch && matchesCategory && matchesSubCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        elevation: 0,
        titleSpacing: 20,
        toolbarHeight: 120,  // Increase toolbar height to accommodate padding
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // First row: Heading "Balaji Print Media" with padding from top
            Padding(
              padding: const EdgeInsets.only(top: 16.0),  // Padding from top
              child: const Text(
                'Balaji Print Media',
                style: TextStyle(
                  fontSize: 28,  // Larger font size for elegance
                  fontWeight: FontWeight.bold,
                  color: Colors.amberAccent,  // Elegant color contrasting with indigo background
                  letterSpacing: 1.5,  // Slightly increased letter spacing for a refined look
                  fontFamily: 'Georgia',  // Elegant serif font for a classic touch
                ),
              ),
            ),
            const SizedBox(height: 8), // Space between heading and second row

            // Second row: Search box, dropdowns, and cart icon
            Row(
              children: [
                // Search TextField with search icon
                Expanded(
                  flex: 2,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final hintText = 'Search By Products/Item Id/Category/Subcategory';
                      final textPainter = TextPainter(
                        text: TextSpan(text: hintText, style: const TextStyle(fontSize: 16.0)),
                        maxLines: 1,
                        textDirection: TextDirection.ltr,
                      );
                      textPainter.layout(minWidth: 0, maxWidth: constraints.maxWidth);

                      return Container(
                        height: 40,
                        width: textPainter.width + 50, // Adjust width with some padding
                        margin: const EdgeInsets.symmetric(horizontal: 16.0),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
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
                            hintText: hintText,
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Dropdowns: Category and Subcategory
                Expanded(
                  flex: 3,
                  child: CascadingDropdown(
                    orderItems: orderItemList,
                    onCategoryChanged: (String? value) {
                      setState(() {
                        _selectedCategory = value == 'All' ? '' : value!;
                      });
                    },
                    onSubCategoryChanged: (String? value) {
                      setState(() {
                        _selectedSubCategory = value == 'All' ? '' : value!;
                      });
                    },
                  ),
                ),

                // Cart Icon
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 100.0), // Adjust spacing
                  child: const ShoppingCartBadge(),
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.grid_view), text: 'Grid View'),
            Tab(icon: Icon(Icons.table_chart), text: 'Table View'),
          ],
          labelColor: Colors.yellowAccent,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 4,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(), // Smooth scroll
                children: [
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 455,
                      mainAxisExtent: 556,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ProductCard(item);
                    },
                  ),
                  SingleChildScrollView(
                    child: SizedBox(
                      height: 800,
                      width: MediaQuery.of(context).size.width,
                      child: ProductTable(gridItems: filteredItems),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
