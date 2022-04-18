import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';
import 'pages/home/home.dart';
import 'pages/login/login.dart';
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
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stow',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: AuthenticationWrapper(key: key),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userAuth = Provider.of<AuthenticationService>(context);
    return StreamBuilder<StowUser?>(
      stream: userAuth.user,
      builder: (_, AsyncSnapshot<StowUser?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final StowUser? user = snapshot.data;
          return user == null
              ? const LoginPage(title: 'Stow')
              : Home(key: key, user: user);
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
