// main.dart

import 'package:flutter/material.dart';
import 'logo.dart'; // Import the LogoPage widget

void main() {
runApp(MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key}); // Added a key (recommended best practice)

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false, // <-- Added this line to remove DEBUG banner
title: 'Dashboard Example',
theme: ThemeData(
primarySwatch: Colors.blue,
),
home: LogoPage(), // Set the LogoPage as the home widget
);
}
}