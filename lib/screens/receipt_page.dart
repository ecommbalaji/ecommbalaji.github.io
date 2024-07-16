import 'package:flutter/material.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as html2pdf;
import 'package:intl/intl.dart';
import 'dart:html' as html;
import '../vo/order_item.dart';

class ReceiptPage extends StatelessWidget {
  final List<OrderItem> orderItems;
  final String orderNumber;

  ReceiptPage({required this.orderItems, required this.orderNumber});

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
          style: TextStyle(fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Order Number: $orderNumber', style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black)),
            Text('Date: $formattedDate', style: TextStyle(color: Colors.black)),
            SizedBox(height: 20),

            // Address left aligned
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('To,', style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
                  Text('Balaji Print Media',
                      style: TextStyle(color: Colors.black)),
                  Text('Shop No:-586, 1st Floor',
                      style: TextStyle(color: Colors.black)),
                  Text('Sector-45 C', style: TextStyle(color: Colors.black)),
                  Text('Chandigarh', style: TextStyle(color: Colors.black)),
                  Text('160047 Chandigarh',
                      style: TextStyle(color: Colors.black)),
                  Text('India', style: TextStyle(color: Colors.black)),
                  Text('GSTIN 04BMDPM4905J1Z5',
                      style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Please supply the below items:', style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 10),

            // Scrollable table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(8),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade300),
                      children: const [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Sr No', style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Image', style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Details', style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...orderItems
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key;
                      OrderItem item = entry.value;
                      return TableRow(
                        children: [
                          TableCell(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('${index + 1}',
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 80,
                                height: 80,
                                child: item.imageUrl != null
                                    ? Image.network(
                                    item.imageUrl!, fit: BoxFit.contain)
                                    : Container(color: Colors.grey.shade300),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('ID: ${item.itemId}', style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                                  Text(item.productName, style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                                  Text('Quantity: ${item.qty}',
                                      style: TextStyle(color: Colors.black)),
                                  if (item.category != null) Text(
                                      'Category: ${item.category!}',
                                      style: TextStyle(color: Colors.black)),
                                  if (item.subCategory != null) Text(
                                      'Subcategory: ${item.subCategory!}',
                                      style: TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
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
                  Text('Total Products: $totalProducts', style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
                  Text('Total Quantity: $totalQuantity', style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
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
        }));
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
            body { font-family: sans-serif;background-color: lightblue; }
            table { width: 100%; border-collapse: collapse; }
            th, td { border: 1px solid black; padding: 8px; text-align: left; }
            th { background-color: #f2f2f2; }
            .center { text-align: center; }
            .bold { font-weight: bold; }
            img {
              max-width: 100px; 
              max-height: 100px; 
              height:100px; 
              width: 100px;
            }
          </style>
        </head>
        <body>
          <h1 class="center bold">Order Request Receipt</h1>
          <p class="bold">Order Number: $orderNumber</p>
          <p>Date: $formattedDate</p>

          <h4>To:</h4>
          <p class="bold">Balaji Print Media</p>
          <p>Shop No:-586, 1st Floor</p>
          <p>Sector-45 C</p>
          <p>Chandigarh</p>
          <p>160047 Chandigarh</p>
          <p>India</p>
          <p>GSTIN 04BMDPM4905J1Z5</p>

          <h4>Please supply the below items:</h4>
          <table>
            <tr>
              <th>Sr No</th>
              <th>Details</th>
            </tr>''';

    for (var i = 0; i < orderItems.length; i++) {
      final item = orderItems[i];
      htmlContent += '''
        <tr>
              <td class="center">${i + 1}</td>
              <td class="center">
                <p class="bold">ID: ${item.itemId}<br/>
                ${item.productName}<br/>
                Quantity: ${item.qty}<br/>
                ${item.category != null ? 'Category: ${item.category}<br/>' : ''}
                ${item.subCategory != null ? 'Subcategory: ${item.subCategory}</p>' : ''}
              </td>
           
            </tr>''';
    }

    htmlContent += '''
          </table>
          <div style="text-align: right;">
            <p class="bold">Total Products: $totalProducts</p><br/>
            <p class="bold">Total Quantity: $totalQuantity</p>
          </div>
        </body>
      </html>''';

    return htmlContent;
  }

}



