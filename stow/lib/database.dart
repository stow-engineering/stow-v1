

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'container.dart';

class DatabaseService {

  final String uid;
  DatabaseService(this.uid);

  //Collection reference
  final CollectionReference containerCollection = FirebaseFirestore.instance.collection('Containers');
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('User');

  //Creates new user in database
  Future updateUserData(String email) async{
    return await userCollection.doc(uid).set({'email': email});
  }

  //Watches for changes in the container collection
  Stream<List<Container>> get containers {
    return containerCollection.snapshots()
    .map(_containerListFromSnapshot);
  }

  //Container list from snapshot
  List<Container> _containerListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){
      return Container(
        doc.data()['value'] ?? 0,
        doc.id,
        doc.data()['barcode'] ?? ''
      );
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