import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:stow/add_container.dart';
import 'package:stow/add_container_argument.dart';
import 'package:stow/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stow/user.dart';
import 'package:stow/user_auth.dart';
import 'groceries.dart';
import 'home.dart';
import 'login.dart';
import 'create_account.dart';
import 'pantry.dart';
import 'provision.dart';
import 'recipes.dart';
import 'register.dart';

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
        if (args is StowUser) {
          return MaterialPageRoute(
            builder: (_) => Pantry(
              user: args,
            ),
          );
        }
        return errorRoute();
      case '/home':
        if (args is StowUser) {
          return MaterialPageRoute(
            builder: (_) => Home(
              user: args,
            ),
          );
        }
        return errorRoute();
      case '/groceries':
        if (args is StowUser) {
          return MaterialPageRoute(
            builder: (_) => Groceries(
              user: args,
            ),
          );
        }
        return errorRoute();
      case '/recipes':
        if (args is StowUser) {
          return MaterialPageRoute(
            builder: (_) => RecipesPage(
              user: args,
            ),
          );
        }
        return errorRoute();
      case '/add_container':
        if (args is AddContainerArg) {
          return MaterialPageRoute(
            builder: (_) => AddContainer(
              arg: args,
            ),
          );
        }
        return errorRoute();
      case '/provision':
        if (args is StowUser) {
          return MaterialPageRoute(
            builder: (_) => Provision(
              user: args,
            ),
          );
        }
        return errorRoute();
      case '/register':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => Register(
              mac: args,
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
