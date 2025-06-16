import 'package:flutter/material.dart';
import 'item.dart';
import 'bill.dart';
import 'profile_data.dart';
import 'package:intl/intl.dart';

class MenuPage extends StatefulWidget {
  final List<Item> items;

  MenuPage({Key? key, required this.items}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String searchQuery = '';
  Map<int, int> itemQuantities = {};
  String sortOption = 'Name';
  String paymentMethod = 'Cash';

  String _generateBillNumber() {
    return 'INV_${DateTime.now().millisecondsSinceEpoch % 1000}'.padLeft(7, '0');
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items.where((item) {
      return item.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    if (sortOption == 'Name') {
      filteredItems.sort((a, b) => a.name.compareTo(b.name));
    } else if (sortOption == 'Price') {
      filteredItems.sort((a, b) => a.price.compareTo(b.price));
    }

    double totalPrice = 0.0;
    List<Map<String, dynamic>> selectedItems = [];
    itemQuantities.forEach((index, quantity) {
      if (quantity > 0) {
        totalPrice += quantity * widget.items[index].price;
        selectedItems.add({
          'item': widget.items[index],
          'quantity': quantity,
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search items...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
        ),
        actions: [
          DropdownButton<String>(
            value: sortOption,
            icon: Icon(Icons.sort, color: Colors.white),
            dropdownColor: Colors.white,
            underline: SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                sortOption = newValue!;
              });
            },
            items: <String>['Name', 'Price']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                final itemIndex = widget.items.indexOf(item);

                return Card(
                  elevation: 3,
                  child: Column(
                    children: [
                      Image.network(
                        item.imageUrl,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.broken_image, size: 100);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('₹${item.price.toStringAsFixed(2)}'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (itemQuantities[itemIndex] != null &&
                                    itemQuantities[itemIndex]! > 0) {
                                  itemQuantities[itemIndex] =
                                      itemQuantities[itemIndex]! - 1;
                                }
                              });
                            },
                          ),
                          Text(itemQuantities[itemIndex]?.toString() ?? '0'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                itemQuantities[itemIndex] =
                                    (itemQuantities[itemIndex] ?? 0) + 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Total Price: ₹${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio<String>(
                      value: 'UPI',
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                    ),
                    Text('UPI'),
                    Radio<String>(
                      value: 'Cash',
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                    ),
                    Text('Cash'),
                    Radio<String>(
                      value: 'Cheque',
                      groupValue: paymentMethod,
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value!;
                        });
                      },
                    ),
                    Text('Cheque'),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: selectedItems.isNotEmpty
                      ? () async {
                    final billNumber = _generateBillNumber();
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BillPage(
                          selectedItems: selectedItems,
                          totalPrice: totalPrice,
                          paymentMethod: paymentMethod,
                          billNumber: billNumber,
                        ),
                      ),
                    );
                    if (result != null) {
                      final profileData = ProfileData();
                      profileData.addTransaction(
                        saleAmount: totalPrice,
                        paymentMethod: paymentMethod,
                        dateTime: DateFormat('dd/MM/yy hh:mm a')
                            .format(DateTime.now()),
                        billNumber: billNumber,
                      );
                    }
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],        // Active & disabled background
                    foregroundColor: Colors.white,            // Active text color
                    disabledBackgroundColor: Colors.blue[900], // Disabled background
                    disabledForegroundColor: Colors.white,     // Disabled text color
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Generate Bill'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}