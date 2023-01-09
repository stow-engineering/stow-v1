// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/pages/grocery_list/grocery_home.dart';
import 'package:stow/pages/pantry/pantry.dart';
import 'package:stow/pages/recipes/recipes.dart';
import 'package:stow/widgets/modal_sheet_button.dart';

class NavBarWrapper extends StatefulWidget {
  const NavBarWrapper({super.key});

  @override
  _NavBarWrapperState createState() => _NavBarWrapperState();
}

class _NavBarWrapperState extends State<NavBarWrapper> {
  final List<dynamic> _page = [
    const Pantry(),
    const GroceryListHome(),
    const RecipesPage(),
  ];
  int _activePage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          index: _activePage,
          height: 60.0,
          items: const <Widget>[
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
            Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            )
          ],
          color: Theme.of(context).primaryColor,
          buttonBackgroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 600),
          onTap: (index) {
            if (index < 3) {
              setState(() {
                _activePage = index;
              });
            } else {
              showBottomButtons(context);
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

  Future showBottomButtons(context) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 175,
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ModalSheetButton(
                      text: 'Add Food Item', route: '/add-food-item'),
                  Container(
                    color: Colors.black,
                    height: 1,
                  ),
                  ModalSheetButton(
                      text: 'Add Container',
                      route: '/provision',
                      args: BlocProvider.of<AuthBloc>(context).state.user),
                  Container(height: 20),
                ],
              ),
            ),
          );
        });
  }
}
