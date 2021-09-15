import 'package:flutter/material.dart';
import 'package:prasad/admin/add_post.dart';
import 'package:prasad/admin/delivered.dart';
import 'package:prasad/admin/pending_tickets.dart';
import 'package:prasad/admin/picked_up.dart';
import 'package:prasad/admin/stale.dart';
import 'package:prasad/admin/waiting_pickup.dart';
import 'package:prasad/config.dart';

class Option {
  final String title;

  final VoidCallback onTap;
  Option(this.title, this.onTap);
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<Option> options = [];

  @override
  void initState() {
    super.initState();
    options.add(Option('Pending Tickets', () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PendingTicket()));
    }));
    options.add(Option('Waiting for pickup', () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => WaitingPickup()));
    }));
    options.add(Option('Picked Up', () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PickedUp()));
    }));
    options.add(Option('Happily delivered', () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Delivered()));
    }));
    options.add(Option('Add Post', () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddPost()));
    }));
    options.add(Option('Stale Food', () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Stale()));
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Admin Panel'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 2 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount: options.length,
            itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                onTap: options[index].onTap,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    options[index].title,
                    style: TextStyle(color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                ),
              );
            }),
      ),
    );
  }
}
