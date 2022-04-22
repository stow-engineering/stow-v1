import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:stow/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stow/user_auth.dart';

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
    final authService = Provider.of<AuthService>(context);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 200,
                  height: 150,
                  child: Image.asset('assets/stow-logo.png'),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 15.0, bottom: 0),
                        child: TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Enter Email',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ),
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
                        left: 30.0, right: 30.0, top: 15.0, bottom: 0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        hintText: 'Enter Password',
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //TODO FORGOT PASSWORD SCREEN GOES HERE
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20)),
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
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
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
    );
  }
}
