import 'package:cloud_firestore/cloud_firestore.dart';
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
  Color statusColor = Colors.blue;
  String selectedGameID = "";
  String newGameName = "";

  void grabGameID() async {
    String ID = await User.getSelectedGameID();
    if(ID != "") {
      setState(() {
        selectedGameID = ID;
      });
    }
  }

  void newGameID(ID) async {
    await User.setSelectedGameID(gameID: ID);
    setState(() {
      selectedGameID = ID;
    });
  }


  List<Widget> getGameList() {
    List<Widget> widgetList;
    widgetList = User.getGameNames().map((e){
      return ListTile(
        leading: Icon(Icons.games),
        title: Text(e),
        onTap: (){
          newGameID(User.getGameID(gameName: e));
        },
      );
    }).toList();

    return widgetList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    User.initialize(); /// User should already be initialized before coming to this screen. Either directly on the welcome screen or on the login Screen if new User
    grabGameID();
  }

  @override
  Widget build(BuildContext context) {
    print('Selected Game ID dug from device: $selectedGameID ');
    if (selectedGameID == "") {
      List<Widget> gamesWidgetList = getGameList();

      return Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              gamesWidgetList.isNotEmpty
                  ? Flexible(
                    child: ListView(
                        children: gamesWidgetList,
                      ),
                  )
                  : Text("You are not part of any games yet"),
              TextField(
                onChanged: (value) {
                  newGameName = value;
                },
                decoration: InputDecoration(
                  hintText: 'New Game Name',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                ),
              ),
              RaisedButton(
                child: Text("Create"),
                onPressed: () async {
                  if (newGameName != "") {
                    String id = await User.createNewGame(gameName: newGameName);
                    newGameID(id);
                  } else {
                    print("Need to Name your game!");
                  }
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return StreamBuilder<DocumentSnapshot>(
          stream: User.gameDocStreamCreator(gameID: selectedGameID),
          builder: (context, snapshot) {
//          if (!snapshot.data.exists & ) {
//            return Center(
//              child: Text("Waiting for connection"),
//            );
//          }
            var dta = snapshot.data;
            bool alive =
                snapshot.data.data["PlayerStatus"][User.userName()]["Alive"];
            statusColor = alive ? Colors.green : Colors.red;

            return Scaffold(
              body: SlidingUpPanel(
                color: Colors.black,
                minHeight: 50,
                maxHeight: 400,
                margin: EdgeInsets.symmetric(horizontal: 8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                collapsed: Container(
                  /// This is the part when its down
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.arrow_drop_up,
                    size: 50,
                  )),
                ),
                panel: Center(
                  /// This is the part when it slides up
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.drag_handle),
                      ),
                      true
                          ? RaisedButton(
                              color: Colors.red,
                              disabledColor: Colors.blueGrey[800],
                              child: Text("Target Eliminated"),
                              onPressed: () {
                                print("target eliminated");
                                setState(() {
                                  User.eliminateTarget();
                                  statusColor = Colors.red;
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
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          newGameName = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'New Game Name',
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                      ),
                      RaisedButton(
                        child: Text("Create"),
                        onPressed: () async {
                          if (newGameName != "") {
                            String id =
                                await User.createNewGame(gameName: newGameName);
                            newGameID(id);
                          } else {
                            print("Need to Name your game!");
                          }
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
                          child: getFace(alive: alive),
                        ),
                        Text(
                          true ? 'Alive' : 'Eliminated',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Current game:  ",
                            ),
                            DropdownButton(
                              value: User.getGameName(gameID: selectedGameID),
                              icon: Icon(Icons.arrow_drop_down),
                              onChanged: (newValue) {
                                newGameID(User.getGameID(gameName: newValue));
                              },
                              items: User.getGameNames().map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
    }
  }
}
