// Dart imports:
import 'dart:developer';

// Package imports:
import 'package:bloc/bloc.dart';

// Project imports:
import 'package:stow/bloc/search/search_events.dart';
import 'package:stow/bloc/search/search_state.dart';

class SearchBloc extends Bloc<SearchEvents, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<ChangeKeywordEvent>(_mapChangeKeywordEventToState);
    on<InitKeywordEvent>(_mapInitKeywordEventToState);
  }

  void _mapChangeKeywordEventToState(
      ChangeKeywordEvent event, Emitter<SearchState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      emit(
          state.copyWith(status: SearchStatus.success, keyword: event.keyword));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: SearchStatus.error));
    }
  }

  void _mapInitKeywordEventToState(
      InitKeywordEvent event, Emitter<SearchState> emit) async {
    emit(state.copyWith(status: SearchStatus.loading));
    try {
      emit(state.copyWith(status: SearchStatus.success, keyword: ""));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: SearchStatus.error));
    }
  }
}
