// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:stow/barcode_scanner.dart';
import 'package:stow/container_widgets/edit_container.dart';
import 'package:stow/container_widgets/edit_food_item.dart';
import 'package:stow/models/add_container_argument.dart';
import 'package:stow/models/container.dart' as custom_container;
import 'package:stow/models/food_item.dart';
import 'package:stow/models/recipe.dart';
import 'package:stow/models/user.dart';
import 'package:stow/pages/account/account.dart';
import 'package:stow/pages/add_container/add_container.dart';
import 'package:stow/pages/add_food_item/add_food_item.dart';
import 'package:stow/pages/create_account/create_account.dart';
import 'package:stow/pages/grocery_list/add_grocery_list.dart';
import 'package:stow/pages/grocery_list/edit_grocery_list.dart';
import 'package:stow/pages/grocery_list/grocery_home.dart';
import 'package:stow/pages/login/login.dart';
import 'package:stow/pages/login/reset_password.dart';
import 'package:stow/pages/pantry/pantry.dart';
import 'package:stow/pages/provision/provision.dart';
import 'package:stow/pages/recipes/add_recipe.dart';
import 'package:stow/pages/recipes/recipes.dart';
import 'package:stow/pages/recipes/view_recipe.dart';
import 'package:stow/pages/register/register.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => const LoginPage(title: 'Stow'));
      case '/create-account':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => CreateAccount(
              data: args,
            ),
          );
        }
        return errorRoute();
      case '/reset-password':
        {
          return MaterialPageRoute(
              builder: (_) => const ResetPasswordPage(title: 'Stow'));
        }
      case '/barcode':
        return MaterialPageRoute(builder: (_) => const BarcodeScanner());
      case '/recipes':
        return MaterialPageRoute(
          builder: (_) => const RecipesPage(),
        );
      case '/view_recipe':
        return MaterialPageRoute(
          builder: (_) => ViewRecipePage(recipe: args as Recipe),
        );
      //return errorRoute();
      case '/pantry':
        return MaterialPageRoute(
          builder: (_) => const Pantry(),
        );
      //return errorRoute();
      case '/home':
        //if (args is StowUser) {
        return MaterialPageRoute(
          // builder: (_) => const Home(
          //     //user: args,
          //     ),
          builder: (_) => const Pantry(
              //user: args,
              ),
        );
      //}
      //return errorRoute();
      case '/add-container':
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
      case '/add-food-item':
        return MaterialPageRoute(
          builder: (_) => const AddFoodItemPage(),
        );
      case '/add_recipe':
        return MaterialPageRoute(
          builder: (_) => const AddRecipePage(),
        );
      case '/edit-container':
        if (args is custom_container.Container) {
          return MaterialPageRoute(
            builder: (_) => EditContainer(
              container: args,
            ),
          );
        }
        return errorRoute();
      case '/edit-food-item':
        if (args is FoodItem) {
          return MaterialPageRoute(
            builder: (_) => EditFoodItem(
              foodItem: args,
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
      case '/grocery-list-home':
        return MaterialPageRoute(
          builder: (_) => const GroceryListHome(),
        );
      case '/add-grocery-list':
        return MaterialPageRoute(
          builder: (_) => const AddGroceryList(),
        );
      case '/edit-grocery-list':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => EditGroceryList(
              id: args,
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
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
