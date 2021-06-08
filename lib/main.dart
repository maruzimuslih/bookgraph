import 'package:bookgraph/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookGraph',
      theme: ThemeData(        
        primaryColor: Colors.cyan[900],
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}