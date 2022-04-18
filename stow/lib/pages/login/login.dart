import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../utils/authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthenticationService>(context);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text("Let's get cooking 🍽",
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0,
                                right: 30.0,
                                top: 30.0,
                                bottom: 20.0),
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'han@solo.rebellion',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 211, 220, 230)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: Color.fromARGB(255, 0, 176, 80)),
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0,
                                right: 30.0,
                                top: 15.0,
                                bottom: 40.0),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintText: 'whoshotfirst',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 211, 220, 230)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1,
                                        color: Color.fromARGB(255, 0, 176, 80)),
                                    borderRadius: BorderRadius.circular(15),
                                  )),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 372,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextButton(
                        onPressed: () {
                          authService.signInWithEmailPassword(
                              emailController.text, passwordController.text);
                          /*
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => HomePage()));
                        */
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        //TODO FORGOT PASSWORD SCREEN GOES HERE
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                            color: Color.fromARGB(255, 169, 176, 183),
                            fontSize: 15,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    const SizedBox(
                      height: 300,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          '/create_account',
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
            ],
          ),
        ));
  }
}
