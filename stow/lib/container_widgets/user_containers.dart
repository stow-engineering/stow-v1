import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../models/container.dart' as customContainer;
import '../models/user.dart';
import '../utils/firebase.dart';

class NumberContainers extends StatefulWidget {
  final StowUser user;
  const NumberContainers({Key? key, required this.user}) : super(key: key);

  @override
  State<NumberContainers> createState() => _NumberContainers();
}

class _NumberContainers extends State<NumberContainers> {
  @override
  FutureBuilder<List<String>> build(BuildContext context) {
    final FirebaseService service = FirebaseService(widget.user.uid);
    return FutureBuilder<List<String>>(
      future: service.getAddresses(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.error);
        }

        if (snapshot.hasData) {
          if (snapshot.data != null) {
            return Text(
              snapshot.data!.length.toString(),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 60,
                  fontWeight: FontWeight.bold),
            );
          }
        }

        return const SizedBox(
          child: CircularProgressIndicator(),
          width: 10,
          height: 10,
        );
      },
    );
  }
}

// class NumFull extends StatefulWidget {
//   final StowUser user;
//   const NumFull({Key? key, required this.user}) : super(key: key);

//   @override
//   State<NumFull> createState() => _NumFullState();
// }

// class _NumFullState extends State<NumFull> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
