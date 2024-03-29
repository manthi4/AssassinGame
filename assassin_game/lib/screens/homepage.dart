import 'dart:io';

import 'package:assassingame/screens/UserPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../user.dart';
import '../constants.dart';
import 'detailsPage.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:assassingame/componants/SelectGamePagelet.dart';
import 'package:assassingame/componants/PopUps.dart';
import 'primary.dart';
import 'GamesPage.dart';

class HomePage extends StatefulWidget {
  static String route = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  PickedFile file;
  StorageReference storageRef = FirebaseStorage.instance.ref();
  String selectedGameID = "";
  bool labelsOn = true;

  Future<void> grabGameID() async {
    String ID = await User.getSelectedGameID();
    if (ID != "") {
      setState(() {
        selectedGameID = ID;
      });
    }
  }

  Future<void> updateGameID(String ID) async {
    if (ID != "") {
      await User.setSelectedGameID(gameID: ID);
      setState(() {
        selectedGameID = ID;

        ///TODO: possible code compression
      });
    } else {
      print("Invalid, blank ID passed into updateGameID");
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
            ///TODO: to make it more robust, if somehow the app starts with an invalid GameID, then send them to the game picking screen
//          if (!snapshot.data.exists & ) {
//            return Center(
//              child: Text("Waiting for connection"),
//            );
//          }

            bool alive =
                snapshot.data.get("PlayerStatus")[User.userName()]["Alive"];
            // snapshot.data.data["PlayerStatus"][User.userName()]["Alive"];
            Color statusColor = statuscolor(alive);

            ///            PickedFile file; ///Made this a State variable instead
            return Scaffold(
              backgroundColor: Colors.grey[900],
              body: SlidingUpPanel(
                ///TODO: see if DraggableScrollableSheet is better here
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
                                  icon: Icon(Icons.cloud_upload),
                                  tooltip: "Upload File",
                                  splashColor: Colors.white,
                                  onPressed: () async {
                                    file = await _picker.getVideo(
                                        source: ImageSource.gallery);
                                    StorageUploadTask uploadTask =
                                        await storageRef
                                            .child("hello_worldo.mp4")
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
                                            User.eliminateTarget(
                                                gameID: selectedGameID);
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
                                  icon: Icon(Icons.person),
                                  tooltip: "Profile",
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, UserPage.route);
                                  }),
                              labelsOn
                                  ? Text(
                                      "Profile",
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
                        ],
                      ),
                    ],
                  ),
                ),

                ///This is the actual background screen part
                body: Container(
                  decoration: getBorder(statuscolor(alive)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: PageView(
                        controller: PageController(
                          initialPage: 1,
                        ),
                        children: [
                          GamesPage(
                            updateGameID: updateGameID,
                            GameName: snapshot.data.data["GameName"],
                            alive: alive,
                          ),
                          clarifyname(
                            alive: alive,
                            updateGameID: updateGameID,
                            gameData: snapshot.data,
                          ),
                          Details(
                            gamedata: snapshot.data.data,
                          ),
                        ]),
                  ),
                ),
              ),
            );
          });
    }
  }
}
