import 'package:flutter/material.dart';
import 'package:assassingame/user.dart';

class CreateGameComp extends StatefulWidget {
  final updateGameID;
  final statusColor;
  CreateGameComp(
      {@required this.updateGameID, this.statusColor = Colors.purple});

  @override
  _CreateGameCompState createState() => _CreateGameCompState();
}

class _CreateGameCompState extends State<CreateGameComp> {
  String newGameName = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              onChanged: (value) {
                newGameName = value;
              },
              decoration: InputDecoration(
                hintText: 'New Game Name',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(foregroundColor: widget.statusColor),
            child: Text("Create"),
            onPressed: () async {
              if (newGameName != "") {
                String id = await User.createNewGame(gameName: newGameName);
                widget.updateGameID(id);
              } else {
                print("Need to Name your game!");
              }
            },
          ),
        ],
      ),
    );
  }
}
