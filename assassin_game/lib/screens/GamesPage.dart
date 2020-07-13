import 'package:assassingame/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assassingame/user.dart';

class GamesPage extends StatelessWidget {
  final updateGameID;
  final GameName;
  const GamesPage({@required this.updateGameID, @required this.GameName});

  List<Widget> getGameTiles({bool active}) {
    ///TODO: I wonder, would making this async be faster
    List<Widget> Tiles = [];

    User.getGames().forEach((key, value) {
      if (value["Active"] == active) {
        Tiles.add(
          Card(
            color: value["Owner"] ? Colors.yellow[700] : Colors.blueGrey[900],
            child: ListTile(
              leading: Icon(Icons.games),
              title: Text(value["GameName"]),
              trailing: getFace(alive: value["Alive"], size: 20.0),
              enabled: value["Active"],
              selected: (value["GameName"] == GameName) ? true : false,
              onTap: () {
                updateGameID(key);
              },
            ),
          ),
        );
      }
    });
    return Tiles;
  }

  Widget gameBlock({String title, bool active}) {
    return Card(
      margin: EdgeInsets.symmetric(
          horizontal: 8.0), //EdgeInsets.symmetric(horizontal: 8.0)
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0.0),
              children: getGameTiles(active: active),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: gameBlock(title: "Active Games: ", active: true),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 1,
              child: gameBlock(title: "Inactive Games: ", active: false),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
