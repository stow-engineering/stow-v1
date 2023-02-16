import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:
import 'package:stow/bloc/auth/auth_events.dart';
import 'package:stow/bloc/auth/auth_state.dart';
import 'package:stow/models/user.dart';
import 'package:stow/utils/authentication.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.authService,
  }) : super(AuthState(emailVerified: false)) {
    on<CreateAccountEvent>(_mapCreateEventToState);
    on<LoginEvent>(_mapLoginEventToState);
    on<LogoutEvent>(_mapLogoutEventToState);
    on<ResetPasswordEvent>(_mapResetPasswordEventToState);
    on<AlreadyLoggedInEvent>(_mapAlreadyLoggedInEventToState);
    on<GetNameEvent>(_mapGetNameEventToState);
    on<UpdateProfilePicEvent>(_mapUpdateProfilePicEventToState);
    on<VerifyEmailEvent>(_mapVerifyEmailEventToState);
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
        state.copyWith(status: AuthStatus.success, emailVerified: false),
      );
    } on FirebaseException catch (error, stacktrace) {
      log(stacktrace.toString());
      if (error.code == 'email-already-in-use') {
        _showMyDialog(event.context, "That Email is already in use.");
      }
      emit(state.copyWith(status: AuthStatus.error));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapLoginEventToState(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    bool appleError = false;
    bool profilePicError = false;
    StowUser? newUser;
    String firstname = "";
    String lastname = "";
    String url = "";
    try {
      if (event.props[3] as bool) {
        try {
          newUser = await authService
              .signInWithApple(scopes: [Scope.email, Scope.fullName]);
        } catch (e) {
          appleError = true;
          _showMyDialog(event.context, "Apple Sign In Failed");
          print(e);
          emit(state.copyWith(status: AuthStatus.error));
        }
      } else {
        try {
          newUser = await authService.signInWithEmailPassword(
              event.props[0] as String, event.props[1] as String);
        } catch (e) {
          print(e);
          emit(state.copyWith(status: AuthStatus.error));
        }
      }
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('User');
      DocumentSnapshot snapshot = await userCollection.doc(newUser!.uid).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey('first_name')) {
        firstname = "${data['first_name']}";
      }
      if (data.containsKey('last_name')) {
        lastname = "${data['last_name']}";
      }
      String profilePicId = "profilepic" + newUser.uid;
      final ref = FirebaseStorage.instance.ref().child(profilePicId);
      url = await ref.getDownloadURL();
      emit(state.copyWith(
          status: AuthStatus.success,
          user: newUser,
          firstname: firstname,
          lastname: lastname,
          profilePicUrl: url,
          emailVerified: true));
    } catch (error, stacktrace) {
      if (error is FirebaseException) {
        if (error.code == "object-not-found") {
          profilePicError = true;
        }
      }
      if (profilePicError) {
        emit(state.copyWith(
            status: AuthStatus.success,
            user: newUser,
            firstname: firstname,
            lastname: lastname,
            profilePicUrl: null,
            emailVerified: true));
      }
      _showMyDialog(
          event.context, "You entered either an invalid username or password");
      log(stacktrace.toString());
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
            lastname: null,
            profilePicUrl: null,
            emailVerified: false),
      );
    } catch (error, stacktrace) {
      log(stacktrace.toString());
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
      emit(state.copyWith(
          status: AuthStatus.success,
          user: null,
          firstname: null,
          lastname: null,
          profilePicUrl: null));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapAlreadyLoggedInEventToState(
      AlreadyLoggedInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      emit(state.copyWith(
          status: AuthStatus.success,
          user: event.stowUser,
          firstname: null,
          lastname: null,
          profilePicUrl: null,
          emailVerified: authService.isEmailVerified()));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapGetNameEventToState(
      GetNameEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    bool profilePicError = false;
    String firstname = "";
    String lastname = "";
    try {
      final CollectionReference userCollection =
          FirebaseFirestore.instance.collection('User');
      DocumentSnapshot snapshot =
          await userCollection.doc(state.user!.uid).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey('first_name')) {
        firstname = "${data['first_name']}";
      }
      if (data.containsKey('last_name')) {
        lastname = "${data['last_name']}";
      }
      String profilePicId = "profilepic" + state.user!.uid;
      final ref = FirebaseStorage.instance.ref().child(profilePicId);
      String url = await ref.getDownloadURL();
      emit(state.copyWith(
          status: AuthStatus.success,
          user: state.user,
          firstname: firstname,
          lastname: lastname,
          profilePicUrl: url));
    } catch (error, stacktrace) {
      if (error is FirebaseException) {
        if (error.code == "object-not-found") {
          profilePicError = true;
        }
      }
      if (profilePicError) {
        emit(state.copyWith(
            status: AuthStatus.success,
            user: state.user,
            firstname: firstname,
            lastname: lastname,
            profilePicUrl: null));
      }
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapUpdateProfilePicEventToState(
      UpdateProfilePicEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      emit(state.copyWith(
          status: AuthStatus.success, profilePicUrl: event.profilePic));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapVerifyEmailEventToState(
      VerifyEmailEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      emit(state.copyWith(
          status: AuthStatus.success, emailVerified: event.isVerified));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }
}
