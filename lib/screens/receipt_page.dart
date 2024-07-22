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
            // Aligning order number and customer details horizontally to the right
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
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
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            Text('${entry.value.qty}', style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
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
        <body style="width:100%">
         <h1>Order Request Receipt</h1>
          <table>
          <tr>
         <td>
           Order Number: $orderNumber 
           Date: $formattedDate 
          </td>
          <td>
          Customer Details:
          Name or Branch Name: $nameOrBranch 
          Mobile Number: $mobile 
          Email Address: $email 
          </td>
          </tr>
          </table>
          
          <table>
            <tr>
              <th>Sr No</th>
              <th>Product Name</th>
              <th>Category</th>
              <th>Subcategory</th>
              <th>Quantity</th>
            </tr> ''';

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
          Total Products: $totalProducts
          Total Quantity: $totalQuantity
        </body>
      </html>''';

    return htmlContent;
  }
}
