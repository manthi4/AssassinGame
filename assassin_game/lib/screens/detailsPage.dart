import 'package:flutter/material.dart';
import '../user.dart';
import '../constants.dart';

class Details extends StatelessWidget {
  static String route = 'details';
  final Map gamedata;
  Details({@required this.gamedata});

  List<Widget> getPlayerTiles({bool alive}) {
    ///TODO: I wonder, would making this async be faster
    List<Widget> Tiles = [];

    Map<String, dynamic> players = gamedata["PlayerStatus"];
    players.forEach((key, value) {
      if (value["Alive"] == alive) {
        Tiles.add(Card(
          color: Colors.deepOrange,
          child: ListTile(
            leading: Icon(Icons.person_outline),
            title: Text(key),
            subtitle: Text("Eliminations: ${value["kills"]}"),
            trailing: getFace(alive: value["Alive"], size: 20.0),
            selected: (key == User.userName()) ? true : false,
          ),
        ));
      }
    });
    return Tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      gamedata["GameName"],
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text("Some Game stats can go here"),
            ),
          ),
          Expanded(
            flex: 4,
            child: cardListBlock(
              title: "The living",
              children:
                  getPlayerTiles(alive: true) + getPlayerTiles(alive: false),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
