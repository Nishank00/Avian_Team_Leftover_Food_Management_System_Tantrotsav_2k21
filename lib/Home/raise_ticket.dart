import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../config.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class RaiseNewDonation extends StatefulWidget {
  const RaiseNewDonation({Key? key}) : super(key: key);

  @override
  _RaiseNewDonationState createState() => _RaiseNewDonationState();
}

class _RaiseNewDonationState extends State<RaiseNewDonation> {
  late String _chosenValue = 'Select Ocassion';
  late String _chosenFoodType = 'Select type of food';

  TimeOfDay selectedTime = TimeOfDay.now();
  late String _hour, _minute, _time;
  TextEditingController _timeController = TextEditingController();

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

  late String _setTime;

  @override
  void initState() {
    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
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
                  fontSize: 14,
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
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Prepration Type : ',
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
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
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(primaryColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: primaryColor)))),
          onPressed: () {},
          child: const Text(
            'Submit',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      )
    ]);
  }
}
