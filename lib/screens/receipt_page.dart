import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as html2pdf;
import 'package:intl/intl.dart';
import 'package:webcatalog/screens/success_page.dart';
import 'dart:html' as html;
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

  ReceiptPage({super.key, 
    required this.orderItems,
    required this.orderNumber,
    required this.nameOrBranch,
    required this.mobile,
    required this.email,
    required this.address
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
            color: Colors.black,
          ),
        )

      ),
      body:
      SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aligning order number and customer details horizontally to the right
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Number: $orderNumber',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Date: $formattedDate',
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customer Details:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Name or Branch Name: $nameOrBranch',
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      'Mobile Number: $mobile',
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      'Email : $email',
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),

                       Text(
                        'Address: $splitAddress',
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                      ),


                  ],

                ),
              ],
            ),
            // Scrollable table



       Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columnSpacing: 20,
          columns: const [
            DataColumn(
              label: Text(
                'Sr No',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'Item Id',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'Product Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'Category',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'Subcategory',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'Slot',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'Price (per Unit)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),

            DataColumn(
              label: Text(
                'Quantity',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            DataColumn(
              label: Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
          rows: orderItems
              .asMap()
              .entries
              .map(
                (entry) {
              final item = entry.value;
              final total = double.parse(item.price!) * item.qty;
              totalSum += total;
              return DataRow(
                color: entry.key % 2 == 0 ? WidgetStateProperty.all(Colors.grey[100]) : WidgetStateProperty.all(Colors.white),
                cells: [
                  DataCell(Text('${entry.key + 1}', style: const TextStyle(fontSize: 16))),
                  DataCell(Text(item.itemId ?? '', style: const TextStyle(fontSize: 16))),
                  DataCell(Text(item.productName, style: const TextStyle(fontSize: 16))),
                  DataCell(Text(item.category ?? '', style: const TextStyle(fontSize: 16))),
                  DataCell(Text(item.subCategory ?? '', style: const TextStyle(fontSize: 16))),
                  DataCell(Text(item.selectedSlot ?? '', style: const TextStyle(fontSize: 16))),
                  DataCell(Text('₹${item.price}', style: const TextStyle(fontSize: 16))),
                  DataCell(Text('${item.qty}', style: const TextStyle(fontSize: 16), textAlign: TextAlign.center)),
                  DataCell(Text('₹$total', style: const TextStyle(fontSize: 16), textAlign: TextAlign.center)),
                ],
              );
            },
          )
              .toList()
            ..add(DataRow(
              cells: [
                const DataCell(Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                const DataCell(Text('')),
                const DataCell(Text('')),
                const DataCell(Text('')),
                const DataCell(Text('')),
                const DataCell(Text('')),
                const DataCell(Text('')),
                const DataCell(Text('')),
                DataCell(Text('₹${totalSum.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              ],
            )),
        ),
      ),
    ),

            const SizedBox(height: 20),
            // Footer with total products and total quantity
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Products: $totalProducts',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                  ),
                  Text(
                    'Total Quantity: $totalQuantity',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 20),
            // Centered Submit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the buttons horizontally
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white
                  ),
                  onPressed: () async {
                    await  getPresignedUrl("$orderNumber.pdf").then((presignedurl) async {
                      await convertHtmlToPdf(presignedurl).then((_){
                        invokeSnsApi(context, orderNumber,  presignedurl.split('?').first);
                      });
                    });
                  },
                  child: const Text('Submit'),
                )
              ],
            ),
          ],
        ),
      )
    ),

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
        const snackBar = SnackBar(
          content: Text("Request Failed, Contact Support!"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

}
