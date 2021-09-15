import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prasad/config.dart';

import 'expandable.dart';

class Stale extends StatefulWidget {
  const Stale({Key? key}) : super(key: key);

  @override
  _StaleState createState() => _StaleState();
}

class _StaleState extends State<Stale> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('Stale Food'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("FoodTickets")
                .where('status', isEqualTo: "Your (Food Seems Stale) don't worry we will decompose it and it will be used for better purpose")
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
                    "There are no Stale Tickets.",
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
