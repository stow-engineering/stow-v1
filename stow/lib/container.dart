import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Container {
  final int value;
  final String uid;
  final String barcode;
  final bool full;
  final String user;
  final String name;

  Container(
      {this.value = 0,
      this.uid = '',
      this.barcode = '',
      this.full = true,
      this.user = '',
      this.name = ''});

  Container copyWith({
    int? value,
    String? uid,
    String? barcode,
    bool? full,
    String? user,
    String? name,
  }) {
    return Container(
      value: value ?? this.value,
      uid: uid ?? this.uid,
      barcode: barcode ?? this.barcode,
      full: full ?? this.full,
      user: user ?? this.user,
      name: name ?? this.name,
    );
  }
}
