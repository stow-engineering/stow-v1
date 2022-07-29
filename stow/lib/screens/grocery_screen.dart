import 'package:flutter/material.dart';
import 'package:stow/models/user.dart';
import 'empty_grocery_screen.dart';

class GroceryScreen extends StatefulWidget {
  final StowUser user;
  const GroceryScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO 4: Add a scaffold widget
    return const EmptyGroceryScreen();
  }
}
