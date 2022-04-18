import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:stow/pages/add_container/add_container.dart';
import 'package:stow/models/add_container_argument.dart';

import 'container_widgets/edit_container.dart';
import 'models/user.dart';
import 'models/edit_container_argument.dart';
import 'pages/create_account/create_account.dart';
import 'pages/groceries/groceries.dart';
import 'pages/home/home.dart';
import 'pages/login/login.dart';
import 'pages/pantry/pantry.dart';
import 'pages/provision/provision.dart';
import 'pages/recipes/recipes.dart';
import 'pages/register/register.dart';

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
      case '/edit_container':
        if (args is EditContainerArgument) {
          return MaterialPageRoute(
            builder: (_) => EditContainer(
              arg: args,
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
