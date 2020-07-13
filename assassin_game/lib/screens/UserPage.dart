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
              Column(
                children: <Widget>[

                  IconButton(
                      iconSize: 30,
                      color: statusColor,
                      icon: Icon(Icons.exit_to_app),
                      tooltip: "Log out",
                      onPressed: () {
                        _auth.signOut();
                        Navigator.popUntil(
                            context,
                            ModalRoute.withName(
                                WelcomePage.route));
                      }),
                 Text(
                    "Log out",
                    style:
                    TextStyle(color: Colors.grey[700]),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
