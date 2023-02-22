import 'package:flutter/material.dart';

@immutable
abstract class SearchEvents {
  const SearchEvents([List props = const []]);
}

class ChangeKeywordEvent extends SearchEvents {
  final String keyword;

  ChangeKeywordEvent(this.keyword) : super([keyword]);

  @override
  String toString() => 'ChangeKeywordEvent';
}

class InitKeywordEvent extends SearchEvents {
  @override
  String toString() => 'InitKeywordEvent';
}
