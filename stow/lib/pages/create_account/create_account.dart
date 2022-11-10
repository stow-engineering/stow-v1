import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/auth/auth_events.dart';
import 'package:stow/utils/bloc_provider.dart';

import '../../utils/authentication.dart';

class CreateAccount extends StatelessWidget {
  CreateAccount({
    Key? key,
    required this.data,
  }) : super(key: key);

  final String data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var boxColor1 = Colors.grey;
    var boxColor2 = Colors.grey;
    var boxColor3 = Colors.grey;
    final passwordController = TextEditingController();
    final emailController = TextEditingController();
    final confirmController = TextEditingController();
    final firstController = TextEditingController();
    final lastController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: data,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
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
                        left: 30.0, right: 30.0, top: 25.0, bottom: 0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 5.0, bottom: 0),
                    child: RichText(
                      text: const TextSpan(
                        text:
                            'Password must be more than 8 characters, include at least one number, and symbol',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 25.0),
                    child: TextFormField(
                      controller: confirmController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Confirm Password',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please re-enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 25.0),
                    child: TextFormField(
                      controller: firstController,
                      decoration: const InputDecoration(
                        hintText: 'First Name',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 25.0),
                    child: TextFormField(
                      controller: lastController,
                      decoration: const InputDecoration(
                        hintText: 'Last Name',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a last name';
                        }
                        return null;
                      },
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
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                            .hasMatch(emailController.text);
                        var numbers = [
                          '0',
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9'
                        ];
                        bool hasNumber = false;
                        for (var i = 0; i < numbers.length; i++) {
                          if (passwordController.text.contains(numbers[i])) {
                            hasNumber = true;
                          }
                        }
                        bool hasSymbol = false;
                        final symbols = [
                          '!',
                          '@',
                          '#',
                          '%',
                          '^',
                          '&',
                          '*',
                          '+'
                        ];
                        for (var i = 0; i < symbols.length; i++) {
                          if (passwordController.text.contains(symbols[i])) {
                            hasSymbol = true;
                          }
                        }
                        bool requiredLength = false;
                        if (passwordController.text.length > 7) {
                          requiredLength = true;
                        }
                        bool passwordsMatch = false;
                        if (passwordController.text == confirmController.text) {
                          passwordsMatch = true;
                        }
                        if (requiredLength &&
                            hasNumber &&
                            hasSymbol &&
                            passwordsMatch &&
                            emailValid) {
                          context.read<AuthBloc>().add(CreateAccountEvent(
                              email: emailController.text,
                              password: passwordController.text,
                              firstname: firstController.text,
                              lastname: lastController.text));
                        } else {
                          String errorMessage = "";
                          if (!requiredLength) {
                            errorMessage =
                                "Password must be eight characters or more";
                          }
                          if (!hasNumber) {
                            errorMessage = "Password must contain a number";
                          }
                          if (!hasSymbol) {
                            errorMessage =
                                "Password must contain a symbol (!,@,#,%,^,&,*,+)";
                          }
                          if (!passwordsMatch) {
                            errorMessage = "Passwords don't match";
                          }
                          if (!emailValid) {
                            errorMessage = "Please provide a valid email";
                          }
                          _showMyDialog(context, errorMessage);
                        }
                      },
                      child: const Text(
                        'Sign Me Up!',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
