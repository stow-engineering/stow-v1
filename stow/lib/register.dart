import 'package:flutter/material.dart';
import 'database.dart';

class Register extends StatelessWidget {
  const Register({Key? key, required this.mac}) : super(key: key);

  final String mac;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Device"),
        actions: [],
      ),
      body: Center(child: Text(mac)),
    );
  }
}
