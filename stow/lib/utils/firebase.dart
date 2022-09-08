import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stow/bloc/food_events.dart';
import 'package:stow/models/food_item.dart';

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
        .where('mac', whereIn: containerList)
        .snapshots()
        .map(_containerListFromSnapshot);
  }

  //gets current list of containers
  Future<List<customContainer.Container>?> getContainerList() async {
    final containerList = await getAddresses();
    return containerCollection
        .where('mac', whereIn: containerList)
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

  //gets current list of containers
  Future<List<FoodItem>?> getFoodItemList() async {
    final foodList = await getFoodAddresses();
    return foodItemCollection
        .where('uid', whereIn: foodList)
        .get()
        .then((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((doc) {
        FoodItem foodItem = FoodItem();
        return foodItem.copyWith(
            name: (doc.data() as Map<String, dynamic>)['name'] ?? '',
            value: (doc.data() as Map<String, dynamic>)['value'] ?? 0,
            uid: doc.id,
            barcode: (doc.data() as Map<String, dynamic>)['barcode'] ?? '');
      }).toList();
    });
  }

  Future updateFoodItemData(String name) async {
    final result = await foodItemCollection
        .add({'barcode': null, 'value': 0, 'name': name, 'uid': ""});
    foodItemCollection.doc(result.id).update({'uid': result.id});
    return result;
  }

  Future updateExistingFoodItem(FoodItem foodItem) async {
    return await foodItemCollection.doc(foodItem.uid).set({
      'barcode': foodItem.barcode,
      'value': foodItem.value,
      'name': foodItem.name,
      'uid': foodItem.uid
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
}
