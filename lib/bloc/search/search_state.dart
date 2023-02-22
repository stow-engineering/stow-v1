// Dart imports:

// Flutter imports:

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:

enum SearchStatus { initial, success, error, loading }

extension SearchStatusX on SearchStatus {
  bool get isInitial => this == SearchStatus.initial;
  bool get isSuccess => this == SearchStatus.success;
  bool get isError => this == SearchStatus.error;
  bool get isLoading => this == SearchStatus.loading;
}

class SearchState extends Equatable {
  const SearchState({this.status = SearchStatus.initial, this.keyword = ""});

  final String keyword;
  final SearchStatus status;

  @override
  List<Object?> get props => [status, keyword];

  SearchState copyWith({
    SearchStatus? status,
    String? keyword,
  }) {
    return SearchState(
        keyword: keyword ?? this.keyword, status: status ?? this.status);
  }
}
