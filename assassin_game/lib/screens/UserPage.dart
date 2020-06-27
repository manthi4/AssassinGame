import 'package:flutter/material.dart';
import 'package:assassingame/user.dart';
import 'package:assassingame/constants.dart';


class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Color statusColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: getBorder(statusColor),
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Log out"),
              onPressed: (){},
            ),
          ],
        ),
      ),
    );
  }
}
