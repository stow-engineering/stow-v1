import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/containers/containers_bloc.dart';
import 'package:stow/bloc/food/food_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_bloc.dart';
import 'package:stow/bloc/recipes_bloc.dart';
import 'package:stow/models/user.dart';
import 'package:stow/pages/pantry/pantry.dart';
import 'package:stow/route_generator.dart';
import 'package:stow/utils/authentication.dart';
import 'package:stow/utils/firebase.dart';
import 'package:stow/utils/firebase_storage.dart';
import 'package:stow/utils/stow_colors.dart';
import '../home/mocks.dart';
import 'pantry_test.mocks.dart';

@GenerateMocks([StowUser, FirebaseService, Storage])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Pantry page test', (tester) async {
    final AuthenticationService authService = AuthenticationService();
    final widget = Pantry();
    final user = MockStowUser();
    when((user.uid)).thenReturn('2KWUlFYV6QSN4KyRZqaHNihsc3W2');
    final firebaseService = FirebaseService(user.uid);
    final storage = MockStorage();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(authService: authService),
          ),
        ],
        child: MultiProvider(
          providers: [
            Provider(create: (_) => firebaseService),
            Provider(
              create: (_) => storage,
            )
          ],
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ContainersBloc>(
                  create: (_) => ContainersBloc(service: firebaseService)),
              BlocProvider<FoodItemsBloc>(
                  create: (_) => FoodItemsBloc(service: firebaseService)),
              BlocProvider<RecipesBloc>(
                  create: (_) => RecipesBloc(service: firebaseService)),
              BlocProvider<GroceryListBloc>(
                create: (_) => GroceryListBloc(service: firebaseService),
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Stow',
              theme: ThemeData(
                primaryColor: const Color.fromARGB(255, 6, 70, 53),
                primarySwatch:
                    createMaterialColor(const Color.fromRGBO(6, 70, 53, 1)),
              ),
              home: widget,
              initialRoute: '/',
              onGenerateRoute: RouteGenerator.generateRoute,
            ),
          ),
        ),
      ),
    );

    //create finders
    final expandableFabFinder = find.byKey(const Key("ExpandableFab"));
    final containerChartFinder = find.byKey(const Key("ContainerChart"));

    //expect
    expect(expandableFabFinder, findsOneWidget);
    expect(containerChartFinder, findsOneWidget);
  });
}
