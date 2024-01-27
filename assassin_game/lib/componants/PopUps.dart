import 'package:flutter/material.dart';
import 'package:assassingame/user.dart';
import 'package:assassingame/constants.dart';

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
  ///TODO: if the user makes a mistake (ex: blank name) show a hint in red text.
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
  String errorText;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: roundyBox,
      title: Text(widget.create ? "Create Game" : "Join Game"),
      content: TextField(
        onChanged: (value) {
          Userinput = value;
        },
        decoration: TextFieldDecor.copyWith(
          hintText: widget.create ? 'New Game Name' : 'Game ID',
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
              // color: widget.statusColor,
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))))),
          // color: widget.statusColor,
          // shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(widget.create ? "Create" : "Join"),
          onPressed: widget.create
              ? () async {
                  if (Userinput != "") {
                    String id = await User.createNewGame(gameName: Userinput);
                    widget.updateGameID(id);
                    Navigator.of(context).pop();
                  } else {
                    print("Cant be left blank");
                    setState(() {
                      errorText = "Can not be blank";
                    });
                  }
                }
              : () async {
                  if (Userinput != "") {
                    String GameName = await User.joinGame(gameID: Userinput);
                    if (GameName != "") {
                      widget.updateGameID(Userinput);
                      Navigator.of(context).pop();
                    } else {
                      print("Could not join");
                      setState(() {
                        errorText = "Could not join, check ID";
                      });
                    }
                  } else {
                    print("Need to enter ID!");
                    setState(() {
                      errorText = "Need to enter ID!";
                    });
                  }
                },
        ),
      ],
    );
  }
}
