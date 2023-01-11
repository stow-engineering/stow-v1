// Flutter imports:
// ignore_for_file: sized_box_for_whitespace

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:stow/models/user.dart';
import 'package:stow/pages/home/get_name.dart';
import 'package:stow/utils/firebase.dart';

// Package imports:

class AccountPage extends StatefulWidget {
  final StowUser user;
  const AccountPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final FirebaseService service = FirebaseService(widget.user.uid);
    final GetName fullName = GetName(widget.user.uid, true);
    // final authService = BlocProvider.of<AuthBloc>(context);
    final GlobalKey<ScaffoldState> _key = GlobalKey();

    final emailController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();

    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Container(
                width: 500,
                child: const Icon(Icons.person_rounded,
                    size: 200, color: Colors.black),
              )),
          Padding(
            padding:
                const EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                fullName,
              ],
            ),
          ),
          Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 30.0, bottom: 20.0),
                    child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: widget.user.email,
                            hintText: 'Update Email',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 211, 220, 230)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 0, 176, 80)),
                              borderRadius: BorderRadius.circular(15),
                            ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 10.0, bottom: 20.0),
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                          labelText: 'First Name',
                          hintText: 'Han',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 211, 220, 230)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 0, 176, 80)),
                            borderRadius: BorderRadius.circular(15),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 10.0, bottom: 30.0),
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                          labelText: 'Last Name',
                          hintText: 'Solo',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 211, 220, 230)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 0, 176, 80)),
                            borderRadius: BorderRadius.circular(15),
                          )),
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
                        service.updateUserDataNoContainers(emailController.text,
                            firstNameController.text, lastNameController.text);
                      },
                      child: const Text(
                        'Update Info',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
