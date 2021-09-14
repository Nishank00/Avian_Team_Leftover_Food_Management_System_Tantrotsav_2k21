import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prasad/config.dart';

class CardWidget extends StatefulWidget {
  final doc;
  final bool isAdmin;
  const CardWidget({Key? key, required this.doc, required this.isAdmin})
      : super(key: key);

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool isVeg = true;

  @override
  void initState() {
    if (widget.doc['isVeg'] == 1) {
      isVeg = false;
    } else {
      isVeg = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(132, 131, 131, 0.39),
            Color(0xff6c63ff),
          ]),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
            color: primaryColor,
          ),
        ),
        child: ExpandableTheme(
          data: const ExpandableThemeData(
              iconPlacement: ExpandablePanelIconPlacement.right,
              iconColor: Colors.white,
              animationDuration: Duration(milliseconds: 400)),
          child: ExpandablePanel(
            theme: const ExpandableThemeData(
                iconPlacement: ExpandablePanelIconPlacement.right),
            header: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.doc['donatorName']}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${widget.doc['donatorPhone']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "#${widget.doc['reportNumber']}",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            collapsed: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "${widget.doc['reportLocation']}",
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.call))
                ],
              ),
            ),
            expanded: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ocassion : ${widget.doc["ocassion"]}'),
                  const SizedBox(height: 10),
                  Text('Type Of Food : ${widget.doc["typeOfFood"]}'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Qty of Food : ${widget.doc["quantityOfFood"]}'),
                      Row(
                        children: [
                          Text('Veg/Non-veg : '),
                          Icon(
                            Icons.check_box_outline_blank,
                            color: isVeg ? Colors.green : Colors.red,
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Preferred Time : ${widget.doc["preferredTime"]}'),
                  const SizedBox(height: 10),
                  widget.isAdmin
                      ? ElevatedButton(
                          onPressed: () {
                            changeState();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: primaryColor)))),
                          child: Text('Change State'),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
    Future<void> changeState() async {
      if (widget.doc['status'] == 'Waiting for approval') {
          await FirebaseFirestore.instance
          .collection("FoodTickets")
          .doc(widget.doc['reportNumber'])
          .update({
           'status' : 'Waiting for pick up'
          });
      } else if (widget.doc['status'] == 'Waiting for pick up')  {
        await FirebaseFirestore.instance
          .collection("FoodTickets")
          .doc(widget.doc['reportNumber'])
          .update({
           'status' : 'Waiting for distribution'
          });
      } else if (widget.doc['status'] == 'Waiting for distribution') { {
        await FirebaseFirestore.instance
          .collection("FoodTickets")
          .doc(widget.doc['reportNumber'])
          .update({
           'status' : 'Happily delivered'
          });
      }
    
          

      Fluttertoast.showToast(msg: "status Changed");
   
  }
    }
    }