import 'package:flutter/material.dart';

import '../badge/badge.dart';
import '../dropdowns/category_subcategory_filter.dart';
import '../vo/order_item.dart';  // Import your ShoppingCartBadge widget

class DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final List<OrderItem> orderItemList;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onSubCategoryChanged;
  final ValueChanged<String> onSearchChanged;

  DesktopAppBar({
    required this.tabController,
    required this.orderItemList,
    required this.onCategoryChanged,
    required this.onSubCategoryChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.indigo[900],
      elevation: 0,
      titleSpacing: 20,
      toolbarHeight: 100,  // Increase toolbar height to accommodate padding
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // First row: Heading "Balaji Print Media" with padding from top
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
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
                        onChanged: onSearchChanged,
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
                  onCategoryChanged: onCategoryChanged,
                  onSubCategoryChanged: onSubCategoryChanged,
                ),
              ),

              // Cart Icon
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 100.0),
                child: const ShoppingCartBadge(),
              ),
            ],
          ),
        ],
      ),
      bottom: TabBar(
        controller: tabController,
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(170);  // Adjust height as per your requirements
}
