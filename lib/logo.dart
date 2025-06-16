import 'package:flutter/material.dart';
import 'profile_data.dart'; // Import the ProfileData class

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Use the ProfileData singleton
  final ProfileData profileData = ProfileData();

  // Edit mode
  bool isEditing = false;

  // Controllers for text fields
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController registrationController;

  // Local variables for email and registration (not needed for the bill)
  String email = "john.doe@example.com";
  String registrationNo = "REG123456";
// Validation states
  String? phoneError;
  String? emailError;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current profile data
    nameController = TextEditingController(text: profileData.name);
    emailController = TextEditingController(text: email);
    phoneController = TextEditingController(text: profileData.phoneNo);
    addressController = TextEditingController(text: profileData.address);
    registrationController = TextEditingController(text: registrationNo);
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) {
        // Reset errors when exiting edit mode
        phoneError = null;
        emailError = null;
      }
    });
  }

  bool validatePhoneNumber(String phone) {
    final RegExp phoneRegExp = RegExp(r'^\d{10}$');
    return phoneRegExp.hasMatch(phone);
  }

  bool validateEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  void saveProfile() {
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();

    setState(() {
      phoneError = validatePhoneNumber(phone) ? null : 'Please enter a valid phone number (10 digits).';
      emailError = validateEmail(email) ? null : 'Please enter a valid email address.';

      if (phoneError == null && emailError == null) {
        // Update the ProfileData singleton
        profileData.updateProfile(
          name: nameController.text.trim(),
          address: addressController.text.trim(),
          phoneNo: phoneController.text.trim(),
        );
        this.email = email;
        registrationNo = registrationController.text.trim();
        isEditing = false; // Exit edit mode
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully!'),
              backgroundColor: Color(0xFF1E3A8A)),
        );
      }
    });
  }

  @override
  void dispose() {
    // Clean up controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    registrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Color(0xFF1E3A8A))), // Set title color to match the dashboard
        backgroundColor: Colors.white, // Set AppBar background color to white
        elevation: 2, // Slight elevation for shadow effect
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
            TextField(
              controller: nameController,
              enabled: isEditing,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
            SizedBox(height: 10),
            Text('Email:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
            TextField(
              controller: emailController,
              enabled: isEditing,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                errorText: isEditing ? emailError : null,
              ),
            ),
            if (isEditing && emailError != null) SizedBox(height: 5),
            if (isEditing && emailError != null) Text(emailError!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            Text('Phone No:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
            TextField(
              controller: phoneController,
              enabled: isEditing,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                errorText: isEditing ? phoneError : null,
              ),
            ),
            if (isEditing && phoneError != null) SizedBox(height: 5),
            if (isEditing && phoneError != null) Text(phoneError!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 10),
            Text('Address:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
            TextField(
              controller: addressController,
              enabled: isEditing,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              maxLines: 2, // Allow multi-line input for address
            ),
            SizedBox(height: 10),
            Text('Registration No:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
            TextField(
              controller: registrationController,
              enabled: isEditing,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: toggleEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditing ? Color(0xFFF97316) : Color(0xFF1E3A8A), // Orange for Cancel, Dark blue for Edit
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(isEditing ? 'Cancel' : 'Edit', style: TextStyle(color: Colors.white)),
                ),
                if (isEditing) // Show Save button only in edit mode
                  ElevatedButton(
                    onPressed: saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E3A8A), // Dark blue
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}