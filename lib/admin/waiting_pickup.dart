import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prasad/config.dart';

import 'expandable.dart';

class WaitingPickup extends StatefulWidget {
  const WaitingPickup({Key? key}) : super(key: key);

  @override
  _WaitingPickupState createState() => _WaitingPickupState();
}

class _WaitingPickupState extends State<WaitingPickup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('Waiting for pickup'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("FoodTickets")
                .where('status', isEqualTo: 'Waiting for pick up')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            // ignore: missing_return
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "There are no Pending Tickets.",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                );
              }
              if (snapshot.data!.docs.isNotEmpty) {
                   return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    return CardWidget(doc: doc,isAdmin: true,);
                  },
                );
              } else {
                return Container();
              }
            }));
  }
}
