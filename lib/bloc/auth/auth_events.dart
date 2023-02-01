// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:stow/models/user.dart';

// Package imports:

/// Refactor Notes:
///
/// - Include more detailed logs

@immutable
abstract class AuthEvent {
  const AuthEvent();

  List<Object> get props => [];
}

class CreateAccountEvent extends AuthEvent {
  const CreateAccountEvent(
      {required this.email,
      required this.password,
      required this.firstname,
      required this.lastname});

  final String email;
  final String password;
  final String firstname;
  final String lastname;

  @override
  List<Object> get props => [email, password, firstname, lastname];

  @override
  String toString() => 'Create Account Event';
}

class ResetPasswordEvent extends AuthEvent {
  const ResetPasswordEvent({required this.email});

  final String email;

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'Reset Password Event';
}

class LoginEvent extends AuthEvent {
  LoginEvent(
      {required this.email,
      required this.password,
      required this.context,
      required this.apple});

  String email;
  String password;
  BuildContext context;
  bool apple;

  @override
  List<Object> get props => [email, password, context, apple];

  @override
  String toString() => 'Login Event';
}

class LogoutEvent extends AuthEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Logout Event';
}

class AlreadyLoggedInEvent extends AuthEvent {
  const AlreadyLoggedInEvent({required this.stowUser});

  final StowUser stowUser;

  @override
  List<Object> get props => [stowUser];

  @override
  String toString() => 'Already Logged In Event';
}

class GetNameEvent extends AuthEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Get Name Event';
}

class UpdateProfilePicEvent extends AuthEvent {
  const UpdateProfilePicEvent({required this.profilePic});

  final String profilePic;

  @override
  List<Object> get props => [profilePic];

  @override
  String toString() => 'Update Profile Pic Event';
}
