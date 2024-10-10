import 'package:flutter/material.dart';
import 'package:webcatalog/vo/order_item.dart';

import '../cards/product_card.dart';
import '../table/product_table.dart';

class MobileProductsBody extends StatelessWidget {
  final TabController tabController;
  final List<OrderItem> filteredItems; // Replace 'dynamic' with the actual type of items

  const MobileProductsBody({
    Key? key,
    required this.tabController,
    required this.filteredItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16.0),
          Expanded(
            child: TabBarView(
              controller: tabController,
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
                    return ProductCard(item); // Ensure ProductCard is defined elsewhere
                  },
                ),
                SingleChildScrollView(
                  child: SizedBox(
                    height: 800,
                    width: MediaQuery.of(context).size.width,
                    child: ProductTable(gridItems: filteredItems), // Ensure ProductTable is defined elsewhere
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
