import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../models/container.dart' as customContainer;

class FirebaseService {
  final String uid;
  FirebaseService(this.uid);

  //Collection reference
  final CollectionReference containerCollection =
      FirebaseFirestore.instance.collection('Containers');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');

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
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data();
    if (data.containsKey('containers')) {
      final myList = List<String>.from(data['containers']);
      if (!myList.contains(mac)) {
        myList.add(mac);
      }
      return await userCollection.doc(uid).update({'containers': myList});
    }

    return await userCollection.doc(uid).update({
      'containers': [mac],
    });
  }

  Future updateContainerData(String name, String size, String mac) async {
    return await containerCollection.doc(mac).set({
      'barcode': null,
      'full': false,
      'mac': mac,
      'value': 0,
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
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data();
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
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data();
    if (data.containsKey('containers')) {
      final myList = List<String>.from(data['containers']);
      return myList;
    } else {
      List<String> empty = [];
      return empty;
    }
  }

  Future<bool> getFull(String address) async {
    DocumentSnapshot snapshot = await containerCollection.doc(address).get();
    var data = snapshot.data();
    if (data.containsKey('full')) {
      bool full = data['full'];
      return full;
    } else {
      throw NullThrownError;
    }
  }

  // Future<List<customContainer.Container>> getContainers() async {
  //   DocumentSnapshot snapshot = await userCollection.doc(uid).get();
  //   var data = snapshot.data();
  //   List<customContainer.Container> resultList = [];
  //   if (data.containsKey('containers')) {
  //     final containerList = List<String>.from(data['containers']);
  //     for (int i = 0; i < containerList.length; i++) {
  //       DocumentSnapshot containerSnapshot =
  //           await containerCollection.doc(containerList[i]).get();
  //       var containerData = containerSnapshot.data();
  //       resultList.add()
  //     }
  //   } else {
  //     List<customContainer.Container> empty = [];
  //     return empty;
  //   }
  // }

  //Watches for changes in the container collection
  Future<Stream<List<customContainer.Container>>> get containers async {
    final containerList = await getAddresses();
    return containerCollection
        .where('mac', whereIn: containerList)
        .snapshots()
        .map(_containerListFromSnapshot);
  }

  //Container list from snapshot
  List<customContainer.Container> _containerListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      customContainer.Container container;
      container = customContainer.Container();
      return container.copyWith(
          name: doc.data()['name'] ?? '',
          size: doc.data()['size'] ?? 'Small',
          value: doc.data()['value'] ?? 0,
          uid: doc.id,
          barcode: doc.data()['barcode'] ?? '',
          full: doc.data()['full'] ?? true);
    }).toList();
  }
}
