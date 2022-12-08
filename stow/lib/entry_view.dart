import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// Stateless entry point - Initial View on Figma
class EntryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
