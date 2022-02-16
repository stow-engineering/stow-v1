import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/home.dart';
import 'package:stow/user.dart';
import 'authentication.dart';
import 'login.dart';
import 'user_auth.dart';
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
        Provider<AuthService>(
          create: (_) => AuthService(),
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
    final userAuth = Provider.of<AuthService>(context);
    return StreamBuilder<StowUser?>(
      stream: userAuth.user,
      builder: (_, AsyncSnapshot<StowUser?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final StowUser? user = snapshot.data;
          return user == null ? const LoginPage(title: 'Stow') : Home(key: key);
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
