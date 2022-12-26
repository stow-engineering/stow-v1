// Flutter imports:
import 'package:flutter/material.dart';

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
      },
      items: const <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.local_grocery_store, size: 30, color: Colors.white),
        //Icon(Icons.kitchen, size: 30, color: Colors.white),
        Icon(Icons.blender, size: 30, color: Colors.white),
      ],
      color: Theme.of(context).primaryColor,
      buttonBackgroundColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.white,
    );
  }
}
