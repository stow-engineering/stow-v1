// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:stow/bloc/expandable_fab_events.dart';
// import 'package:stow/bloc/expandable_fab_state.dart';
// import 'package:stow/bloc/food_events.dart';
// import 'package:stow/bloc/food_state.dart';
// import 'package:stow/utils/firebase.dart';
// import '../models/food_item.dart';

// class ExpandableFabBloc extends Bloc<ExpandableFabEvents, ExpandableFabState> {
//   ExpandableFabBloc() : super(const ExpandableFabState()) {
//     on<Toggle>(_mapToggleEventToState);
//     on<InitExpandableFab>(_mapInitExpandableFabEventToState);
//   }

//   void _mapToggleEventToState(
//       Toggle event, Emitter<ExpandableFabState> emit) async {
//     emit(state.copyWith(status: ExpandableFabStatus.loading));
//     try {
//       emit(
//         state.copyWith(
//           status: ExpandableFabStatus.success,
//           open: !state.open,
//         ),
//       );
//     } catch (error, stacktrace) {
//       print(stacktrace);
//       emit(state.copyWith(status: ExpandableFabStatus.error));
//     }
//   }

//   void _mapInitExpandableFabEventToState(
//       InitExpandableFab event, Emitter<ExpandableFabState> emit) async {
//     emit(state.copyWith(status: ExpandableFabStatus.loading));
//     try {
//       emit(
//         state.copyWith(status: ExpandableFabStatus.success, open: false),
//       );
//     } catch (error, stacktrace) {
//       print(stacktrace);
//       emit(state.copyWith(status: ExpandableFabStatus.error));
//     }
//   }
// }
