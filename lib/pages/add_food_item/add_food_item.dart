// Flutter imports:
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:stow/bloc/food/food_bloc.dart';
import 'package:stow/bloc/food/food_events.dart';
import 'package:stow/bloc/search/search_bloc.dart';
import 'package:stow/bloc/search/search_events.dart';
import 'package:stow/bloc/search/search_state.dart';
import 'package:stow/fooditem_widgets/horizontal_fooditem_list.dart';
import 'package:stow/models/food_item.dart';

class AddFoodItemPage extends StatefulWidget {
  const AddFoodItemPage({Key? key}) : super(key: key);

  @override
  State<AddFoodItemPage> createState() => _AddFoodItemState();
}

final searchController = TextEditingController();
final searchBloc = SearchBloc();

class _AddFoodItemState extends State<AddFoodItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    searchBloc.add(InitKeywordEvent());
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 5, bottom: 5),
          child: AnimSearchBar(
              helpText: "Search Food Item",
              width: MediaQuery.of(context).size.width - 10,
              textController: searchController,
              onSubmitted: (String submission) {
                searchBloc.add(ChangeKeywordEvent(submission));
              },
              onSuffixTap: () {
                searchBloc.add(InitKeywordEvent());
              }),
        )
      ]),
      body: SafeArea(
        child: SingleChildScrollView(
          key: const Key("MainListView"),
          child: BlocBuilder<SearchBloc, SearchState>(
              bloc: searchBloc,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    HorizontalFoodItemList(
                        keyWord: searchBloc.state.keyword,
                        category: FoodItemCategory.FruitsAndVegtables),
                    HorizontalFoodItemList(
                        keyWord: searchBloc.state.keyword,
                        category: FoodItemCategory.MeatAndSeafood),
                    HorizontalFoodItemList(
                        keyWord: searchBloc.state.keyword,
                        category: FoodItemCategory.Dairy),
                    HorizontalFoodItemList(
                        keyWord: searchBloc.state.keyword,
                        category: FoodItemCategory.BakedGoods),
                    HorizontalFoodItemList(
                        keyWord: searchBloc.state.keyword,
                        category: FoodItemCategory.DryGoods),
                    HorizontalFoodItemList(
                        keyWord: searchBloc.state.keyword,
                        category: FoodItemCategory.Baking),
                    HorizontalFoodItemList(
                        keyWord: searchBloc.state.keyword,
                        category: FoodItemCategory.PastaAndSauces),
                    HorizontalFoodItemList(
                        keyWord: searchBloc.state.keyword,
                        category: FoodItemCategory.SpicesAndCondiments),
                    HorizontalFoodItemList(
                        keyWord: searchBloc.state.keyword,
                        category: FoodItemCategory.Snacks),
                    const SizedBox(height: 20),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 50),
                        child: Card(
                          borderOnForeground: true,
                          elevation: 10,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30.0,
                                      right: 30.0,
                                      top: 25.0,
                                      bottom: 0),
                                  child: TextFormField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      hintText: 'Food Item Name',
                                    ),
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 75),
                                  child: Container(
                                    height: 40,
                                    width: 372,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Theme.of(context)
                                                      .primaryColor)),
                                      onPressed: () {
                                        final name = nameController.text;
                                        DateTime today = DateTime.now();
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: today,
                                                lastDate: DateTime(
                                                    today.year + 2,
                                                    today.month,
                                                    today.day))
                                            .then((date) => {
                                                  context
                                                      .read<FoodItemsBloc>()
                                                      .add(AddFoodItem(FoodItem(
                                                          name: name,
                                                          value: 0,
                                                          barcode: "",
                                                          expDate: date)))
                                                });
                                        // var food_uid = service.updateFoodItemData(name);
                                        // service.updateContainers(food_uid.toString());
                                      },
                                      child: const Text(
                                        'Create Custom Food Item!',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
