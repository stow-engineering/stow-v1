import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/containers_bloc.dart';
import 'package:stow/models/user.dart';
import 'package:stow/pages/home/home.dart';
import 'package:stow/route_generator.dart';
import 'package:stow/bloc/containers_state.dart';
import 'package:stow/utils/firebase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:bloc/bloc.dart';

class BlocProv extends StatelessWidget {
  const BlocProv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseService service = Provider.of<FirebaseService>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<ContainersBloc>(
            create: (_) => ContainersBloc(service: service))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stow',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Home(key: key),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
