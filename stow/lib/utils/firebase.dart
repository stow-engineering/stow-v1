import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stow/bloc/food/food_events.dart';
import 'package:stow/models/food_item.dart';
import 'package:stow/models/grocery_lists.dart';
import 'package:stow/models/recipe.dart';

import '../models/container.dart' as customContainer;

class FirebaseService {
  final String uid;
  FirebaseService(this.uid);

  //Collection reference
  final CollectionReference containerCollection =
      FirebaseFirestore.instance.collection('Containers');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');
  final CollectionReference foodItemCollection =
      FirebaseFirestore.instance.collection('FoodItems');
  final CollectionReference recipeCollection =
      FirebaseFirestore.instance.collection('Recipes');
  final CollectionReference groceryListCollection =
      FirebaseFirestore.instance.collection("GroceryLists");

  //Creates new user in database
  Future updateUserData(String email, String firstName, String lastName) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'containers': []
    });
  }

  // Updates a users info
  Future updateUserDataNoContainers(
      String email, String firstName, String lastName) async {
    return await userCollection
        .doc(uid)
        .set({'email': email, 'first_name': firstName, 'last_name': lastName});
  }

  Future updateContainers(String mac) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userCollection
        .doc(uid)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    var data = snapshot.data();
    final myList = List<String>.from(data!['containers']);
    if (!myList.contains(mac)) {
      myList.add(mac);
      return await userCollection.doc(uid).update({'containers': myList});
    }

    return await userCollection.doc(uid).update({
      'containers': [mac],
    });
  }

  Future updateContainerData(
      String name, String size, String mac, int? value, bool? full) async {
    return await containerCollection.doc(mac).set({
      'barcode': null,
      'full': full ?? false,
      'mac': mac,
      'value': value ?? 0,
      'name': name,
      'size': size
    });
  }

  Future updateContainerNameAndSize(
      String name, String size, String mac) async {
    return await containerCollection
        .doc(mac)
        .update({'name': name, 'size': size});
  }

  //updates container with name
  Future updateContainerName(String mac, String name) async {
    return await containerCollection.doc(mac).update({
      'name': name,
    });
  }

  Future deleteContainer(String mac) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userCollection
        .doc(uid)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('containers')) {
      final myList = List<String>.from(data['containers']);
      myList.remove(mac);
      return await userCollection.doc(uid).update({'containers': myList});
    }

    return await userCollection.doc(uid).update({
      'containers': [mac],
    });
  }

  Future deleteRecipe(String recipeId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userCollection
        .doc(uid)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('recipes')) {
      final myList = List<String>.from(data['recipes']);
      myList.remove(recipeId);
      recipeCollection.doc(recipeId).delete();
      return await userCollection.doc(uid).update({'recipes': myList});
    }

    recipeCollection.doc(recipeId).delete();
    return await userCollection.doc(uid).update({
      'recipes': [recipeId],
    });
  }

  Future updateRecipeData(
      String recipeId,
      String name,
      List<String> instructions,
      String userId,
      List<String> ingredients,
      int cookTimeMin,
      int prepTimeMin) async {
    //If update recipe is called without an ID probably should just throw error
    if (recipeId == "") {
      return await recipeCollection.doc(uid).set({
        'recipeId': uid,
        'name': name,
        'instructions': instructions,
        'userId': userId,
        'ingredients': ingredients,
        'cookTimeMin': cookTimeMin,
        'prepTimeMin': prepTimeMin
      });
    } else {
      return await recipeCollection.doc(recipeId).set({
        'recipeId': recipeId,
        'name': name,
        'instructions': instructions,
        'userId': userId,
        'ingredients': ingredients,
        'cookTimeMin': cookTimeMin,
        'prepTimeMin': prepTimeMin
      });
    }
  }

  Future updateRecipes(String argId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userCollection
        .doc(uid)
        .get() as DocumentSnapshot<Map<String, dynamic>>;

    var data = snapshot.data();
    List<String> myList;
    if (data!.containsKey('recipes')) {
      myList = List<String>.from(data['recipes']);
    } else {
      myList = <String>[];
    }

    if (!myList.contains(argId)) {
      myList.add(argId);
      return await userCollection.doc(uid).update({'recipes': myList});
    }

    return await userCollection.doc(uid).update({
      'recipes': [argId],
    });
  }

  Future<List<String>> getAddresses() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userCollection
        .doc(uid)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('containers')) {
      final myList = List<String>.from(data['containers']);
      return myList;
    } else {
      List<String> empty = [];
      return empty;
    }
  }

  Future<List<String>> getRecipeAddresses() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userCollection
        .doc(uid)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('recipes')) {
      final myList = List<String>.from(data['recipes']);
      return myList;
    } else {
      List<String> empty = [];
      return empty;
    }
  }

  Future<List<String>> getFoodAddresses() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userCollection
        .doc(uid)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('FoodItems')) {
      final myList = List<String>.from(data['FoodItems']);
      return myList;
    } else {
      List<String> empty = [];
      return empty;
    }
  }

  Future<bool> getFull(String address) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await containerCollection
        .doc(address)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('full')) {
      bool full = data['full'];
      return full;
    } else {
      throw NullThrownError;
    }
  }

  Future<int> getVal(String address) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await containerCollection
        .doc(address)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('value')) {
      int val = data['value'];
      return val;
    } else {
      throw NullThrownError;
    }
  }

  Future<String> getSize(String address) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await containerCollection
        .doc(address)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('value')) {
      String size = data['size'];
      return size;
    } else {
      throw NullThrownError;
    }
  }

  //Watches for changes in the container collection
  Future<Stream<List<customContainer.Container>>> get containers async {
    final containerList = await getAddresses();

    return containerCollection
        .where('mac', whereIn: containerList.isEmpty ? ['-1'] : containerList)
        .snapshots()
        .map(_containerListFromSnapshot);
  }

  //gets current list of containers
  Future<List<customContainer.Container>?> getContainerList() async {
    var containerList = await getAddresses();
    List<customContainer.Container> combinedList = [];
    for (int i = 0; i < containerList.length / 10; i++) {
      List<String> addressBatch;
      var lowerBound = i * 10;
      if (lowerBound + 10 > containerList.length) {
        addressBatch = containerList.sublist(lowerBound);
      } else {
        addressBatch = containerList.sublist(lowerBound, lowerBound + 10);
      }
      List<customContainer.Container> subsetList = await containerCollection
          .where('mac',
              whereIn:
                  addressBatch.isEmpty ? ['Invalid Container'] : addressBatch)
          .get()
          .then((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map((doc) {
          customContainer.Container container;
          container = customContainer.Container();
          return container.copyWith(
              name: (doc.data() as Map<String, dynamic>)['name'] ?? '',
              size: (doc.data() as Map<String, dynamic>)['size'] ?? 'Small',
              value: (doc.data() as Map<String, dynamic>)['value'] ?? 0,
              uid: doc.id,
              barcode: (doc.data() as Map<String, dynamic>)['barcode'] ?? '',
              full: (doc.data() as Map<String, dynamic>)['full'] ?? true);
        }).toList();
      });
      combinedList.addAll(subsetList);
    }
    return combinedList;
  }

  //gets current list of recpies
  Future<List<Recipe>?> getRecipeList() async {
    final recipeList = await getRecipeAddresses();
    return recipeCollection
        .where('recipeId', whereIn: recipeList)
        .get()
        .then(_recipeListFromSnapshot);

    //.map(_recipeListFromSnapshot);
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   return querySnapshot.docs.map((doc) {
    //     Recipe recipe;
    //     recipe = Recipe();
    //     return recipe.copyWith(
    //         id: (doc.data() as Map<String, dynamic>)['id'] ?? '',
    //         name: (doc.data() as Map<String, dynamic>)['name'] ?? '',
    //         //instructions: (doc.data() as Map<String, dynamic>)['instructions'] ?? List<String>,
    //         userId: (doc.data() as Map<String, dynamic>)['userId'] ?? '',
    //         //ingredients: (doc.data() as Map<String, dynamic>)['ingredients'] ?? '',
    //         cookTimeMin: (doc.data() as Map<String, dynamic>)['cookTimeMin'] ?? 0,
    //         prepTimeMin: (doc.data() as Map<String, dynamic>)['prepTimeMin'] ?? 0);
    //   }).toList();
    // });
  }

  //Recipe list from snapshot
  List<Recipe> _recipeListFromSnapshot(QuerySnapshot snapshot) {
    List<Recipe> recipes = [];
    dynamic docs = snapshot.docs;
    //try {
    for (int i = 0; i < docs.length; i++) {
      dynamic doc = docs[i];
      Recipe recipe = Recipe();
      dynamic temp;

      recipe.recipeId = (doc.data() as Map<String, dynamic>)['recipeId'] ?? '';
      recipe.name = (doc.data() as Map<String, dynamic>)['name'] ?? '';

      temp = (doc.data() as Map<String, dynamic>)['instructions'] ?? [];
      List<String> instructions = [];
      for (int j = 0; j < temp.length; j++) {
        instructions.add(temp[j]);
      }

      recipe.instructions = instructions;
      recipe.userId = (doc.data() as Map<String, dynamic>)['userId'] ?? '';

      temp = (doc.data() as Map<String, dynamic>)['ingredients'] ?? [];
      List<String> ingredients = [];
      for (int j = 0; j < temp.length; j++) {
        ingredients.add(temp[j]);
      }

      recipe.ingredients = ingredients;
      recipe.cookTimeMin =
          (doc.data() as Map<String, dynamic>)['cookTimeMin'] ?? 0;
      recipe.prepTimeMin =
          (doc.data() as Map<String, dynamic>)['prepTimeMin'] ?? 0;

      recipes.add(recipe);
    }
    return recipes;
  }

  //Container list from snapshot
  List<customContainer.Container> _containerListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      customContainer.Container container;
      container = customContainer.Container();
      return container.copyWith(
          name: (doc.data() as Map<String, dynamic>)['name'] ?? '',
          size: (doc.data() as Map<String, dynamic>)['size'] ?? 'Small',
          value: (doc.data() as Map<String, dynamic>)['value'] ?? 0,
          uid: doc.id,
          barcode: (doc.data() as Map<String, dynamic>)['barcode'] ?? '',
          full: (doc.data() as Map<String, dynamic>)['full'] ?? true);
    }).toList();
  }

  List<customContainer.Container> _mapContainers(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      customContainer.Container container;
      container = customContainer.Container();
      return container.copyWith(
          name: (doc.data() as Map<String, dynamic>)['name'] ?? '',
          size: (doc.data() as Map<String, dynamic>)['size'] ?? 'Small',
          value: (doc.data() as Map<String, dynamic>)['value'] ?? 0,
          uid: doc.id,
          barcode: (doc.data() as Map<String, dynamic>)['barcode'] ?? '',
          full: (doc.data() as Map<String, dynamic>)['full'] ?? true);
    }).toList();
  }

  //gets current list of food items
  Future<List<FoodItem>?> getFoodItemList() async {
    var foodList = await getFoodAddresses();
    List<FoodItem> combinedList = [];
    for (int i = 0; i < foodList.length / 10; i++) {
      List<String> addressBatch;
      var lowerBound = i * 10;
      if (lowerBound + 10 > foodList.length) {
        addressBatch = foodList.sublist(lowerBound);
      } else {
        addressBatch = foodList.sublist(lowerBound, lowerBound + 10);
      }
      List<FoodItem> subsetList = await foodItemCollection
          .where('uid',
              whereIn:
                  addressBatch.isEmpty ? ['Invalid Food Item'] : addressBatch)
          .get()
          .then((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map((doc) {
          FoodItem foodItem = FoodItem();
          Timestamp time =
              (doc.data() as Map<String, dynamic>)['expDate'] as Timestamp;
          DateTime date = time.toDate();
          return foodItem.copyWith(
              name: (doc.data() as Map<String, dynamic>)['name'] ?? '',
              value: (doc.data() as Map<String, dynamic>)['value'] ?? 0,
              uid: doc.id,
              expDate: date,
              barcode: (doc.data() as Map<String, dynamic>)['barcode'] ?? '');
        }).toList();
      });
      combinedList.addAll(subsetList);
    }
    return combinedList;
  }

  Future updateFoodItemData(String name, DateTime? expDate) async {
    final result = await foodItemCollection.add({
      'barcode': null,
      'value': 0,
      'name': name,
      'uid': "",
      'expDate': expDate
    });
    foodItemCollection.doc(result.id).update({'uid': result.id});
    return result;
  }

  Future updateExistingFoodItem(FoodItem foodItem) async {
    return await foodItemCollection.doc(foodItem.uid).set({
      'barcode': foodItem.barcode,
      'value': foodItem.value,
      'name': foodItem.name,
      'uid': foodItem.uid,
      'expDate': foodItem.expDate,
    });
  }

  Future updateFoodItems(mac) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userCollection
        .doc(uid)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('FoodItems')) {
      final myList = List<String>.from(data['FoodItems']);
      if (!myList.contains(mac)) {
        myList.add(mac);
      }
      return await userCollection.doc(uid).update({'FoodItems': myList});
    }

    return await userCollection.doc(uid).update({
      'FoodItems': [mac],
    });
  }

  Future deleteFoodItems(String mac) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userCollection
        .doc(uid)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (data.containsKey('FoodItems')) {
      final myList = List<String>.from(data['FoodItems']);
      myList.remove(mac);
      await foodItemCollection.doc(mac).delete();
      return await userCollection.doc(uid).update({'FoodItems': myList});
    }

    return false;
  }

  //get grocery lists
  Future<List<GroceryList>?> getGroceryLists() async {
    return groceryListCollection
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((doc) {
        GroceryList groceryList = GroceryList();
        DateTime date = (doc.data() as Map<String, dynamic>)['date'].toDate() ??
            DateTime.now();
        var foodList = (doc.data() as Map<String, dynamic>)['list'] ?? [];
        var castedFoodList =
            (foodList as List).map((item) => item as String).toList();
        return groceryList.copyWith(
            creationDate: date,
            foodItems: castedFoodList,
            name: (doc.data() as Map<String, dynamic>)['name'] ?? '',
            id: doc.id,
            containerGroceryList:
                (doc.data() as Map<String, dynamic>)['container'] ?? '');
      }).toList();
    });
  }

  //create grocery list
  Future createGroceryList(GroceryList groceryList) async {
    final groceryDatabaseEntry = {
      'uid': uid,
      'list': groceryList.foodItems,
      'date': groceryList.creationDate,
      'name': groceryList.name,
      'container': groceryList.containerGroceryList
    };
    groceryListCollection.add(groceryDatabaseEntry);
  }

  //delete grocery lists
  Future deleteGroceryList(String id) async {
    await groceryListCollection.doc(id).delete();
  }

  //update grocery list
  Future updateGroceryList(String id, GroceryList newGroceryList) async {
    if (id == "") {
      throw Exception("Grocery List ID not found!");
    }
    return await groceryListCollection.doc(id).update({
      'list': newGroceryList.foodItems,
      'date': newGroceryList.creationDate,
      'name': newGroceryList.name,
      'container': newGroceryList.containerGroceryList
    });
  }

  //check if there exists a low container grocery list in the database
  Future<bool> checkLowContainerGroceryList() async {
    QuerySnapshot snapshot =
        await groceryListCollection.where('uid', isEqualTo: uid).get();
    try {
      for (int i = 0; i < snapshot.size; i++) {
        if (snapshot.docs.elementAt(i)['container']) {
          return true;
        }
      }
      return false;
    } catch (error, stacktrace) {
      print(stacktrace);
      return true;
    }
  }
}
