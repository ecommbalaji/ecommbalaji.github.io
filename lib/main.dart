import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webcatalog/screens/product_page.dart';
import 'package:webcatalog/statemanagement/cart_counter_cubit.dart';
import 'package:webcatalog/statemanagement/order_cubit.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(),
        ),
        BlocProvider<OrderCubit>(
          create: (context) => OrderCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Balaji Ecommerce', // Replace with your app's title
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ProductPage(), // Set the ProductPage as the home screen
      ),
    );
  }
}
