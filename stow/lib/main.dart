import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/auth_bloc.dart';
import 'package:stow/bloc/auth_state.dart';
import 'package:stow/utils/bloc_provider.dart';
import 'package:stow/utils/firebase.dart';
import 'package:stow/utils/firebase_storage.dart';

import 'models/user.dart';
import 'pages/home/home.dart';
import 'pages/login/login.dart';
import 'pages/login/initial_login.dart';
import 'utils/authentication.dart';
import 'route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return MultiProvider(
    //   providers: [
    //     Provider<AuthenticationService>(
    //       create: (_) => AuthenticationService(),
    //     ),
    //   ],
    //   child: AuthenticationWrapper(key: key),
    // );
    AuthenticationService authService = AuthenticationService();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authService: authService),
        )
      ],
      child: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stateBloc = BlocProvider.of<AuthBloc>(context);
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: stateBloc,
      builder: (context, state) {
        final StowUser? user = state.user;
        return user == null
            ? MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Stow',
                theme: ThemeData(
                  primarySwatch: Colors.green,
                ),
                initialRoute: '/',
                onGenerateRoute: RouteGenerator.generateRoute,
                home: const Scaffold(
                  body: Center(
                    child: LoginPage(title: 'Stow'),
                  ),
                ),
              )
            : MultiProvider(
                providers: [
                  Provider(create: (_) => FirebaseService(user.uid)),
                  Provider(
                    create: (_) => Storage(),
                  )
                ],
                child: BlocProv(key: key),
              );
      },
    );
  }
}
