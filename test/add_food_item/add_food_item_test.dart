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
import 'package:stow/models/food_item.dart';
import 'package:stow/models/user.dart';
import 'package:stow/pages/add_food_item/add_food_item.dart';
import 'package:stow/route_generator.dart';
import 'package:stow/utils/authentication.dart';
import 'package:stow/utils/firebase.dart';
import 'package:stow/utils/firebase_storage.dart';
import 'package:stow/utils/stow_colors.dart';
import '../home/mocks.dart';
import 'add_food_item_test.mocks.dart';

@GenerateMocks([StowUser, FirebaseService, Storage, FoodItem])
void main() {
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Add food item page test', (tester) async {
    final AuthenticationService authService = AuthenticationService();
    final user = MockStowUser();
    when((user.uid)).thenReturn('2KWUlFYV6QSN4KyRZqaHNihsc3W2');
    when((user.email)).thenReturn('testuser55@gmail.com');
    final firebaseService = FirebaseService(user.uid);
    final storage = MockStorage();
    const widget = AddFoodItemPage();

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
    final fruitsAndVeggiesFinder = find.textContaining("Fruits and Vegetables");
    final meatAndSeafoodFinder = find.textContaining("Meat and Seafood");
    // final dairyFinder = find.textContaining("Dairy");
    // final bakedGoodsFinder = find.textContaining("BakedGoods");
    // final dryGoodsFinder = find.textContaining("Dry Goods");
    // final bakingFinder = find.textContaining("Baking");
    // final pastaFinder = find.textContaining("Pasta");
    // final spicesAndCondimentsFinder =
    //     find.textContaining("Spices and Condiments");
    // final snacksFinder = find.textContaining("Snacks");
    // final createFinder = find.textContaining("Create Custom Food Item!");
    // final scrollFinder = find.byKey(const Key("MainListView"));

    //expect
    expect(fruitsAndVeggiesFinder, findsOneWidget);
    expect(meatAndSeafoodFinder, findsOneWidget);
    // await tester.scrollUntilVisible(dairyFinder, 500, scrollable: scrollFinder);
    // expect(dairyFinder, findsOneWidget);
    // expect(bakedGoodsFinder, findsOneWidget);
    // expect(dryGoodsFinder, findsOneWidget);
    // expect(bakingFinder, findsOneWidget);
    // expect(pastaFinder, findsOneWidget);
    // expect(spicesAndCondimentsFinder, findsOneWidget);
    // expect(snacksFinder, findsOneWidget);
    // expect(createFinder, findsOneWidget);
  });
}
