// Flutter imports:
import 'package:flutter/material.dart';

// Stateless entry point - Initial View on Figma
class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ignore: sized_box_for_whitespace
            Container(
              width: 200,
              height: 150,
              child: Image.asset('assets/text-logo-transparent.png'),
            ),
            const SizedBox(
              height: 300,
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/',
                  arguments: 'Welcome to Stow!',
                );
              },
              child: const Text(
                'New User? Create Account',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
