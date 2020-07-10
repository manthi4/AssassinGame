import 'package:flutter/material.dart';
import 'package:assassingame/constants.dart';
import 'package:assassingame/user.dart';


class clarifyname extends StatelessWidget {
  final bool alive;
  final updateGameID;
  final String GameName;
  const clarifyname({@required this.GameName, @required this.alive, @required this.updateGameID});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                "Current game:  $GameName",
              ),
              DropdownButton(
                value: GameName,
                icon: Icon(Icons.arrow_drop_down),
                onChanged: (newValue) async{
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

//          Container(
//            height: 100,
//            color: Colors.yellow,
//            child: ListView(
//                children: <Widget>[
//
//                  Material(
//                    elevation: 5.0,
//                    color: Colors.brown,
//                    borderRadius: BorderRadius.circular(30.0),
//                    child: MaterialButton(
//
//                      child: Text("hi", style: TextStyle(color: Colors.white),),
//                      height: 42.0,
//                    ),
//                  ),
//                  Material(
//                    elevation: 5.0,
//                    color: statuscolor(alive),
//                    borderRadius: BorderRadius.circular(30.0),
//                    child: MaterialButton(
//
//                      child: Text("hi", style: TextStyle(color: Colors.white),),
//                      height: 42.0,
//                    ),
//                  )
//
//                ],
//            ),
//          ),

        ],
      ),
    );
  }
}

