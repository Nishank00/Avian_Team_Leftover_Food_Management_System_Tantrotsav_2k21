import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

import 'config.dart';
import 'homepage.dart';

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

  late FocusNode focusNodePin;

  static final int _pinLength = 4;

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

  late String strPhone = '';

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
      hintText: '****',
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
                                  'Enter the OTP sent to 91 - 123456789',
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
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                print("");
                                              }),
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
                              setState(() {
                                currentViewIsOtpPage = !currentViewIsOtpPage;
                              });
                            },
                            onLongPress: () {
                              if (currentViewIsOtpPage) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()),
                                    (route) => false);
                              }
                            },
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
                                  currentViewIsOtpPage ? "Send OTP" : "Submit",
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
}
