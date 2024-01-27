import 'package:flutter/material.dart';
import 'package:assassingame/user.dart';

class JoinGameComp extends StatefulWidget {
  final updateGameID;
  final statusColor;
  JoinGameComp({@required this.updateGameID, this.statusColor = Colors.purple});

  @override
  _JoinGameCompState createState() => _JoinGameCompState();
}

class _JoinGameCompState extends State<JoinGameComp> {
  String newGameID = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              onChanged: (value) {
                newGameID = value;
              },
              decoration: InputDecoration(
                hintText: 'Game ID',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(foregroundColor: widget.statusColor),
            child: Text("Join"),
            onPressed: () async {
              if (newGameID != "") {
                String GameName = await User.joinGame(gameID: newGameID);
                if (GameName != "") {
                  widget.updateGameID(newGameID);
                } else {
                  print("Could not join");
                }
              } else {
                print("Need to enter ID!");
              }
            },
          ),
        ],
      ),
    );
  }
}
