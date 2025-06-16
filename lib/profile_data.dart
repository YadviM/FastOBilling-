// profile_data.dart
import 'package:intl/intl.dart';

class ProfileData {
  static final ProfileData _instance = ProfileData._internal();

  factory ProfileData() {
    return _instance;
  }

  ProfileData._internal();

  String name = "John Doe"; // Default name
  String address = "123 Main St, City, Country"; // Default address
  String phoneNo = "1234567890"; // Default phone number

  // List to store transaction history
  final List<Map<String, dynamic>> transactions = [];

  // Getter for transactions to ensure instance access
  List<Map<String, dynamic>> get allTransactions => transactions;

  void updateProfile({required String name, required String address,
    required String phoneNo}) {
    this.name = name;
    this.address = address;
    this.phoneNo = phoneNo;
  }

  void addTransaction({
    required double saleAmount,
    required String paymentMethod,
    required String dateTime,
    required String billNumber,
  }) {
    transactions.add({
      'saleAmount': saleAmount,
      'paymentMethod': paymentMethod,
      'dateTime': dateTime,
      'billNumber': billNumber,
    });

    // Sort transactions by dateTime in descending order (most recent first)
    transactions.sort((a, b) {
      final DateFormat format = DateFormat('dd/MM/yy hh:mm a');
      final DateTime dateA = format.parse(a['dateTime']);
      final DateTime dateB = format.parse(b['dateTime']);
      return dateB.compareTo(dateA); // Descending order
    });
  }
}