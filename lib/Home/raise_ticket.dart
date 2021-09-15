import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';
import 'package:prasad/Home/my_donation.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../config.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geocoder/geocoder.dart' as geoCodeModel;
import 'package:flutter/rendering.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../config.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

import 'package:random_string/random_string.dart';

class RaiseNewDonation extends StatefulWidget {
  const RaiseNewDonation({Key? key}) : super(key: key);

  @override
  _RaiseNewDonationState createState() => _RaiseNewDonationState();
}

class _RaiseNewDonationState extends State<RaiseNewDonation> {
  late String _chosenValue = 'Select Ocassion';
  late String _chosenFoodType = 'Select type of food';
  late int isVeg;
  late String donationNumber;

  String foodLocation = '';
  late double foodLatitude;
  late double foodLongitude;

  Location location = new Location();
  GeoCode _geoCode = GeoCode();
  static bool callLocation = true;

  late bool _serviceEnabled;
  late Permission _permissionGranted;
  late LocationData _locationData;

  GlobalKey<FormState> _donationKey = GlobalKey();

  TimeOfDay selectedTime = TimeOfDay.now();
  late String _hour, _minute, _time;
  TextEditingController _timeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _countController = TextEditingController();

  Future<void> fetchLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        Fluttertoast.showToast(msg: "Permission Denied");
      }
    }

    if (await Permission.location.request().isGranted) {
      Fluttertoast.showToast(msg: "Location permission granted");
    } else {
      Fluttertoast.showToast(msg: "Location permission denied");
    }

    _locationData = await location.getLocation();
    // final coordinates = new geoCodeModel.Coordinates(
    //     _locationData.latitude, _locationData.longitude);
    // var addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var addresses = await _geoCode.reverseGeocoding(
        latitude: _locationData.latitude!, longitude: _locationData.longitude!);
    var first = addresses.streetNumber;
    foodLatitude = _locationData.latitude!;
    foodLongitude = _locationData.longitude!;
    foodLocation =
        "${addresses.streetNumber} ${addresses.streetAddress} ${addresses.postal}";
    setState(() {});
    print("CUUUUUUURRRRREEEEENNNNTTTT::::${foodLocation}");
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
    }
  }

  Future<void> uploadFoundReport() async {
    if (_donationKey.currentState!.validate() && foodLocation != '') {
      await FirebaseFirestore.instance
          .collection("FoodTickets")
          .doc(donationNumber)
          .set({
        "status": "Waiting for approval",
        "reportNumber": donationNumber,
        "createdAt": FieldValue.serverTimestamp(),
        "createdBy": FirebaseAuth.instance.currentUser!.phoneNumber,
        "reportLocation": foodLocation,
        "reportLongitude": foodLongitude,
        "reportLatitude": foodLatitude,
        "donatorName": _nameController.text,
        "donatorPhone": _phoneController.text,
        "ocassion": _chosenValue,
        "isVeg": isVeg,
        "typeOfFood": _chosenFoodType,
        "quantityOfFood": _countController.text,
        "preferredTime": _timeController.text
      }).then((value) => {
                Fluttertoast.showToast(msg: "Your report has been submitted"),
                _showMyDialog(),
    donationNumber = randomNumeric(10)

              });
    } else {
      Navigator.of(context).pop();

      Fluttertoast.showToast(msg: "Please fetch the location");
    }
  }

  late String _setTime;

  @override
  void initState() {
    donationNumber = randomNumeric(10);

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Excellent',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: primaryColor),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Your Donation Ticket Has been raised\nYou will hear from us shortly",
                  style: TextStyle( 
                    fontSize: 15,
                  ),
                )
                //CONTEnt HERE
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              //color: Colors.teal,
              child: Text(
                'Go to My Donation',
                style: TextStyle(color: primaryColor),
              ),
              onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyDonations()),
                     );
                }),
              
      
            TextButton(
              child: Text(
                'Okay',
                style: TextStyle(color: primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _donationKey,
      child: ListView(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Text(
            'Enter Details',
            style: TextStyle(
                fontSize: 26, color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff6c63ff),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff6c63ff),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
              ),
              hintText: "Name",
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              labelStyle: TextStyle(color: Color(0xff6c63ff)),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff6c63ff),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff6c63ff),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff6c63ff),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
              ),
              hintText: "Alternative Contact Number",
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              labelStyle: TextStyle(color: Color(0xff6c63ff)),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xff6c63ff),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(40.0),
                ),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(40),
              ),
              border: Border.all(
                width: 2,
                color: Color(0xff6c63ff),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                focusColor: Colors.white,
                value: _chosenValue,
                //elevation: 5,
                style: const TextStyle(
                  color: Color(0xff6c63ff),
                ),
                iconEnabledColor: primaryColor,
                items: <String>[
                  'Select Ocassion',
                  'Birthday',
                  'Wedding',
                  'Anniversary',
                  'Party',
                  'Casual Get-together',
                  'Other'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }).toList(),
                hint: const Text(
                  "Please choose a Ocassion",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _chosenValue = value!;
                  });
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(40),
              ),
              border: Border.all(
                width: 2,
                color: Color(0xff6c63ff),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                focusColor: Colors.white,
                value: _chosenFoodType,
                //elevation: 5,
                style: const TextStyle(
                  color: Color(0xff6c63ff),
                ),
                iconEnabledColor: primaryColor,

                items: <String>[
                  'Select type of food',
                  'breads, cereals, rice, pasta, noodles and other',
                  'vegetables and legumes',
                  'fruits',
                  'milk, yoghurt, cheese and/or alternatives',
                  'lean meat, fish, poultry, eggs, nuts and legumes',
                  'Stale food for decomposition',
                  'Other'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }).toList(),
                hint: const Text(
                  "select type of food",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _chosenFoodType = value!;
                  });
                },
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
          width: MediaQuery.of(context).size.width * 0.6,
          child: Row(
            children: [
              Text(
                "Location: ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Text(
                  "$foodLocation",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 16,
        ),
        InkWell(
          onTap: () {
            fetchLocation();
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              // gradient: LinearGradient(
              //     begin: Alignment.centerLeft,
              //     end: Alignment.centerRight,
              //     colors: [
              //       Color(0xffff5f6d),
              //       Color(0xffff5f6d),
              //       Color(0xffffc371),
              //     ],
              //   ),
              color: primaryColor,
            ),
            //color: Theme.of(context).accentColor,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  "Fetch Location",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            )),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select food Type : ',
                style: TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              ToggleSwitch(
                minWidth: 100.0,
                initialLabelIndex: 1,
                cornerRadius: 20.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: ['Veg', 'Non-veg'],
                icons: [Icons.restaurant, Icons.restaurant],
                activeBgColors: [
                  [Colors.green],
                  [Colors.red]
                ],
                onToggle: (index) {
                  print('switched to: $index');
                  isVeg = index;
                },
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(children: [
              Text(
                'How many people can be fed ? ',
                style: TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextFormField(
                    controller: _countController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff6c63ff),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff6c63ff),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                      hintText: "Count",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      labelStyle: TextStyle(color: Color(0xff6c63ff)),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xff6c63ff),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 16.0),
                    ),
                  ),
                ),
              ),
            ])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Preferred time to pick up food : ',
                style: TextStyle(
                    fontSize: 16,
                    color: primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  _selectTime(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.grey[200]),
                  child: TextFormField(
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                    onSaved: (String? val) {
                      _setTime = val!;
                    },
                    enabled: false,
                    keyboardType: TextInputType.text,
                    controller: _timeController,
                    decoration: const InputDecoration(
                        disabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        // labelText: 'Time',
                        contentPadding: EdgeInsets.all(5)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: primaryColor)))),
            onPressed: () {
              uploadFoundReport();
            },
            child: const Text(
              'Submit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 50,
        )
      ]),
    );
  }
}
