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
      'containers': null
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

  //Watches for changes in the container collection
  Stream<List<customContainer.Container>> get containers {
    return containerCollection.snapshots().map(_containerListFromSnapshot);
  }

  // Future<String> getFirstname() async {
  //   return FutureBuilder<DocumentSnapshot>(
  //     future: userCollection.doc(uid).get(),
  //     builder:
  //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //       if (snapshot.hasError) {
  //         return Text("Something went wrong");
  //       }

  //       if (snapshot.hasData && !snapshot.data!.exists) {
  //         return Text("Document does not exist");
  //       }

  //       if (snapshot.connectionState == ConnectionState.done) {
  //         Map<String, dynamic> data =
  //             snapshot.data!.data() as Map<String, dynamic>;
  //         return Text("${data['first_name']}");
  //       }

  //       return Text("loading");
  //     },
  //   );
  // }

  //Container list from snapshot
  List<customContainer.Container> _containerListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return customContainer.Container(
          doc.data()['value'] ?? 0, doc.id, doc.data()['barcode'] ?? '');
    }).toList();
  }

  // Stream<DocumentSnapshot> get userData {
  //   var containerDocs = [];
  //   containerCollection.doc(uid).get();
  //   for(int i = 0; i < 0; i++){
  //     containerCollection.doc(uid).snaps();
  //   }
  // }

  //}

}
