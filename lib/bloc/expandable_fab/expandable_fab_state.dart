// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:stow/utils/firebase.dart';
// import '../models/food_item.dart';
// import '../models/user.dart';
// import 'package:equatable/equatable.dart';

// enum ExpandableFabStatus { initial, success, error, loading }

// extension ExpandableFabStatusX on ExpandableFabStatus {
//   bool get isInitial => this == ExpandableFabStatus.initial;
//   bool get isSuccess => this == ExpandableFabStatus.success;
//   bool get isError => this == ExpandableFabStatus.error;
//   bool get isLoading => this == ExpandableFabStatus.loading;
// }

// class ExpandableFabState extends Equatable {
//   const ExpandableFabState(
//       {this.status = ExpandableFabStatus.initial, required bool open})
//       : open = open;

//   final bool open;
//   final ExpandableFabStatus status;

//   @override
//   List<Object?> get props => [status, open];

//   ExpandableFabState copyWith({ExpandableFabStatus? status, bool? open}) {
//     return ExpandableFabState(
//         open: open ?? this.open, status: status ?? this.status);
//   }
// }
