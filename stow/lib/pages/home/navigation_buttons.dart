import 'package:flutter/material.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton({Key? key, required this.route, required this.text})
      : super(key: key);

  final String route;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 220, top: 30, bottom: 0),
      child: TextButton.icon(
        onPressed: () => {
          Navigator.of(context).pushNamed(
            route,
          )
        },
        icon: const Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey),
        label: Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );
  }
}
