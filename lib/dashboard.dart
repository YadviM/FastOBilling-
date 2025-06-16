import 'package:flutter/material.dart';
import 'profile.dart'; // Import the ProfilePage widget
import 'items.dart'; // Import the ItemsPage widget
import 'sale.dart'; // Import the SalePage widget
import 'menu.dart'; // Import the MenuPage widget
import 'logo.dart'; // Import the LogoPage widget
import 'item.dart'; // Import the Item model
import 'profile_data.dart'; // Import the ProfileData class
import 'package:intl/intl.dart'; // For date formatting

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  List<Item> items = []; // List to hold items

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop(); // Close the drawer
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LogoPage()),
                      (Route<dynamic> route) => false,
                ); // Navigate to LogoPage
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  // Calculate today's total sales
  double _calculateTodaysSales() {
    final ProfileData profileData = ProfileData();
    final DateTime today = DateTime(2025, 4, 4); // Current date is April 4, 2025
    final DateFormat dateFormat = DateFormat('dd/MM/yy');
    double totalSales = 0.0;

    for (var transaction in profileData.transactions) {
      final transactionDate = dateFormat.parse(transaction['dateTime'].split(' ')[0]);
      if (transactionDate.year == today.year &&
          transactionDate.month == today.month &&
          transactionDate.day == today.day) {
        totalSales += transaction['saleAmount'];
      }
    }
    return totalSales;
  }

  @override
  Widget build(BuildContext context) {
    final ProfileData profileData = ProfileData();
    final String currentName = profileData.name;
    final String registrationNo = "REG123456"; // Assuming this is stored in profileData or hardcoded
    final DateTime now = DateTime.now();
    final String dateTimeStr = DateFormat('dd/MM/yyyy hh:mm a').format(now);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Color(0xFF1E3A8A)), // Three-line menu icon
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              currentName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A), // Updated color
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Reg No: $registrationNo',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(width: 10),
                Text(
                  dateTimeStr,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'FastOBilling',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xFF4B6CB7), // Lighter blue
              ),
            ),
            ListTile(
              title: Text('Profile', style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold)), // Updated color and made bold
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              title: Text('Items', style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold)), // Updated color and made bold
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ItemsPage(items: items),
                  ),
                ).then((_) {
                  setState(() {
                    // Update the items list in the MenuPage
                    items = items; // This line is not necessary, but you can update if needed
                  });
                });
              },
            ),
            ListTile(
              title: Text('Menu', style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold)), // Updated color and made bold
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MenuPage(items: items),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Sale', style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold)), // Updated color and made bold
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SalePage()),
                );
              },
            ),
            ListTile(
              title: Text('Logout', style: TextStyle(color: Color(0xFF1E3A8A), fontWeight: FontWeight.bold)), // Updated color and made bold
              onTap: () {
                Navigator.of(context).pop();
                _logout();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Sales card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Color(0xFFF97316), width: 2), // Orange border
              ),
              color: Colors.white, // White background
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today\'s Sales',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)), // Updated color and made bold
                    ),
                    Text(
                      '₹${_calculateTodaysSales().toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)), // Updated color and made bold
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: Text(
                'Welcome to the Dashboard',
                style: TextStyle(fontSize: 24, color: Color(0xFF1E3A8A)), // Updated color
              ),
            ),
          ),
        ],
      ),
    );
  }
}