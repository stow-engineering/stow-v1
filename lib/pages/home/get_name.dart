// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

// Project imports:

class GetName extends StatelessWidget {
  final String uid;
  final bool fullName;
  GetName(this.uid, this.fullName, {super.key});
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('User');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: userCollection.doc(uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          if (!fullName) {
            return Text("${data['first_name']}",
                style: const TextStyle(
                    color: Color.fromARGB(255, 0, 176, 80),
                    fontSize: 35,
                    fontWeight: FontWeight.bold));
          } else {
            return Text("${data['first_name']} ${data['last_name']}",
                style: const TextStyle(color: Colors.black, fontSize: 30));
          }
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
