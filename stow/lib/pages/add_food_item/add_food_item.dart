import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/auth/auth_bloc.dart';
import 'package:stow/bloc/food/food_bloc.dart';
import 'package:stow/fooditem_widgets/horizontal_fooditem_list.dart';
import 'package:stow/models/food_item.dart';
import 'package:stow/bloc/food/food_events.dart';
import '../../container_widgets/container_chart.dart';
import '../../container_widgets/container_list.dart';
import '../../container_widgets/user_containers.dart';
import '../../models/add_container_argument.dart';
import '../../models/container_series.dart';
import '../../models/container.dart' as customContainer;
import '../../pages/login/login.dart';
import '../../utils/firebase.dart';

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
      body: ListView(
        children: <Widget>[
          const Padding(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Text(
                "Fruits and Vegetables",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
          HorizontalFoodItemList(category: FoodItemCategory.FruitsAndVegtables),
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
                  Container(
                    height: 40,
                    width: 372,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextButton(
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
                                  context.read<FoodItemsBloc>().add(AddFoodItem(
                                      FoodItem(
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
