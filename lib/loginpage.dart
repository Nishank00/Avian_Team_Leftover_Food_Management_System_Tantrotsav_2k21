import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:prasad/admin/admin_homepage.dart';

import 'config.dart';
import 'Home/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //false for phoneAuthenticationPage true for otpPage
  bool currentViewIsOtpPage = false;
  TextEditingController editingControllerPhone = TextEditingController();
  TextEditingController editingControllerOtp = TextEditingController();
  TextEditingController editingControllerName = TextEditingController();

  late FocusNode focusNodePin;

  static final int _pinLength = 6;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  /// Control the input text field.
  TextEditingController _pinEditingController = TextEditingController();

  /// Decorate the outside of the Pin.
  late PinDecoration _pinDecoration;
  PinEntryType _pinEntryType = PinEntryType.circle;

  /// Control whether show the obscureCode.
  bool _obscureEnable = false;
  ColorBuilder _solidColor = PinListenColorBuilder(
    primaryColor,
    Colors.grey.shade300,
  );
  bool _solidEnable = true;

  /// Control whether textField is enable.
  bool _enable = true;
  late String strVerifyId;

  late String strCode;

  String strPhone = '';
  String imgUrl = '';
  String fileImgUrl = '';

  File? fileImgPath;
//  String countryCode='+91';

  bool uploadImageToServer = false;

  bool isLoading = false;
  bool processind = false;

  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    focusNodePin = FocusNode();
    _pinEditingController.addListener(() {
      print("PIN: ${_pinEditingController.text}");
    });
    _pinDecoration = BoxLooseDecoration(
      strokeColorBuilder: PinListenColorBuilder(Colors.cyan, primaryColor),
      bgColorBuilder: _solidEnable ? _solidColor : null,
      textStyle: TextStyle(color: Colors.white, fontSize: 15),
      //==strokeWidth: 4,
      obscureStyle: ObscureStyle(
        isTextObscure: _obscureEnable,
      ),
      hintText: '******',
    );
  }

  @override
  void dispose() {
    focusNodePin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(15.0),
          margin: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              currentViewIsOtpPage
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.0),
                          // Image.asset(
                          //   "assets/images/register.png",
                          //   height: 300,
                          //   width: 400,
                          // ),

                          Container(
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/img6.png"),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(height: 20.0),
                          Text("Verify your \n Phone number",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50.0,
                          ),
                          Container(
                            height: 300,
                            width: 400,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/images/logo.png"),
                                    fit: BoxFit.fitWidth)),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          // Text(
                          //   "Hiring app",
                          //   style: TextStyle(
                          //       fontSize: 30,
                          //       fontWeight: FontWeight.bold,
                          //       letterSpacing: 1.0),
                          // ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
              Container(
                alignment: Alignment.center,
                child: currentViewIsOtpPage
                    ? Text("Enter your OTP code here",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500))
                    : Text(
                        "Login with your phone number. We'll send you a verification code, so we know you're real",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500),
                      ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          currentViewIsOtpPage
                              ? Text(
                                  'Enter the OTP sent to 91 - $strPhone',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black38),
                                )
                              : Container(),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            //padding: EdgeInsets.all(10.0),
                            height: 60,
                            width: double.infinity,
                            child: currentViewIsOtpPage
                                ? getOtpWidget()
                                : getMobilePhoneWidget(),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          currentViewIsOtpPage
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                          text: 'Didn\'t recieve the OTP? ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black38,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'RESEND OTP',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.pinkAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ]),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 250,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(1.0),
                                  ),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              // setState(() {
                              //   currentViewIsOtpPage = !currentViewIsOtpPage;
                              // });
                              print("Go to OTP page");
                              setState(() {
                                //    focusNodePin.requestFocus();
                              });
                              if (!currentViewIsOtpPage) {
                                processind = true;
                                strPhone = editingControllerPhone.text.trim();
                                verifyPhoneNumber(strPhone);
                              } else {
                                processind = true;

                                submitForCheck();
                              }
                            },
                            // onLongPress: () {
                            //   if (currentViewIsOtpPage) {
                            //     Navigator.pushAndRemoveUntil(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => HomePage()),
                            //         (route) => false);
                            //   }
                            // },
                            child: Container(
                              height: 70,
                              width: 300,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6.0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  !currentViewIsOtpPage ? "Send OTP" : "Submit",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    )));
  }

  Widget getMobilePhoneWidgetx() {
    return TextField(
      textAlign: TextAlign.center,
      controller: editingControllerPhone,
      keyboardType: TextInputType.phone,
      style: TextStyle(
          fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
        hintText: "🇮🇳  Type 10 digits phone",
        counterText: "",
        hintStyle: TextStyle(
            fontSize: 18, color: Colors.black38, fontWeight: FontWeight.normal),
      ),
      maxLength: 10,
    );
  }

  Widget getMobilePhoneWidget() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.all(Radius.circular(6.0))),
      //width: double.infinity,
      child: IntlPhoneField(
        enabled: true,
        textAlign: TextAlign.left,
        showDropdownIcon: false,
        dropdownDecoration: BoxDecoration(),
        controller: editingControllerPhone,

        style: TextStyle(
            fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          //isDense: true,
          border: InputBorder.none,
          hintText: "Type 10 digits phone",
          counterText: "",
          hintStyle: TextStyle(
              fontSize: 15, color: Colors.black38, fontWeight: FontWeight.w500),
          suffixIconConstraints: BoxConstraints(
            minHeight: 20,
            minWidth: 20,
          ),
          suffixIcon: InkWell(
            onTap: () {
              editingControllerPhone.clear();
            },
            child: Container(
              height: 10.0,
              width: 10.0,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.black38),
              child: Center(
                child: Icon(
                  Icons.close,
                  color: Colors.grey.shade300,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ),
//      maxLength: 10,
        onCountryChanged: (phone) {
          setState(() {
            //countryCode = phone.countryCode;

            //  currency = "*";
          });
          //print(countryCode);
          print('Country code changed to: ' + "");
        },
        initialCountryCode: 'IN',
      ),
    );
  }

  Widget getOtpWidget() {
    return SizedBox(
      width: 200,
      height: 56,
      child: PinInputTextField(
        pinLength: _pinLength,
        decoration: _pinDecoration,
        controller: _pinEditingController,
        textInputAction: TextInputAction.go,
        enabled: _enable,
        keyboardType: TextInputType.number,
        textCapitalization: TextCapitalization.characters,
        onSubmit: (pin) {
          strCode = pin;
          //submitForCheck();
        },
        onChanged: (pin) {
          strCode = pin;
          debugPrint('onChanged execute. pin:$pin');
        },
        enableInteractiveSelection: false,
        autoFocus: false,
      ),
    );
  }

  FirebaseAuth initializeFirebaseAuth() {
    return FirebaseAuth.instance;
  }

  bool checkNumberValid(String number) {
    //if (number.length == 10) {
    return true;
    //} else {
    // return false;
    // }
  }

  verifyPhoneNumber(String number) async {
    if (checkNumberValid(number)) {
      FirebaseAuth auth = initializeFirebaseAuth();
      await auth.verifyPhoneNumber(
        phoneNumber: '+91' + number,
        timeout: Duration(minutes: 2),
        verificationCompleted: (AuthCredential cred) async {
          await initializeFirebaseAuth()
              .signInWithCredential(cred)
              .then((value) {
            if (value.user!.uid.length > 0) {
              print(value.user!.uid);
              editingControllerName.text = value.user!.displayName ?? '';
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(value.user!.uid)
                  .get()
                  .then((doc) => {
                        if (doc.exists)
                          {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()))
                          }
                        else
                          {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => SignupPage()))
                          }
                      });

              //_modalBottomSheetMenu(value.user.photoURL ?? '');
            }
          });
        },
        verificationFailed: funVerificationFailed,
        codeSent: funVerificationCodeSent,
        codeAutoRetrievalTimeout: (String verificationId) {
          //ignored Auto Retrieval Timeout
        },
      );
    }
  }

  funVerificationFailed(FirebaseAuthException exception) {
    if (exception.code == 'invalid-phone-number') {
      Fluttertoast.showToast(
          msg: 'The provided phone number is not valid.',
          backgroundColor: Colors.orange);
      print('The provided phone number is not valid.');
    } else {
      print(exception.code);
    }
  }

  funVerificationCodeSent(String verificationId, [int? resendToken]) async {
    //phoneNumber = editingControllerPhone.text;
    strVerifyId = verificationId;
    setState(() {
      processind = false;
      currentViewIsOtpPage = true;
    });
  }

  submitForCheck() async {
    if (strCode.isEmpty) return;
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: strVerifyId, smsCode: strCode);
      await initializeFirebaseAuth()
          .signInWithCredential(credential)
          .then((value) {
        if (value.user!.uid.length > 0) {
          print(value.user);
          editingControllerName.text = value.user!.displayName ?? '';
          if (value.user!.phoneNumber == '+911234567890') {
            //Admin panel
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (context) => AdminHomePage()), (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                (route) => false);
          }

          //_modalBottomSheetMenu(value.user.photoURL ?? '');
        }
      });
    } catch (Exception) {
      //  print("Verification code is wrong");
    }
  }

  void _modalBottomSheetMenu(String imgUrl) {
    print("File Image URL: $fileImgUrl");
    print("Image Url: $imgUrl");
    print("File Image Path $fileImgPath");
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (builder) {
          return StatefulBuilder(
            builder: (BuildContext context, modalSetState) {
              cropImage(PickedFile image) async {}

              pickFromPhone() async {}

              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.0),
                      height: 200.0,
                      color: Colors
                          .transparent, //could change this to Color(0xFF737373),
                      //so you don't have to change MaterialApp canvasColor
                      child: Column(
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 30.0,
                              // backgroundImage: imgUrl == '' && fileImgUrl == ''
                              //     ? AssetImage('assets/logo.png')
                              //     : fileImgUrl != ''
                              //         ? FileImage(File(fileImgUrl))
                              //         : NetworkImage(imgUrl),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: InkWell(
                              onTap: () async {
                                print("FilePath: $fileImgUrl");
                                await pickFromPhone();
                              },
                              child: Text(
                                'change',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.teal,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 48,
                                width: MediaQuery.of(context).size.width -
                                    16 -
                                    16 -
                                    10 -
                                    46,
                                child: TextFormField(
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.name,
                                  controller: editingControllerName,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          left: 15,
                                          bottom: 11,
                                          top: 11,
                                          right: 15),
                                      hintText: "Your Name"),
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black87),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (editingControllerName.text.trim().length >
                                      3) {
                                    insertUserData(
                                        editingControllerName.text.trim(),
                                        profileImgUrl: fileImgUrl);
                                    modalSetState(() {
                                      isLoading = true;
                                    });
                                  } else {
                                    fullNameEmpty(
                                        "Please enter your full name");
                                  }
                                },
                                child: Container(
                                  height: 56,
                                  width: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.teal,
                                  ),
                                  child: Center(
                                    child: isLoading
                                        ? CircularProgressIndicator(
                                            backgroundColor: Colors.white)
                                        : Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: Colors.white,
                                            size: 26.0,
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void insertUserData(String name, {required String profileImgUrl}) async {
    String imgUr = "";
    if (uploadImageToServer) {
      imgUr = await uploadToServer(profileImgUrl);
    }

    var firebaseAuth;
    User user = await firebaseAuth.currentUser;
    if (user != null) {
      // UserUpdateInfo updateInfo = UserUpdateInfo();
      // updateInfo.displayName = name;
      // updateInfo.photoUrl = imgUr ?? '';
      firebaseAuth.currentUser
          .updateProfile(displayName: name, photoURL: imgUrl);
      user.updateProfile(displayName: name, photoURL: imgUrl).then((value) {
        // FireQuery.createOrUpdatedUser(
        //   imgUrl: imgUr,
        //   name: name,
        // );

        // FireQuery.updateProfileImgInChatRooms(imgUr);
      }).catchError((error) {});
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context, true);
      if (Navigator.canPop(context)) {
        Navigator.pop(context, true);
      }
    }
  }

  void fullNameEmpty(String toastMessage) {
    Fluttertoast.showToast(
      msg: toastMessage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: Colors.teal,
      fontSize: 16.0,
    );
  }

  Future<String> uploadToServer(String imgUrl) async {
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('chat_images/$imgUrl')
        .putFile(File(imgUrl));
    String photoUrl = await snapshot.ref.getDownloadURL();

    print('File Uploaded');
    return await snapshot.ref.getDownloadURL();
  }
}
