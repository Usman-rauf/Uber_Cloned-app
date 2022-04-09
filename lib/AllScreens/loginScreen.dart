// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_rider_app/AllScreens/mainscreen.dart';
import 'package:uber_rider_app/AllScreens/registrationScreen.dart';
import 'package:uber_rider_app/AllWidgets/progressdialogue.dart';
import 'package:uber_rider_app/main.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "Login";
  TextEditingController emailcontroller = TextEditingController();
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
                    SizedBox(height: 1),
                    Text(
                      "Login as a Rider",
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
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
                        } else if (passwordcontroller.text.isEmpty) {
                          displayToastMessage("Password is mandatory", context);
                        } else {
                          loginAuthenticateUser(context);
                        }
                      },
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        child: Center(
                          child: Text(
                            "Login",
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
                    Navigator.pushNamedAndRemoveUntil(context,
                        RegistrationSccreen.idScreen, (route) => false);
                  },
                  child: Text("Do you have an Account? Register Here"))
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  void loginAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialogue("Authenticating, Please wait......");
        });
    final User firebaseUser = (await _firebaseauth
            .signInWithEmailAndPassword(
                email: emailcontroller.text, password: passwordcontroller.text)
            .catchError((errmsg) {
      Navigator.pop(context);
      displayToastMessage("Error:" + errmsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      userRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.idScreen, (route) => false);
          displayToastMessage("you are logged-in now", context);
        } else {
          Navigator.pop(context);
          _firebaseauth.signOut();
          displayToastMessage("No record found", context);
        }
      });
    } else {
      Navigator.pop(context);
      displayToastMessage("Error occured", context);
    }
  }

  displayToastMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
