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
                    style: Theme.of(context).textTheme.headline2,
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

  Widget displayText(String name, bool gameStarted, bool owner) {
    String words = "Target: ${name}";
    if (!gameStarted) {
      if (owner) {
        words = "Start Game";
      } else {
        words = "Game not started";
      }
    }
    return Text(
      words,
      style: TextStyle(
          fontSize: 20,
          color: gameStarted
              ? Colors.green
              : owner ? Colors.green : Colors.grey[700]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: User.playerDocStreamCreator(gameID: gameData.documentID),
      builder: (context, snapshot) {
        if (!snapshot.data.exists) {
          return Container();
        }
        bool gameStarted = (snapshot.data.data["Targetname"] != "");
        bool owner = (gameData.data["GameCreator"] == User.userID());

        if (snapshot.data.exists) {
          ///If data doesn't exist the player is dead so nothing needs to display
          return RaisedButton(
            color: Colors.grey[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(
                  color: gameStarted ? Colors.green : Colors.grey[700]),
            ),
            disabledColor: Colors.grey[900],
            disabledTextColor: Colors.white,
            child: SizedBox(
              height: 50.0,
              width: 200.0,
              child: Center(
                  child: displayText(
                      snapshot.data.data["Targetname"], gameStarted, owner)),
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
