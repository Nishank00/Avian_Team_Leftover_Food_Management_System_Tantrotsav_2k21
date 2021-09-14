import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prasad/admin/expandable.dart';
import 'package:prasad/config.dart';

class MyDonations extends StatefulWidget {
  const MyDonations({ Key? key }) : super(key: key);

  @override
  _MyDonationsState createState() => _MyDonationsState();
}

class _MyDonationsState extends State<MyDonations> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text('My donation'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("FoodTickets")
               .where('createdBy',
                                isEqualTo: FirebaseAuth
                                    .instance.currentUser!.phoneNumber)
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
                    "There are no donations made by you.",
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
                    return CardWidget(doc: doc,isAdmin: false,);
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}