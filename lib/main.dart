// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/auth/auth_events.dart';
import 'package:stow/bloc/auth/auth_state.dart';
import 'package:stow/utils/bloc_provider.dart';
import 'package:stow/utils/firebase.dart';
import 'package:stow/utils/firebase_storage.dart';
import 'package:stow/utils/stow_colors.dart';
import 'models/user.dart';
import 'pages/login/login.dart';
import 'route_generator.dart';
import 'utils/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        stateBloc.authService.user.listen((StowUser? streamStowUser) {
          if (streamStowUser != null && state.user == null) {
            stateBloc.add(AlreadyLoggedInEvent(stowUser: streamStowUser));
          }
        });
        final StowUser? user = state.user;
        return user == null
            ? MaterialApp(
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
