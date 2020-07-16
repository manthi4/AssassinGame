import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assassingame/user.dart';
import 'package:assassingame/constants.dart';
import 'welcomPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:assassingame/constants.dart';

class UserPage extends StatefulWidget {
  static final String route = "UserPage";
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Color statusColor = defaultcolor;
  var _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: getBorder(statusColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.person,
                        color: statusColor,
                        size: 100,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 1,
                        ),
//                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.exit_to_app,
                          color: statusColor,
                        ),
                        title: Text("Log out"),
                        onTap: () {
                          _auth.signOut();
                          Navigator.popUntil(
                              context, ModalRoute.withName(WelcomePage.route));
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 1,
                        ),
//                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.security,
                          color: statusColor,
                        ),
                        title: Text("Reset Password"),
                        onTap: () {},
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                          width: 1,
                        ),
//                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.photo,
                          color: statusColor,
                        ),
                        title: Text("Change Profile Picture"),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ),

//              Column(
//                children: <Widget>[
//                  IconButton(
//                    iconSize: 30,
//                    color: statusColor,
//                    icon: Icon(Icons.exit_to_app),
//                    tooltip: "Log out",
//                    onPressed: () {
//                      _auth.signOut();
//                      Navigator.popUntil(
//                          context, ModalRoute.withName(WelcomePage.route));
//                    },
//                  ),
//                  Text(
//                    "Log out",
//                    style: TextStyle(color: Colors.grey[700]),
//                  )
//                ],
//              ),

              RaisedButton(
                child: SizedBox(
                  width: double.maxFinite,
                  height: 60.0,
                  child: Center(
                    child: Text("GO BACK"),
                  ),
                ),
                color: Colors.blue,
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
