import 'package:flutter/material.dart';

enum Volume {
  low,
  medium,
  full,
}

class GroceryItem {
  final String id;
  final String name;
  final Volume volume;
  final Color color;
  final int quantity;
  final DateTime date;
  final bool isComplete;

  GroceryItem({
    required this.id,
    required this.name,
    required this.volume,
    required this.color,
    required this.quantity,
    required this.date,
    this.isComplete = false,
  });

  GroceryItem copyWith({
    String? id,
    String? name,
    Volume? volume,
    Color? color,
    int? quantity,
    DateTime? date,
    bool? isComplete,
  }) {
    return GroceryItem(
        id: id ?? this.id,
        name: name ?? this.name,
        volume: volume ?? this.volume,
        color: color ?? this.color,
        quantity: quantity ?? this.quantity,
        date: date ?? this.date,
        isComplete: isComplete ?? this.isComplete);
  }
}
