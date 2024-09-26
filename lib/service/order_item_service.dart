import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_excel/excel.dart';
import 'package:http/http.dart' as http;


import '../vo/order_item.dart';

class OrderItemService {
  static String? url = dotenv.env["SERVER_EXCEL_URL"];

  Future<List<OrderItem>> fetchOrderItems() async {
    // Download the Excel file
    final response = await http.get(Uri.parse(url!));
    if (response.statusCode != 200) {
      throw Exception('Failed to load Excel file');
    }

    // Parse the Excel file
    var bytes = response.bodyBytes;
    var excel = Excel.decodeBytes(bytes);

    // Assuming the first sheet contains the data
    var sheet = excel.tables.keys.first;
    var rows = excel.tables[sheet]?.rows ?? [];

    // Skip the header row and map the data to OrderItem objects
    List<OrderItem> orderItems = [];
    for (var row in rows.skip(1)) {
      var orderItem = OrderItem(
        itemId: row[0]?.value?.toString() ?? '',
        productName: row[1]?.value?.toString() ?? '',
        qty:  0,
        category: row[2]?.value?.toString(),
        subCategory: row[3]?.value?.toString(),
        price: row[4]?.value?.toString(),
        remarks: row[5]?.value?.toString(),
        images: row[6]?.value?.toString().split(",")
      );
      orderItems.add(orderItem);
    }

    return orderItems;
  }
}
