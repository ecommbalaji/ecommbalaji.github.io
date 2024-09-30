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
        qty: 0,
        category: row[2]?.value?.toString(),
        subCategory: row[3]?.value?.toString(),
        price: row[4]?.value?.toString(),
        remarks: row[5]?.value?.toString(),
        images: row[6]?.value?.toString().split(","),
        dimension: row[7]?.value?.toString(), // Assuming this is the Dimension column
        unit: row[8]?.value?.toString(),       // Assuming this is the Unit column
        slotPriceMapping: _parseSlotPriceMapping(row[9]?.value?.toString()), // Assuming this is the SlotPriceMapping column
      );
      orderItems.add(orderItem);
    }

    return orderItems;
  }

  // Helper method to parse the slot price mapping from a string
  Map<String, double>? _parseSlotPriceMapping(String? slotPriceMappingStr) {
    if (slotPriceMappingStr == null || slotPriceMappingStr.isEmpty) {
      return null;
    }

    Map<String, double> slotPrices = {};
    List<String> slots = slotPriceMappingStr.split(',');

    for (String slot in slots) {
      List<String> parts = slot.split(':');
      if (parts.length == 2) {
        String key = parts[0].trim();
        double value = double.tryParse(parts[1].trim()) ?? 0.0;
        slotPrices[key] = value;
      }
    }
    return slotPrices;
  }
}
