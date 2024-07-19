import 'package:flutter/material.dart';
import 'package:webcatalog/datarows/order_data_row.dart';
import '../badge/badge.dart';
import '../cards/product_card.dart';
import '../dropdowns/category_subcategory_filter.dart';
import '../dropdowns/quantity_selector.dart';
import '../button/add_to_cart_button.dart';
import '../service/order_item_service.dart';
import '../vo/order_item.dart';

class ProductPage extends StatefulWidget {
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
      final matchesSearch = item.productName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory.isEmpty || item.category == _selectedCategory;
      final matchesSubCategory = _selectedSubCategory.isEmpty || item.subCategory == _selectedSubCategory;
      return matchesSearch && matchesCategory && matchesSubCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        elevation: 0,
        titleSpacing: 20,
        title: Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.5,
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
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
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CascadingDropdown(
              orderItems: orderItemList,
              onCategoryChanged: (String? value) {
                setState(() {
                  _selectedCategory = value == 'Select' ? '' : value!;
                });
              },
              onSubCategoryChanged: (String? value) {
                setState(() {
                  _selectedSubCategory = value == 'Select' ? '' : value!;
                });
              },
            ),
          ),
          ShoppingCartBadge(),
          SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.grid_view), text: 'Grid View'),
            Tab(icon: Icon(Icons.table_chart), text: 'Table View'),
          ],
          labelColor: Colors.black,
          indicatorColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorWeight: 4,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: BouncingScrollPhysics(), // Smooth scroll
                children: [
                  GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 450,
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
                  SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                      child: DataTable(
                        headingRowHeight: 50.0,
                        dataRowHeight: 60.0,
                        columnSpacing: 20.0,
                        columns: [
                          DataColumn(label: Text(''))
                        ],
                        rows: List.generate(filteredItems.length, (index) {
                          final item = filteredItems[index];
                          return DataRow(
                            cells: [
                              DataCell(OrderDataRow(index: index, item: item))
                            ],
                          );
                        }),
                      ),
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
