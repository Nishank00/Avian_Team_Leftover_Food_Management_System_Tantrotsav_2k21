import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../config.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:geocoder/geocoder.dart' as geoCodeModel;

class RaiseNewDonation extends StatefulWidget {
  const RaiseNewDonation({Key? key}) : super(key: key);

  @override
  _RaiseNewDonationState createState() => _RaiseNewDonationState();
}

class _RaiseNewDonationState extends State<RaiseNewDonation> {
  late String _chosenValue = 'Select Ocassion';

  String foodLocation = '';
  late double foodLatitude;
  late double foodLongitude;

  Location location = new Location();
  GeoCode _geoCode = GeoCode();
  static bool callLocation = true;

  late bool _serviceEnabled;
  late Permission _permissionGranted;
  late LocationData _locationData;

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
    print("CUUUUUUURRRRREEEEENNNNTTTT::::${first}");
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
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
              hintText: "Contact Number",
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
                style: TextStyle(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Food Type : ',
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
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
