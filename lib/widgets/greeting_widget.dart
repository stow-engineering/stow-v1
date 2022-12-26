// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/auth/auth_state.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 10, top: 10, bottom: 15),
      child: SizedBox(
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Hi there, ",
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                    bloc: BlocProvider.of<AuthBloc>(context),
                    builder: (context, state) {
                      String fullname = state.firstname ?? '';
                      return Text(fullname,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold));
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
