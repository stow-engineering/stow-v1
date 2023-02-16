// Flutter imports:
// ignore_for_file: avoid_unnecessary_containers

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:apple_sign_in/apple_sign_in_button.dart' as apple;

// Project imports:
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/auth/auth_events.dart';
import 'package:stow/utils/apple_signin_available.dart';
import 'package:stow/widgets/pp_tos.dart';

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
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);
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
                      child: Image.asset('assets/text-logo-transparent.png'),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0,
                                right: 30.0,
                                top: 30.0,
                                bottom: 20.0),
                            child: TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).primaryColor),
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
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Theme.of(context).primaryColor),
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
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).primaryColor),
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
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: Theme.of(context).primaryColor),
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
                    privacyPolicyLinkAndTermsOfService(),
                    Container(
                      height: 40,
                      width: 372,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(7)),
                      child: TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(LoginEvent(
                              email: emailController.text,
                              password: passwordController.text,
                              context: context,
                              apple: false));
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    if (appleSignInAvailable.isAvailable)
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Container(
                          height: 40,
                          width: 372,
                          child: apple.AppleSignInButton(
                            style: apple.ButtonStyle.black,
                            type: apple.ButtonType.signIn,
                            onPressed: () {
                              print('Apple Sign In');
                              context.read<AuthBloc>().add(LoginEvent(
                                  email: '',
                                  password: '',
                                  context: context,
                                  apple: true));
                            },
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/reset-password');
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                            color: Color.fromARGB(255, 169, 176, 183),
                            fontSize: 15,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "New User? ",
                          style: TextStyle(
                            color: Color.fromARGB(255, 169, 176, 183),
                            fontSize: 15,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              '/create-account',
                              arguments: 'Sign Up',
                            );
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 176, 80),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
