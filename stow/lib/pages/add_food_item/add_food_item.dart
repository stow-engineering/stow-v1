import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/food/food_bloc.dart';
import 'package:stow/bloc/food/food_events.dart';
import 'package:stow/fooditem_widgets/horizontal_fooditem_list.dart';
import 'package:stow/models/food_item.dart';

class AddFoodItemPage extends StatefulWidget {
  const AddFoodItemPage({Key? key}) : super(key: key);

  @override
  State<AddFoodItemPage> createState() => _AddFoodItemState();
}

class _AddFoodItemState extends State<AddFoodItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        key: const Key("MainListView"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Text(
                  "Fruits and Vegetables",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            HorizontalFoodItemList(
                category: FoodItemCategory.FruitsAndVegtables),
            const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Text(
                  "Meat and Seafood",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            HorizontalFoodItemList(category: FoodItemCategory.MeatAndSeafood),
            const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Text(
                  "Dairy",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            HorizontalFoodItemList(category: FoodItemCategory.Dairy),
            const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Text(
                  "Baked Goods",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            HorizontalFoodItemList(category: FoodItemCategory.BakedGoods),
            const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Text(
                  "Dry Goods",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            HorizontalFoodItemList(category: FoodItemCategory.DryGoods),
            const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Text(
                  "Baking",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            HorizontalFoodItemList(category: FoodItemCategory.Baking),
            const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Text(
                  "Pasta",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            HorizontalFoodItemList(category: FoodItemCategory.PastaAndSauces),
            const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Text(
                  "Spices and Condiments",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            HorizontalFoodItemList(
                category: FoodItemCategory.SpicesAndCondiments),
            const Padding(
                padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Text(
                  "Snacks",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            HorizontalFoodItemList(category: FoodItemCategory.Snacks),
            const SizedBox(height: 20),
            Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 25.0, bottom: 0),
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
                            borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor)),
                          onPressed: () {
                            final name = nameController.text;
                            DateTime today = DateTime.now();
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: today,
                                    lastDate: DateTime(
                                        today.year + 2, today.month, today.day))
                                .then((date) => {
                                      context.read<FoodItemsBloc>().add(
                                          AddFoodItem(FoodItem(
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
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
