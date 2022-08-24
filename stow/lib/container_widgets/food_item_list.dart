import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/food_bloc.dart';
import 'package:stow/bloc/food_state.dart';
import 'package:stow/models/food_item.dart';

import '../bloc/containers_bloc.dart';
import '../bloc/containers_state.dart';

class FoodItemList extends StatefulWidget {
  const FoodItemList({Key? key}) : super(key: key);
  @override
  _FoodItemListState createState() => _FoodItemListState();
}

class _FoodItemListState extends State<FoodItemList> {
  @override
  Widget build(BuildContext context) {
    final stateBloc = BlocProvider.of<FoodItemsBloc>(context);

    return BlocBuilder<FoodItemsBloc, FoodItemsState>(
        bloc: stateBloc,
        builder: (context, state) {
          return state.foodItems == null
              ? Container()
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.foodItems.length,
                  itemBuilder: (context, index) {
                    return FoodItemDisplay(state.foodItems[index]);
                  },
                );
        });
  }
}

class FoodItemDisplay extends StatelessWidget {
  final FoodItem foodItem;

  FoodItemDisplay(this.foodItem);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
            margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: ListTile(
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/edit_food_item',
                    arguments: foodItem,
                  );
                },
              ),
              title: Text(foodItem.name.toString(),
                  style: const TextStyle(
                      fontWeight:
                          FontWeight.bold)), //Text(foodItem.value.toString())),
            )));
  }
}
