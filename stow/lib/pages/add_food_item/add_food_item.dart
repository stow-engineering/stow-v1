import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:stow/bloc/auth_bloc.dart';
import 'package:stow/bloc/food_bloc.dart';
import 'package:stow/models/food_item.dart';
import 'package:stow/bloc/food_events.dart';
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
            padding: EdgeInsets.only(
                left: 30.0, right: 30.0, top: 25.0, bottom: 25.0),
            child: Center(
              child: Text(
                "Add a Food Item",
                style: TextStyle(color: Colors.black, fontSize: 35),
              ),
            ),
          ),
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
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () {
                        final name = nameController.text;
                        final food_item =
                            FoodItem(name: name, value: 0, barcode: "");
                        context
                            .read<FoodItemsBloc>()
                            .add(AddFoodItem(food_item));
                        // var food_uid = service.updateFoodItemData(name);
                        // service.updateContainers(food_uid.toString());
                      },
                      child: const Text(
                        'Create Food Item!',
                        style: TextStyle(color: Colors.white, fontSize: 25),
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
