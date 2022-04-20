import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stow/container_widgets/edit_container.dart';
import 'package:stow/models/add_container_argument.dart';
import 'package:stow/models/edit_container_argument.dart';
import 'package:stow/models/user.dart';
import 'package:stow/pages/account/account.dart';
import 'package:stow/pages/add_container/add_container.dart';
import 'package:stow/pages/barcode/barcode.dart';
import 'package:stow/pages/create_account/create_account.dart';
import 'package:stow/pages/groceries/groceries.dart';
import 'package:stow/pages/home/home.dart';
import 'package:stow/pages/login/login.dart';
import 'package:stow/pages/pantry/pantry.dart';
import 'package:stow/pages/provision/provision.dart';
import 'package:stow/pages/recipes/recipes.dart';
import 'package:stow/pages/register/register.dart';


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
      case '/barcode':
        if (args is StowUser) {
          return MaterialPageRoute(
            builder: (_) => BarcodePage(
              user: args,
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
        if (args is RecipeArguments) {
          return MaterialPageRoute(
            builder: (_) => RecipesPage(
              user: args.user,
              containerData: args.containerData,
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
      case '/account':
        if (args is StowUser) {
          return MaterialPageRoute(
            builder: (_) => AccountPage(
              user: args,
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
