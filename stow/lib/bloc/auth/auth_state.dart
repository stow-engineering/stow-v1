import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stow/bloc/containers_state.dart';
import 'package:stow/utils/firebase.dart';
import '../models/container.dart' as customContainer;
import '../models/user.dart';
import 'package:equatable/equatable.dart';

// abstract class AuthState {
//   const AuthState();

//   @override
//   List<Object?> get props => [];
// }

// class AuthenticationInitial extends AuthState {
//   @override
//   List<Object?> get props => [];
// }

// class AuthenticationSuccess extends AuthState {
//   final StowUser user;
//   const AuthenticationSuccess({required this.user});

//   @override
//   List<Object?> get props => [user];
// }

// class AuthenticationFailure extends AuthState {
//   @override
//   List<Object?> get props => [];
// }

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
      StowUser? user,
      String? firstname,
      String? lastname})
      : user = user,
        firstname = firstname,
        lastname = lastname;

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
