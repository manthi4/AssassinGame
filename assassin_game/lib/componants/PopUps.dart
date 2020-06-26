import 'package:flutter/material.dart';
import 'package:assassingame/user.dart';

class PopUps {
  static CreateGame(
      {BuildContext context, @required updateGameID, statusColor}) {
    return showDialog(
        context: context,
        builder: (context) {
          return addGamePopUp(
            updateGameID: updateGameID,
            create: true,
            statusColor: statusColor,
          );
        });
  }

  static JoinGame({BuildContext context, @required updateGameID, statusColor}) {
    return showDialog(
        context: context,
        builder: (context) {
          return addGamePopUp(
            updateGameID: updateGameID,
            create: false,
            statusColor: statusColor,
          );
        });
  }
}

class addGamePopUp extends StatefulWidget {
  final updateGameID;
  final Color statusColor;
  final bool create;
  addGamePopUp({
    @required this.updateGameID,
    @required this.create,
    this.statusColor = Colors.purple,
  });

  @override
  _addGamePopUpState createState() => _addGamePopUpState();
}

class _addGamePopUpState extends State<addGamePopUp> {
  String Userinput = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.create ? "Create Game" : "Join Game"),
      content: TextField(
        onChanged: (value) {
          Userinput = value;
        },
        decoration: InputDecoration(
          hintText: widget.create ? 'New Game Name' : 'Game ID',
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        ),
      ),
      actions: <Widget>[
        RaisedButton(
          color: widget.statusColor,
          child: Text(widget.create ? "Create" : "Join"),
          onPressed: widget.create
              ? () async {
                  if (Userinput != "") {
                    String id = await User.createNewGame(gameName: Userinput);
                    widget.updateGameID(id);
                  } else {
                    print("Cant be left blank");
                  }
                }
              : () async {
                  if (Userinput != "") {
                    String GameName = await User.joinGame(gameID: Userinput);
                    if (GameName != "") {
                      widget.updateGameID(Userinput);
                    } else {
                      print("Could not join");
                    }
                  } else {
                    print("Need to enter ID!");
                  }
                },
        ),
      ],
    );
  }
}
