import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stow/utils/firebase.dart';

/// Refactor Notes:
///
/// - Include more detailed logs

@immutable
abstract class AuthEvent {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

class CreateAccountEvent extends AuthEvent {
  CreateAccountEvent(
      {required this.email,
      required this.password,
      required this.firstname,
      required this.lastname});

  String email;
  String password;
  String firstname;
  String lastname;

  @override
  List<Object> get props => [email, password, firstname, lastname];

  @override
  String toString() => 'Create Account Event';
}

class ResetPasswordEvent extends AuthEvent {
  ResetPasswordEvent({required this.email});

  String email;

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'Reset Password Event';
}

class LoginEvent extends AuthEvent {
  LoginEvent(
      {required this.email, required this.password, required this.context});

  String email;
  String password;
  BuildContext context;

  @override
  List<Object> get props => [email, password, context];

  @override
  String toString() => 'Login Event';
}

class LogoutEvent extends AuthEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Logout Event';
}
