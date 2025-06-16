import 'package:flutter/material.dart';
import 'item.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import 'profile_data.dart'; // Import the ProfileData class

class BillPage extends StatelessWidget {
  final List<Map<String, dynamic>> selectedItems;
  final double totalPrice;
  final String paymentMethod;
  final String billNumber;

  const BillPage({
    Key? key,
    required this.selectedItems,
    required this.totalPrice,
    required this.paymentMethod,
    required this.billNumber,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Fetch restaurant details from ProfileData
    final profileData = ProfileData();

    // Calculate total items and total quantity
    int totalItems = selectedItems.length;
    int totalQuantity = selectedItems.fold<int>(0, (sum, item) {
      return sum + (item['quantity'] as int);
    });

    // Get current date and time
    String formattedDateTime = DateFormat('dd/MM/yy hh:mm a').format(DateTime.now());

    // Footer tagline (kept as a constant since it's not part of ProfilePage)
    const String footerTagline = 'THANK YOU! VISIT AGAIN!';

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, billNumber); // Return bill number when back button is pressed
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bill'),
          actions: [
            IconButton(
              icon: Icon(Icons.print),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Printing bill...')),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                Navigator.pop(context, billNumber); // Return bill number when done button is pressed
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Header
                Center(
                  child: Column(
                    children: [
                      Text(
                        profileData.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        profileData.address,
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Phone: ${profileData.phoneNo}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                // Bill Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Bill No: $billNumber'),
                    Text('Date: $formattedDateTime'),
                  ],
                ),
                SizedBox(height: 5),
                Text('Bill To: $paymentMethod SALE'),
                Divider(),
                // Items Table Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 2, child: Text('Item Name', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 1, child: Text('Qty', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 1, child: Text('Rate', style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(flex: 1, child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                Divider(),
                // Items List
                ...selectedItems.asMap().entries.map((entry) {
                  Item item = entry.value['item'] as Item;
                  int quantity = entry.value['quantity'] as int;
                  double itemTotal = item.price * quantity;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 2, child: Text(item.name)),
                        Expanded(flex: 1, child: Text(quantity.toString())),
                        Expanded(flex: 1, child: Text(item.price.toStringAsFixed(2))),
                        Expanded(flex: 1, child: Text(itemTotal.toStringAsFixed(2))),
                      ],
                    ),
                  );
                }).toList(),
                Divider(),
                // Summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Items: $totalItems'),
                    Text('Total Quantity: $totalQuantity'),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sub Total', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('₹${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('₹0.00', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TOTAL', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('₹${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Received', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('₹${totalPrice.toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mode of Payment', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(paymentMethod, style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    footerTagline,
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}