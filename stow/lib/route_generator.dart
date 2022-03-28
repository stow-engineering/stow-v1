import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:stow/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stow/user_auth.dart';
import 'login.dart';
import 'create_account.dart';
import 'pantry.dart';
import 'provision.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => const LoginPage(title: 'Stow'));
      case '/create_account':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => CreateAccount(
              data: args,
            ),
          );
        }
        return errorRoute();
      case '/pantry':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Pantry(
              data: args,
            ),
          );
        }
        return errorRoute();
      case '/provision':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Provision(
                //data: args,
                ),
          );
        }
        return errorRoute();
      default:
        return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
