import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stow/bloc/auth/auth_events.dart';
import 'package:stow/bloc/auth/auth_state.dart';
<<<<<<< HEAD
import 'package:stow/models/user.dart';
import 'package:stow/utils/authentication.dart';
=======
>>>>>>> d89f78a (grocery lists feature completed)
import 'package:stow/bloc/containers/containers_events.dart';
import 'package:stow/bloc/containers/containers_state.dart';
import 'package:stow/utils/authentication.dart';
import 'package:stow/utils/firebase.dart';
import '../../models/container.dart' as customContainer;
import '../../models/user.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.authService,
  }) : super(const AuthState()) {
    on<CreateAccountEvent>(_mapCreateEventToState);
    on<LoginEvent>(_mapLoginEventToState);
    on<LogoutEvent>(_mapLogoutEventToState);
    on<ResetPasswordEvent>(_mapResetPasswordEventToState);
  }
  final AuthenticationService authService;

  void _mapCreateEventToState(
      CreateAccountEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final newUser = await authService.createUserWithEmailPassword(
          event.props[0] as String,
          event.props[1] as String,
          event.props[2] as String,
          event.props[3] as String);
      emit(
        state.copyWith(status: AuthStatus.success),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapLoginEventToState(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      StowUser? newUser = await authService.signInWithEmailPassword(
          event.props[0] as String, event.props[1] as String);
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('User');
      DocumentSnapshot snapshot = await userCollection.doc(newUser!.uid).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      String firstname = "";
      String lastname = "";
      if (data.containsKey('first_name')) {
        firstname = "${data['first_name']}";
      }
      if (data.containsKey('last_name')) {
        lastname = "${data['last_name']}";
      }
      emit(state.copyWith(
          status: AuthStatus.success,
          user: newUser,
          firstname: firstname,
          lastname: lastname));
    } catch (error, stacktrace) {
      _showMyDialog(
          event.context, "You entered either an invalid username or password");
      print(stacktrace);
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapLogoutEventToState(
      LogoutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await authService.signOut();
      emit(
        AuthState(
            status: AuthStatus.success,
            user: null,
            firstname: null,
            lastname: null),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  Future<void> _showMyDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Not Found!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mapResetPasswordEventToState(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await authService.resetPassword(event.props[0] as String);
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: AuthStatus.error));
    }
  }
}
