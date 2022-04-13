import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'container.dart' as customContainer;

class DatabaseService {
  final String uid;
  DatabaseService(this.uid);

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

  Future updateContainerData(String name, String size, String mac) async {
    return await containerCollection
        .doc(mac)
        .set({'barcode': null, 'full': false, 'mac': mac, 'value': 0});
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
    DocumentSnapshot snapshot =
        await containerCollection.doc(address.substring(1)).get();
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
      return customContainer.Container(doc.data()['value'] ?? 0, doc.id,
          doc.data()['barcode'] ?? '', doc.data()['full'] ?? true);
    }).toList();
  }
}
