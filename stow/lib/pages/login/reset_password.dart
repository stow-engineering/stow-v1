import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/auth/auth_events.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final authBloc = BlocProvider.of<AuthBloc>(context);
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
                          context.read<AuthBloc>().add(ResetPasswordEvent(
                                email: emailController.text,
                              ));
                          final snackBar = SnackBar(
                            content: const Text('Reset Password Email Sent'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            margin: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height - 150,
                                right: 20,
                                left: 20),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
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
