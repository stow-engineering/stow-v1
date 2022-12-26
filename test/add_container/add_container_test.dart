// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/containers/containers_bloc.dart';
import 'package:stow/bloc/food/food_bloc.dart';
import 'package:stow/bloc/grocery_list/grocery_list_bloc.dart';
import 'package:stow/bloc/recipes_bloc.dart';
import 'package:stow/models/add_container_argument.dart';
import 'package:stow/models/user.dart';
import 'package:stow/pages/account/account.dart';
import 'package:stow/pages/add_container/add_container.dart';
import 'package:stow/pages/pantry/pantry.dart';
import 'package:stow/route_generator.dart';
import 'package:stow/utils/authentication.dart';
import 'package:stow/utils/firebase.dart';
import 'package:stow/utils/firebase_storage.dart';
import 'package:stow/utils/stow_colors.dart';
import '../home/mocks.dart';
import 'add_container_test.mocks.dart';

@GenerateMocks([StowUser, FirebaseService, Storage])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Add container page test', (tester) async {
    final AuthenticationService authService = AuthenticationService();
    final user = MockStowUser();
    when((user.uid)).thenReturn('2KWUlFYV6QSN4KyRZqaHNihsc3W2');
    when((user.email)).thenReturn('testuser55@gmail.com');
    final firebaseService = FirebaseService(user.uid);
    final AddContainerArg arg = AddContainerArg(user, '34:94:54:39:15:62');
    final storage = MockStorage();
    final widget = AddContainer(arg: arg);

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
    final textButtonFinder = find.byType(TextButton);
    final registerButtonFinder = find.textContaining("Register Your Container");
    final createButtonFinder = find.textContaining("Create my container!");
    final dropdownFinder = find.byKey(const Key("DropdownButtonForm"));
    final textFormFinder = find.byKey(const Key('NameFormField'));

    //expect
    expect(textButtonFinder, findsOneWidget);
    expect(registerButtonFinder, findsOneWidget);
    expect(createButtonFinder, findsOneWidget);
    expect(dropdownFinder, findsOneWidget);
    expect(textFormFinder, findsOneWidget);
  });
}
