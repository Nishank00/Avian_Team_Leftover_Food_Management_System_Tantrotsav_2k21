import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prasad/config.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String photoUrl = '';

  TextEditingController _authorName = TextEditingController();
  TextEditingController _caption = TextEditingController();
  TextEditingController _gstIn = TextEditingController();
  TextEditingController _phone = TextEditingController();

  Future<void> addProfilePhoto() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();

    var randomInt = Random.secure().nextInt(100);

    PickedFile image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = (await _imagePicker.getImage(source: ImageSource.gallery))!;
      var file = File(image.path);

      if (image != null) {
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('communityfeed')
            .child("$randomInt")
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          photoUrl = downloadUrl;
        });
      } else {
        print('No Image Path Received');
      }
    } else {
      print('Permission not granted. Try Again with permission access');
    }
  }

  Future<void> saveChanges() async {
    await FirebaseFirestore.instance.collection("CommunityFeed").add({
      "photoUrl": photoUrl,
      "authorName": _authorName.text,
      "caption": _caption.text,
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false ,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text("Add Post"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              "This section is used to post, Events in the community feed",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30.0,
            ),

            // CircleAvatar(
            //   backgroundColor: Colors.teal,
            //   radius: 80,
            //   child: photoUrl != ''
            //       ? Image.network(
            //           photoUrl,
            //         )
            //       : Container(
            //           child: Text(
            //             "Upload",
            //           ),
            //         ),
            // ),
            photoUrl != ''
                ? Container(
                    height: 150,
                    width: 150,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: photoUrl,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        color: primaryColor, shape: BoxShape.circle),
                    height: 150,
                    width: 150,
                    child: Center(
                        child: Text(
                      "Upload Photo",
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    )),
                  ),
            SizedBox(
              height: 20.0,
            ),
            InkWell(
              onTap: () {
                addProfilePhoto();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Add / Edit photo",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 15.0),
                  ),
                  IconButton(icon: Icon(Icons.add_a_photo), onPressed: () {})
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10, top: 20),
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: TextFormField(
                controller: _authorName,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black26,
                    ),
                    hintText: "Author Name",
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
              ),
            ),

            Card(
              margin: EdgeInsets.only(left: 10, right: 10, top: 20),
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              child: TextFormField(
                controller: _caption,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.business,
                      color: Colors.black26,
                    ),
                    hintText: "Caption",
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            InkWell(
              onTap: () async {
                await saveChanges();
                Fluttertoast.showToast(msg: "Post has been added");
              },
              child: Container(
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                height: 60,
                width: 300,
                child: Center(
                    child: Text(
                  "Add Post",
                  style: TextStyle(
                      fontSize: 18.0,
                      //fontWeight: FontWeight.w500,
                      color: Colors.white),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
