import 'package:assassingame/constants.dart';
import 'package:flutter/material.dart';
import 'package:assassingame/user.dart';

class GamesPage extends StatelessWidget {
  final updateGameID;
  final GameName;
  final bool alive;
  const GamesPage(
      {@required this.updateGameID, @required this.GameName, this.alive});

  List<Widget> getGameTiles({bool active}) {
    ///TODO: I wonder, would making this async be faster
    List<Widget> Tiles = [];

    User.getGames().forEach((key, value) {
      if (value["Active"] == active) {
        Tiles.add(
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              side: BorderSide(
                  color: (value["GameName"] == GameName)
                      ? statuscolor(value["Alive"])
                      : Colors.black54),
            ),
            color: Colors.black54,
            //(value["GameName"] == GameName) ? statuscolor(value["Alive"]): Colors.black, //Colors.blueGrey[900],
            child: ListTile(
              leading: Icon(Icons.games),
              title: Text(
                value["GameName"],
              ),
              trailing: getFace(alive: value["Alive"], size: 20.0),
              enabled: value["Active"],
              selected: value["Owner"] ? true : false,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: cardListBlock(
                  title: "Active Games: ",
                  children: getGameTiles(active: true)),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 1,
              child: cardListBlock(
                  title: "Inactive Games: ",
                  children: getGameTiles(active: false)),
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
