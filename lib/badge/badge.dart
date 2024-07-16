import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/order_summary_page.dart';
import '../statemanagement/cart_counter_cubit.dart';

class ShoppingCartBadge extends StatefulWidget {
  @override
  _ShoppingCartBadgeState createState() => _ShoppingCartBadgeState();
}

class _ShoppingCartBadgeState extends State<ShoppingCartBadge> {
  @override
  Widget build(BuildContext context) {


      return BlocBuilder<CartCubit, int>(builder: (context, count) {

        return GestureDetector(

          child: badges.Badge(

            badgeContent: Text(
              '$count', // Dynamically update the cart count
              style: TextStyle(color: Colors.red),
            ),
            badgeStyle: badges.BadgeStyle(
              badgeColor: Colors.white,
              // Badge color
            ),
            child: Icon(Icons.shopping_cart, color: Colors.white, size: 40,),
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderSummaryPage()),
                )
              } // when clicked on number
          ),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrderSummaryPage()), //when clicked on cart icon
            )
          },
        );
      });

  }
}
