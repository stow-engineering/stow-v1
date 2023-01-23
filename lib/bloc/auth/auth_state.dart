// Dart imports:

// Flutter imports:

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:stow/models/user.dart';

enum AuthStatus { initial, success, error, loading }

extension AuthStatusX on AuthStatus {
  bool get isInitial => this == AuthStatus.initial;
  bool get isSuccess => this == AuthStatus.success;
  bool get isError => this == AuthStatus.error;
  bool get isLoading => this == AuthStatus.loading;
}

class AuthState extends Equatable {
  const AuthState(
      {this.status = AuthStatus.initial,
      this.user,
      this.firstname,
      this.lastname});

  final StowUser? user;
  final String? firstname;
  final String? lastname;
  final AuthStatus status;

  @override
  List<Object?> get props => [status, user, firstname, lastname];

  AuthState copyWith(
      {AuthStatus? status,
      StowUser? user,
      String? firstname,
      String? lastname}) {
    return AuthState(
        user: user ?? this.user,
        status: status ?? this.status,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname);
  }
}
