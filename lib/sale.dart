// sale.dart
import 'package:flutter/material.dart';
import 'profile_data.dart'; // Import the ProfileData class
import 'package:intl/intl.dart'; // For formatting date and time

class SalePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileData = ProfileData();
    print('Transactions length: ${profileData.transactions.length}'); // Debug print

    // Group transactions by date
    final groupedTransactions = _groupTransactionsByDate(profileData.transactions);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Transactions'),
        elevation: 4,
        backgroundColor: Colors.teal[100],
      ),
      body: groupedTransactions.isEmpty
          ? Center(
        child: Text(
          'No transactions yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: groupedTransactions.length,
        itemBuilder: (context, index) {
          final date = groupedTransactions.keys.elementAt(index);
          final transactionsForDate = groupedTransactions[date]!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  date,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
              ),
              // Transactions for this date
              ...transactionsForDate.asMap().entries.map((entry) {
                final transactionIndex = entry.key;
                final transaction = entry.value;
                return _buildTransactionCard(context, transaction, transactionIndex, transactionsForDate.length);
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  // Group transactions by date (ignoring time)
  Map<String, List<Map<String, dynamic>>> _groupTransactionsByDate(List<Map<String, dynamic>> transactions) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    final DateFormat dateFormat = DateFormat('dd/MM/yy');
    final DateFormat displayFormat = DateFormat('dd MMM yyyy');

    for (var transaction in transactions) {
      final dateTimeStr = transaction['dateTime'] as String;
      final DateTime dateTime = dateFormat.parse(dateTimeStr.split(' ').sublist(0, 1).join(' '));
      final String dateKey = displayFormat.format(dateTime);

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }

    // Sort dates in descending order (most recent first)
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        final DateTime dateA = displayFormat.parse(a);
        final DateTime dateB = displayFormat.parse(b);
        return dateB.compareTo(dateA);
      });

    final Map<String, List<Map<String, dynamic>>> sortedGrouped = {};
    for (var key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }

  Widget _buildTransactionCard(BuildContext context, Map<String, dynamic> transaction, int index, int totalForDate) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          _showTransactionDetails(context, transaction);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[100]!, Colors.teal[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.receipt,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              // Transaction Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaction #${totalForDate - index}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[900],
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount: ₹${transaction['saleAmount'].toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        Text(
                          transaction['paymentMethod'],
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Time: ${transaction['dateTime'].split(' ').sublist(1).join(' ')}',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Transaction Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[700],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _buildDetailRow('Sale Amount', '₹${transaction['saleAmount'].toStringAsFixed(2)}'),
                _buildDetailRow('Bill No', transaction['billNumber']),
                _buildDetailRow('Date & Time', transaction['dateTime']),
                _buildDetailRow('Payment Method', transaction['paymentMethod']),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[100],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}