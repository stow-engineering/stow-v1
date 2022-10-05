import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stow/bloc/containers_state.dart';
import 'package:stow/utils/firebase.dart';
import '../models/container.dart' as customContainer;
import '../models/user.dart';

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

class LoginEvent extends AuthEvent {
  LoginEvent({required this.email, required this.password});

  String email;
  String password;

  @override
  List<Object> get props => [email, password];

  @override
  String toString() => 'Login Event';
}

class LogoutEvent extends AuthEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Logout Event';
}
