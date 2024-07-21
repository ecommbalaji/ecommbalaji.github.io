import 'package:flutter/material.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as html2pdf;
import 'package:intl/intl.dart';
import 'dart:html' as html;
import '../vo/order_item.dart';

class ReceiptPage extends StatelessWidget {
  final List<OrderItem> orderItems;
  final String orderNumber;
  final String nameOrBranch;
  final String mobile;
  final String email;

  ReceiptPage({
    required this.orderItems,
    required this.orderNumber,
    required this.nameOrBranch,
    required this.mobile,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);

    // Calculate total products and total quantity
    final totalProducts = orderItems.length;
    final totalQuantity = orderItems.fold(0, (sum, item) => sum + item.qty);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Request Receipt',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              await convertHtmlToPdf();
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Number: $orderNumber',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            Text(
              'Date: $formattedDate',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Customer Details:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            Text(
              'Name or Branch Name: $nameOrBranch',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              'Mobile Number: $mobile',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              'Email Address: $email',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            SizedBox(height: 20),
            // Scrollable table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 20,
                  columns: [
                    DataColumn(
                      label: Text(
                        'Sr No',
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
                        'Quantity',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                  rows: orderItems
                      .asMap()
                      .entries
                      .map(
                        (entry) => DataRow(
                      cells: [
                        DataCell(
                          Text('${entry.key + 1}', style: TextStyle(fontSize: 16)),
                        ),
                        DataCell(
                          Text(entry.value.productName, style: TextStyle(fontSize: 16)),
                        ),
                        DataCell(
                          Text(entry.value.category ?? '', style: TextStyle(fontSize: 16)),
                        ),
                        DataCell(
                          Text(entry.value.subCategory ?? '', style: TextStyle(fontSize: 16)),
                        ),
                        DataCell(
                          Text('${entry.value.qty}', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Footer with total products and total quantity
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Products: $totalProducts',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                  ),
                  Text(
                    'Total Quantity: $totalQuantity',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> convertHtmlToPdf() async {
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

  String generateHtml() {
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(now);

    // Calculate total products and total quantity
    final totalProducts = orderItems.length;
    final totalQuantity = orderItems.fold(0, (sum, item) => sum + item.qty);

    String htmlContent = '''
      <!DOCTYPE html>
      <html>
        <head>
          <style>
            body { font-family: sans-serif; background-color: lightblue; }
            table { width: 100%; border-collapse: collapse; }
            th, td { border: 1px solid black; padding: 8px; text-align: left; }
            th { background-color: #f2f2f2; }
            .center { text-align: center; }
            .bold { font-weight: bold; }
            .large { font-size: 20px; }
          </style>
        </head>
        <body>
          <h1 class="center bold">Order Request Receipt</h1>
          <p class="bold large">Order Number: $orderNumber</p>
          <p>Date: $formattedDate</p>
          <p><strong>Customer Details:</strong></p>
          <p>Name or Branch Name: $nameOrBranch</p>
          <p>Mobile Number: $mobile</p>
          <p>Email Address: $email</p>
          <table>
            <tr>
              <th>Sr No</th>
              <th>Product Name</th>
              <th>Category</th>
              <th>Subcategory</th>
              <th>Quantity</th>
            </tr>''';

    for (var i = 0; i < orderItems.length; i++) {
      final item = orderItems[i];
      htmlContent += '''
        <tr>
          <td>${i + 1}</td>
          <td>${item.productName}</td>
          <td>${item.category ?? ''}</td>
          <td>${item.subCategory ?? ''}</td>
          <td>${item.qty}</td>
        </tr>''';
    }

    htmlContent += '''
          </table>
          <p>Total Products: $totalProducts</p>
          <p>Total Quantity: $totalQuantity</p>
        </body>
      </html>''';

    return htmlContent;
  }
}
