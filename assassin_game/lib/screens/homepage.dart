import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../user.dart';
import '../constants.dart';
import 'detailsPage.dart';
import 'welcomPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  static String route = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _auth = FirebaseAuth.instance;
  var loggedInUser;
  User user = User();
  Color statusColor = Colors.white;

  void printCurrentU() async {
    loggedInUser = await _auth.currentUser();
    print(loggedInUser.email);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    printCurrentU();
    user.update();
    statusColor = user.isAlive() ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        color: Colors.black,
        minHeight: 50,
        maxHeight: 200,
        margin: EdgeInsets.symmetric(horizontal: 8),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        collapsed: Container(
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Center( child:Icon(Icons.arrow_drop_up, size: 50,)),
        ),
        panel: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.drag_handle),
              ),
              user.isAlive()
                  ? RaisedButton(
                      color: Colors.red,
                      disabledColor: Colors.blueGrey[800],
                      child: Text("Target Eliminated"),
                      onPressed: () {
                        print("target eliminated");
                        setState(() {
                          user.eliminateTarget();
                          statusColor = Colors.red;
//                              user.isAlive() ? Colors.green : Colors.red;
                        });
                      },
                    )
                  : Container(),
              RaisedButton(
                color: statusColor,
                disabledColor: Colors.blueGrey[800],
                child: Text("View More Details"),
                onPressed: () {
                  print("More Details");
                  Navigator.pushNamed(context, Details.route);
                },
              ),
              RaisedButton(
                color: statusColor,
                disabledColor: Colors.blueGrey[800],
                child: Text("Log out"),
                onPressed: () {
                  _auth.signOut();
                  Navigator.popUntil(
                      context, ModalRoute.withName(WelcomePage.route));
                },
              ),
            ],
          ),
        ),
        body: Container(
          decoration: getBorder(statusColor),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'face',
                  child: getFace(alive: user.isAlive()),
                ),
                Text(
                  user.isAlive() ? 'Alive' : 'Eliminated',
                  style: Theme.of(context).textTheme.display2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
