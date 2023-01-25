// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/widgets/modal_sheet_button.dart';

// Package imports:
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      onTap: (int selected) => {
        if (selected == 0)
          {
            // Navigator.of(context).pushNamed(
            //   '/home',
            // )
          }
        else if (selected == 1)
          {
            Navigator.of(context).pushNamed(
              '/grocery-list-home',
            )
          }
        // else if (selected == 2)
        //   {
        //     Navigator.of(context).pushNamed(
        //       '/pantry',
        //     )
        //   }
        else if (selected == 2)
          {
            Navigator.of(context).pushNamed(
              '/recipes',
            )
          }
        else if (selected == 3)
          {showBottomButtons(context)}
      },
      letIndexChange: (int selected) => true,
      items: const <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.local_grocery_store, size: 30, color: Colors.white),
        //Icon(Icons.kitchen, size: 30, color: Colors.white),
        Icon(Icons.blender, size: 30, color: Colors.white),
        Icon(Icons.add, size: 15, color: Colors.white)
      ],
      color: Theme.of(context).primaryColor,
      buttonBackgroundColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
    );
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
