import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/auth/auth_events.dart';
import 'package:stow/bloc/auth/auth_state.dart';
import 'package:stow/pages/verify_email/verify_email.dart';
import 'package:stow/route_generator.dart';
import 'package:stow/utils/authentication.dart';
import 'package:stow/utils/bloc_provider.dart';
import 'package:stow/utils/stow_colors.dart';

class VerifyWrapper extends StatefulWidget {
  VerifyWrapper({Key? key}) : super(key: key);

  @override
  State<VerifyWrapper> createState() => _VerifyWrapperState();
}

class _VerifyWrapperState extends State<VerifyWrapper> {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(VerifyEmailEvent(
        isVerified: authBloc.authService.isEmailVerified() ?? false));
    if (authBloc.authService.isEmailVerified() != null) {
      return authBloc.state.emailVerified ||
              authBloc.state.status == AuthStatus.initial
          ? BlocProv()
          : MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Stow',
              theme: ThemeData(
                primaryColor: const Color.fromARGB(255, 6, 70, 53),
                primarySwatch:
                    createMaterialColor(const Color.fromRGBO(6, 70, 53, 1)),
              ),
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.generateRoute,
              home: const Scaffold(
                body: Center(
                  child: EmailVerificationScreen(),
                ),
              ),
            );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stow',
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 6, 70, 53),
          primarySwatch:
              createMaterialColor(const Color.fromRGBO(6, 70, 53, 1)),
        ),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
        home: const Scaffold(
          body: Center(
            child: EmailVerificationScreen(),
          ),
        ),
      );
    }
  }
}
