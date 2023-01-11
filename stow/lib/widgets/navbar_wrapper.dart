import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/pages/grocery_list/grocery_home.dart';
import 'package:stow/pages/pantry/pantry.dart';
import 'package:stow/pages/recipes/recipes.dart';
import 'package:stow/widgets/modal_sheet_button.dart';

class NavBarWrapper extends StatefulWidget {
  @override
  _NavBarWrapperState createState() => _NavBarWrapperState();
}

class _NavBarWrapperState extends State<NavBarWrapper> {
  List<dynamic> _page = [
    Pantry(),
    GroceryListHome(),
    RecipesPage(),
  ];
  int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          index: _activePage,
          height: 60.0,
          items: <Widget>[
            Icon(
              Icons.home,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.local_grocery_store,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.blender,
              size: 30,
              color: Colors.white,
            ),
            // Icon(
            //   Icons.add,
            //   size: 30,
            //   color: Colors.white,
            // )
          ],
          color: Theme.of(context).primaryColor,
          buttonBackgroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            if (index < 3) {
              setState(() {
                _activePage = index;
              });
            } else {
              //showBottomButtons(context);
            }
          },
          letIndexChange: (index) => true,
        ),
        body: Container(
          color: Colors.greenAccent,
          child: Center(
            child: _page[_activePage],
          ),
        ));
  }
}
