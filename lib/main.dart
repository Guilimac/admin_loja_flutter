import 'package:flutter/material.dart';
import 'package:loja_admin/screens/login_screen.dart';

void main()=> runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Loja Admin",
      theme: ThemeData(
        primaryColor: Colors.pinkAccent
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen()
    );
  }
}
