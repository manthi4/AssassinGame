
import 'package:flutter/material.dart';
import 'package:assassingame/constants.dart';
import 'welcomPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    Widget LogoutWidget = Column(
      children: <Widget>[
        IconButton(
          iconSize: 30,
          color: statusColor,
          icon: Icon(Icons.exit_to_app),
          tooltip: "Log out",
          onPressed: () {
            _auth.signOut();
            Navigator.popUntil(context, ModalRoute.withName(WelcomePage.route));
          },
        ),
        Text(
          "Log out",
          style: TextStyle(color: Colors.white),
        )
      ],
    );
//    widget ResetPassword = Column(
//        children: <Widget>[
//        IconButton(
//        iconSize: 30,
//        color: statusColor,
//        icon: Icon(Icons.exit_to_app),
//    tooltip: "Log out",
//    onPressed: () {
//    _auth.signOut();
//    Navigator.popUntil(context, ModalRoute.withName(WelcomePage.route));
//    },
//    ),
//    Text(
//    "Log out",
//    style: TextStyle(color: Colors.white),
//    )
//    ],
//    );
    return Scaffold(
      body: Container(
        decoration: getBorder(statusColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.person,
                      color: statusColor,
                      size: 100,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      LogoutWidget,
                      LogoutWidget,
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      LogoutWidget,
                      LogoutWidget,
                      LogoutWidget,
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      LogoutWidget,
                      LogoutWidget,
                    ],
                  ),
                ],
              )
//                ListView(
//                  children: <Widget>[
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Icon(
//                        Icons.person,
//                        color: statusColor,
//                        size: 100,
//                      ),
//                    ),
//                    Container(
//                      decoration: BoxDecoration(
//                        border: Border.all(
//                          color: Colors.blue,
//                          width: 1,
//                        ),
////                        borderRadius: BorderRadius.circular(10),
//                      ),
//                      child: ListTile(
//                        leading: Icon(
//                          Icons.exit_to_app,
//                          color: statusColor,
//                        ),
//                        title: Text("Log out"),
//                        onTap: () {
//                          _auth.signOut();
//                          Navigator.popUntil(
//                              context, ModalRoute.withName(WelcomePage.route));
//                        },
//                      ),
//                    ),
//                    Container(
//                      decoration: BoxDecoration(
//                        border: Border.all(
//                          color: Colors.blue,
//                          width: 1,
//                        ),
////                        borderRadius: BorderRadius.circular(10),
//                      ),
//                      child: ListTile(
//                        leading: Icon(
//                          Icons.security,
//                          color: statusColor,
//                        ),
//                        title: Text("Reset Password"),
//                        onTap: () {},
//                      ),
//                    ),
//                    Container(
//                      decoration: BoxDecoration(
//                        border: Border.all(
//                          color: Colors.blue,
//                          width: 1,
//                        ),
////                        borderRadius: BorderRadius.circular(10),
//                      ),
//                      child: ListTile(
//                        leading: Icon(
//                          Icons.photo,
//                          color: statusColor,
//                        ),
//                        title: Text("Change Profile Picture"),
//                        onTap: () {},
//                      ),
//                    ),
//                  ],
//                ),
                  ),
              ElevatedButton(
                child: SizedBox(
                  width: double.maxFinite,
                  height: 60.0,
                  child: Center(
                    child: Text("GO BACK"),
                  ),
                ),
                style: ElevatedButton.styleFrom(foregroundColor: Colors.blue),
                // color: Colors.blue,
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
