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
  AuthState(
      {this.status = AuthStatus.initial,
      this.user,
      this.firstname,
      this.lastname,
      this.profilePicUrl,
      required this.emailVerified});

  final StowUser? user;
  final String? firstname;
  final String? lastname;
  final String? profilePicUrl;
  final AuthStatus status;
  bool emailVerified;

  @override
  List<Object?> get props =>
      [status, user, firstname, lastname, profilePicUrl, emailVerified];

  AuthState copyWith(
      {AuthStatus? status,
      StowUser? user,
      String? firstname,
      String? lastname,
      String? profilePicUrl,
      bool? emailVerified}) {
    return AuthState(
        user: user ?? this.user,
        status: status ?? this.status,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        profilePicUrl: profilePicUrl ?? this.profilePicUrl,
        emailVerified: emailVerified ?? this.emailVerified);
  }
}
