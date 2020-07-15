import 'package:flutter/material.dart';
import 'package:assassingame/constants.dart';
import 'package:assassingame/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class clarifyname extends StatelessWidget {
  final bool alive;
  final updateGameID;
  final DocumentSnapshot gameData;
  const clarifyname(
      {@required this.alive,
      @required this.updateGameID,
      @required this.gameData});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
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
                        "Current game: ",
                      ),
                      DropdownButton(
                        value: gameData.data["GameName"],
                        icon: Icon(Icons.arrow_drop_down),
                        onChanged: (newValue) async {
                          String newID = User.getGameID(gameName: newValue);
                          await updateGameID(newID);
                        },
                        items: User.getGameNames().map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: TargetBox(gameData: gameData),
            ),
          ),
        ],
      ),
    );
  }
}

class TargetBox extends StatelessWidget {
  final DocumentSnapshot gameData;
  TargetBox({@required this.gameData});

  String displayText(String name, bool gameStarted, bool owner) {
    if (!gameStarted) {
      if (owner) {
        return "Start Game";
      } else {
        return "Game not started";
      }
    } else {
      return "Target: ${name}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: User.playerDocStreamCreator(gameID: gameData.documentID),
      builder: (context, snapshot) {
        bool gameStarted = (snapshot.data.data["Targetname"] != "");
        bool owner = (gameData.data["GameCreator"] == User.userID());

        if (snapshot.data.exists) {
          ///If data doesn't exist the player is dead so nothing needs to display
          return RaisedButton(
            color: gameStarted ? Colors.green : Colors.orange,
            shape: gameStarted ? null : roundyBox,
            disabledColor: gameStarted ? Colors.green : Colors.orange,
            disabledTextColor: Colors.white,
            child: SizedBox(
              height: 50.0,
              width: 200.0,
              child: Center(
                child: Text(
                  displayText(
                      snapshot.data.data["Targetname"], gameStarted, owner),
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            onPressed: gameStarted
                ? null
                : owner
                    ? () async {
                        print("Starting game");
                        await User.startGame(gameID: gameData.documentID);
                      }
                    : null,
          );
        }
        return Container();
      },
    );
  }
}
