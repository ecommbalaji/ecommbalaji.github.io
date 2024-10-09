import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as html2pdf;
import 'package:intl/intl.dart';
import 'package:webcatalog/screens/success_page.dart';
import 'dart:html' as html;
import '../snackbar/top_snackbar.dart';
import '../vo/order_item.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ReceiptPage extends StatelessWidget {
  final List<OrderItem> orderItems;
  final String orderNumber;
  final String nameOrBranch;
  final String mobile;
  final String email;
  final String address;

  ReceiptPage({
    super.key,
    required this.orderItems,
    required this.orderNumber,
    required this.nameOrBranch,
    required this.mobile,
    required this.email,
    required this.address,
  });

  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);

    // Calculate total products and total quantity
    final totalProducts = orderItems.length;
    final totalQuantity = orderItems.fold(0, (sum, item) => sum + item.qty);
    final splitAddress = address.split(",").join(",\n");
    double totalSum = 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Request Receipt',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 5.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.deepPurple.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Aligning order number and customer details horizontally
              _buildOrderAndCustomerDetails(
                  orderNumber, formattedDate, nameOrBranch, mobile, email, splitAddress),
              const SizedBox(height: 20),

              // Scrollable table for order items
              _buildOrderItemsTable(orderItems, totalSum),
              const SizedBox(height: 20),

              // Footer with total products and total quantity
              _buildFooter(totalProducts, totalQuantity),

              const SizedBox(height: 40),

              // Centered submit button
              _buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderAndCustomerDetails(
      String orderNumber,
      String formattedDate,
      String nameOrBranch,
      String mobile,
      String email,
      String splitAddress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Number: $orderNumber',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.deepPurple.shade800,
                fontSize: 18,
              ),
            ),
            Text(
              'Date: $formattedDate',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Details:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 18,
              ),
            ),
            Text(
              'Name or Branch: $nameOrBranch',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Mobile: $mobile',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Email: $email',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Address:\n$splitAddress',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrderItemsTable(List<OrderItem> orderItems, double totalSum) {
    return Center(
      child: Container(
        height: 300, // Set a fixed height for the scrollable table
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, // Make the table scroll vertically
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Preserve horizontal scrolling
            child: DataTable(
              columnSpacing: 20,
              headingRowColor: MaterialStateProperty.resolveWith((states) => Colors.deepPurple.shade100),
              columns: const [
                DataColumn(label: Text('Sr No')),
                DataColumn(label: Text('Item Id')),
                DataColumn(label: Text('Product Name')),
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Subcategory')),
                DataColumn(label: Text('Slot')),
                DataColumn(label: Text('Price (per Unit)')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Total')),
              ],
              rows: orderItems.asMap().entries.map((entry) {
                final item = entry.value;
                final total = double.parse(item.price!) * item.qty;
                totalSum += total;
                return DataRow(
                  color: MaterialStateProperty.resolveWith(
                        (states) => entry.key % 2 == 0 ? Colors.grey.shade100 : Colors.white,
                  ),
                  cells: [
                    DataCell(Text('${entry.key + 1}')),
                    DataCell(Text(item.itemId ?? '')),
                    DataCell(Text(item.productName)),
                    DataCell(Text(item.category ?? '')),
                    DataCell(Text(item.subCategory ?? '')),
                    DataCell(Text(item.selectedSlot ?? '')),
                    DataCell(Text('₹${item.price}')),
                    DataCell(Text('${item.qty}')),
                    DataCell(Text('₹$total')),
                  ],
                );
              }).toList()
                ..add(DataRow(cells: [
                  const DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                  const DataCell(Text('')),
                  const DataCell(Text('')),
                  const DataCell(Text('')),
                  const DataCell(Text('')),
                  const DataCell(Text('')),
                  const DataCell(Text('')),
                  const DataCell(Text('')),
                  DataCell(Text('₹${totalSum.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold))),
                ])),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildFooter(int totalProducts, int totalQuantity) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Total Products: $totalProducts',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            'Total Quantity: $totalQuantity',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () async {
            await getPresignedUrl("$orderNumber.pdf").then((presignedUrl) async {
              await convertHtmlToPdf(presignedUrl).then((_) {
                invokeSnsApi(context, orderNumber, presignedUrl.split('?').first);
              });
            });
          },
          child: const Text(
            'Submit Order',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }


  Future<void> convertHtmlToPdf(String presignedUrl) async {
    final newpdf = html2pdf.Document();
    var htmlStr = generateHtml();
    final widgets = await html2pdf.HTMLToPdf().convert(htmlStr);
    newpdf.addPage(html2pdf.MultiPage(
      maxPages: 200,
      build: (context) {
        return widgets;
      },
    ));
    final bytes = await newpdf.save();
    final blob = html.Blob([bytes], 'application/pdf');

    final reader = html.FileReader();

    reader.readAsArrayBuffer(blob);

    reader.onLoadEnd.listen((e) async {
      try {
        // Upload to S3
        await uploadToS3(presignedUrl, reader.result as List<int>);
        logger.d('PDF sucessfully uploaded to S3 for order number: $orderNumber');
      }
      catch (e) {
        logger.e('Error during upload to S3 for order number: $orderNumber, error: $e');
      }
    });
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = "order_pdf.pdf";
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);

  }

  Future<String> getPresignedUrl(String fileName) async {
    var apiGatewayUrl =  dotenv.env["API_GATEWAY_URL"]; // Replace with your actual URL

    try {
      final response = await http.post(
        Uri.parse(apiGatewayUrl!),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'file_name': fileName}),
      );

      if (response.statusCode == 200) {
        final presignedUrl = jsonDecode(response.body)['presignedUrl'];
        logger.d('Received presigned URL: $presignedUrl');
        return presignedUrl;
      } else {
        throw Exception('Failed to get presigned URL');
      }
    } catch (e) {
      logger.e('Error fetching presigned URL for file: $fileName, error: $e');
      rethrow;
    }
  }

  Future<void> uploadToS3(String presignedUrl, List<int> fileBytes) async {
    logger.d('Uploading to S3 with URL: $presignedUrl');
    try {
      await http.put(
        Uri.parse(presignedUrl),
        body: fileBytes,
      );
      logger.d('Upload to S3 completed');
    } catch (e) {
      logger.e('Error uploading to S3: $e');
      rethrow;
    }
  }

  String generateHtml() {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);

    // Calculate total products and total quantity
    final totalProducts = orderItems.length;
    final totalQuantity = orderItems.fold(0, (sum, item) => sum + item.qty);
    final totalCost = orderItems.fold(0.0, (sum, item) {
      int qty = item.qty;
      double price = double.tryParse(item.price ?? '') ?? 0.0;
      double itemTotal = qty * price;
      return sum + itemTotal;
    }).toStringAsFixed(2);
    String htmlContent = '''
      <!DOCTYPE html>
      <html>
        <body style="width:100%">
         <h1>Order Request Receipt</h1>
          <table>
          <tr>
         <td>
         <p>
           Order Number: $orderNumber 
           Date: $formattedDate 
           <br>
           Customer Details:
           Name or Branch Name: $nameOrBranch 
           Mobile Number: $mobile 
           Email : $email 
           Address : $address 
           </p>
          </td>
         
          </tr>
          </table>
          
          <table>
            <tr>
              <th>Sr No</th>
              <th>Item Id</th>
              <th>Product Name</th>
              <th>Category</th>
              <th>Subcategory</th>
              <th>Slot</th>
              <th>Price</th>
              <th>Quantity</th>
              <th>Total</th>
            </tr> ''';

    for (var i = 0; i < orderItems.length; i++) {
      final item = orderItems[i];
      int qty = item.qty;
      double price = double.parse(item.price!);
      double totalPrice = qty * price;
      htmlContent += '''
        <tr>
          <td>${i + 1}</td>
          <td>${item.itemId}</td>
          <td>${item.productName}</td>
          <td>${item.category ?? ''}</td>
          <td>${item.subCategory ?? ''}</td>
           <td>${item.selectedSlot ?? ''}</td>
          <td>INR ${item.price ?? ''}</td>
          <td>${item.qty}</td>
           <td>INR ${totalPrice.toStringAsFixed(2)}</td>
        </tr>''';
    }

    htmlContent += '''
          </table>
          Total Products: $totalProducts
          Total Quantity: $totalQuantity
          Total Cost: INR $totalCost
        </body>
      </html>''';

    return htmlContent;
  }

  Future<void> invokeSnsApi( BuildContext context, String ordernum, String receiptUrl) async {
    const url = 'https://c1qdce11y0.execute-api.ap-south-1.amazonaws.com/prod/postEmails';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({'message': "Order placed with order number $ordernum. You can download the order request receipt by visiting $receiptUrl", 'ordernum': ordernum}),
      );

      if (response.statusCode == 200) {
        // Use pushReplacement for success navigation (avoids back button)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(ordernum: ordernum),
          ),
        );
      } else {
        print('Failed to send message: ${response.statusCode}');
      /*  const snackBar = SnackBar(
          content: Text("Request Failed, Contact Support!"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
        TopSnackBar.show(context, 'Request Failed, Contact Support!');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}
