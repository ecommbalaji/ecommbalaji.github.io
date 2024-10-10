import 'package:flutter/material.dart';
import 'package:webcatalog/desktop/desktop_appbar.dart';
import 'package:webcatalog/mobile/mobile_appbar.dart';
import 'package:webcatalog/mobile/mobile_body.dart';
import '../desktop/desktop_body.dart';
import '../service/order_item_service.dart';
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
    bool isDesktop = MediaQuery.of(context).size.width >= 600;
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
    
    if(isDesktop)
    return Scaffold(
      appBar: DesktopAppBar(tabController: _tabController, orderItemList: orderItemList, onCategoryChanged: _onCategoryChanged, onSubCategoryChanged: _onSubCategoryChanged, onSearchChanged: _onSearchChanged),
      body: DesktopProductsBody(tabController: _tabController, filteredItems: filteredItems),
    );
    else
      return Scaffold(
        appBar: MobileAppBar(tabController: _tabController, orderItemList: orderItemList, onCategoryChanged: _onCategoryChanged, onSubCategoryChanged: _onSubCategoryChanged, onSearchChanged: _onSearchChanged),
        body: MobileProductsBody(tabController: _tabController, filteredItems: filteredItems),
      );
  }

  void _onCategoryChanged(String? value) {
    setState(() {
      _selectedCategory = value == 'All' ? '' : value!;
    });
  }

  void _onSubCategoryChanged(String? value) {
    setState(() {
      _selectedSubCategory = value == 'All' ? '' : value!;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

}
