// ignore_for_file: deprecated_member_use

// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_rider_app/AllScreens/loginScreen.dart';
import 'package:uber_rider_app/AllScreens/mainscreen.dart';
import 'package:uber_rider_app/AllWidgets/progressdialogue.dart';
import 'package:uber_rider_app/main.dart';

class RegistrationSccreen extends StatelessWidget {
  static const String idScreen = "register";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 45,
              ),
              Image(
                image: AssetImage("images/logo.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Register as Rider",
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    TextField(
                      controller: namecontroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 1),
                    TextField(
                      controller: phonecontroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 1),
                    TextField(
                      controller: emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    TextField(
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      onPressed: () {
                        if (!emailcontroller.text.contains('@')) {
                          displayToastMessage(
                              'Email address is not valid', context);
                        } else if (phonecontroller.text.isEmpty) {
                          displayToastMessage(
                              "Phonne Number is not valid", context);
                        } else if (passwordcontroller.text.length < 7) {
                          displayToastMessage(
                              "Passowrd must be atleast 6 character", context);
                        } else {
                          registerNewUser(context);
                        }
                      },
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        child: Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(24)),
                    ),
                  ],
                ),
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                  },
                  child: Text("Already have an account? Login Here"))
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialogue("Registering, Please wait......");
        });
    //fucntion  for register user
    final User firebaseUser = (await _firebaseauth
            .createUserWithEmailAndPassword(
                email: emailcontroller.text, password: passwordcontroller.text)
            .catchError((errmsg) {
      Navigator.pop(context);
      displayToastMessage("Error:" + errmsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      //saving user into database
      Map userDataMap = {
        "name": namecontroller.text.trim(),
        "email": emailcontroller.text.trim(),
        "phone": phonecontroller.text.trim(),
      };
      userRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Account has been created", context);
      Navigator.pushNamedAndRemoveUntil(
          context, MainScreen.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      displayToastMessage("New User has Not Created", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
