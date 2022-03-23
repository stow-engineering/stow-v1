import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Container {
  int value;
  String uid;
  String barcode;

  Container(this.value, this.uid, this.barcode, {int });
}