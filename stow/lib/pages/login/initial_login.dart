import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../utils/authentication.dart';
import 'login.dart';

class InitialLoginPage extends StatelessWidget {
  const InitialLoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 150.0),
          child: ListView(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.asset('assets/stow_text_logo.png'),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text("Let's get cooking",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300)),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 15.0, bottom: 70),
                        child: Container(
                          width: 150,
                          child: Image.asset('assets/small-logo-v2.png'),
                        )),
                    Container(
                      height: 40,
                      width: 372,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 0, 176, 80),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/create-account',
                            arguments: 'Welcome to Stow!',
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 372,
                      margin: EdgeInsets.only(top: 20),
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/login',
                              arguments: 'Stow',
                            );
                          },
                          // style: const ButtonStyle(side: BorderSide(color: Colors.red, width: 2),)
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 176, 80),
                                fontSize: 20),
                          )),
                    ),
                    Container(
                      height: 40,
                      width: 372,
                      margin: EdgeInsets.only(top: 20),
                      child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/reset-password',
                              arguments: 'Stow',
                            );
                          },
                          // style: const ButtonStyle(side: BorderSide(color: Colors.red, width: 2),)
                          child: const Text(
                            "Reset Password",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 176, 80),
                                fontSize: 20),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
