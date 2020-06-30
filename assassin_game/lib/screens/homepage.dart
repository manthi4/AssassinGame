import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../user.dart';
import '../constants.dart';
import 'detailsPage.dart';
import 'welcomPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:assassingame/componants/SelectGamePagelet.dart';
import 'package:assassingame/componants/CreateGameComponent.dart';
import 'package:assassingame/componants/PopUps.dart';
import 'package:assassingame/componants/JoinGameComponent.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  static String route = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  StorageReference storageRef = FirebaseStorage.instance.ref();
  var loggedInUser;
  Color statusColor = Colors.blue;
  String selectedGameID = "";
  bool labelsOn = true;
//  String selectedGameName;

  Future<void> grabGameID() async {
    String ID = await User.getSelectedGameID();
    if (ID != "") {
      setState(() {
        selectedGameID = ID;
      });
    }
  }

  Future<void> updateGameID(ID) async {
    if (ID != "") {
      await User.setSelectedGameID(gameID: ID);
      setState(() {
        selectedGameID = ID;
      });
    } else {
      print("Invalid, blank ID passes into updateGameID");
    }
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
      return SelectGamePagelet(updateGameID: updateGameID);
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

            PickedFile file;
            return Scaffold(
              body: SlidingUpPanel(
                color: Colors.black,
                minHeight: 30,
                maxHeight: 180,
                margin: EdgeInsets.symmetric(horizontal: 8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
                collapsed: Container(
                  /// This is the part when its down
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Center(
                      child: Icon(
                    Icons.arrow_drop_up,
                    size: 25,
                  )),
                ),
                panel: Center(
                  /// This is the part when it slides up
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.drag_handle),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              IconButton(
                                  iconSize: 30,
                                  color: statusColor,
                                  icon: Icon(Icons.list),
                                  tooltip: "Games",
                                  onPressed: () {
                                    print("More Details");
                                    Navigator.pushNamed(context, Details.route);
                                  }),
                              labelsOn
                                  ? Text(
                                      "Games",
                                      style: TextStyle(color: Colors.grey[700]),
                                    )
                                  : Container()
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              IconButton(
                                  iconSize: 40,
                                  color: Colors.red,
                                  icon: Icon(Icons.gps_fixed),
                                  tooltip: "Eliminate Target",
                                  onPressed: alive
                                      ? () {
                                          print("target eliminated");
                                          setState(() {
                                            User.eliminateTarget();
                                          });
                                        }
                                      : null),
                              labelsOn
                                  ? Text(
                                      "Eliminate Target",
                                      style: TextStyle(color: Colors.grey[700]),
                                    )
                                  : Container()
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              IconButton(
                                  iconSize: 30,
                                  color: statusColor,
                                  icon: Icon(Icons.exit_to_app),
                                  tooltip: "Log out",
                                  onPressed: () {
                                    _auth.signOut();
                                    Navigator.popUntil(context,
                                        ModalRoute.withName(WelcomePage.route));
                                  }),
                              labelsOn
                                  ? Text(
                                      "Log out",
                                      style: TextStyle(color: Colors.grey[700]),
                                    )
                                  : Container()
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              IconButton(
                                  iconSize: 30,
                                  color: statusColor,
                                  icon: Icon(Icons.add),
                                  tooltip: "Create Game",
                                  onPressed: () {
                                    PopUps.CreateGame(
                                        context: context,
                                        updateGameID: updateGameID,
                                        statusColor: statusColor);
                                  }),
                              labelsOn
                                  ? Text(
                                      "Create Game",
                                      style: TextStyle(color: Colors.grey[700]),
                                    )
                                  : Container(),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              IconButton(
                                  iconSize: 30,
                                  color: statusColor,
                                  icon: Icon(Icons.eject),
                                  tooltip: "Join Game",
                                  onPressed: () {
                                    PopUps.JoinGame(
                                        context: context,
                                        updateGameID: updateGameID,
                                        statusColor: statusColor);
                                  }),
                              labelsOn
                                  ? Text(
                                      "Join Game",
                                      style: TextStyle(color: Colors.grey[700]),
                                    )
                                  : Container(),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              IconButton(
                                  iconSize: 30,
                                  color: statusColor,
                                  icon: Icon(Icons.cloud_upload),
                                  tooltip: "Upload File",
                                  splashColor: Colors.white,
                                  onPressed: () async {
                                    file = await _picker.getVideo(
                                        source: ImageSource.gallery);
                                    storageRef;
                                    StorageUploadTask uploadTask =
                                        await storageRef
                                            .child("hello_world.mp4")
                                            .putFile(
                                                File(file.path),
                                                StorageMetadata(
                                                    contentType: "type/mp4"));
                                  }),
                              labelsOn
                                  ? Text(
                                      "Upload File",
                                      style: TextStyle(color: Colors.grey[700]),
                                    )
                                  : Container(),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                body: Container(
                  /// The part on the actual screen
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
                          alive ? 'Alive' : 'Eliminated',
                          style: Theme.of(context).textTheme.display2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Current game: ${snapshot.data.data["GameName"]} ",
                            ),
                            DropdownButton(
                              icon: Icon(Icons.arrow_drop_down),
                              onChanged: (newValue) {
                                updateGameID(
                                    User.getGameID(gameName: newValue));
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
