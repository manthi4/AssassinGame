import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assassingame/user.dart';
import 'CreateGameComponent.dart';
import 'JoinGameComponent.dart';

class SelectGamePagelet extends StatelessWidget {
  final updateGameID;
  final statusColor;
  SelectGamePagelet(
      {@required this.updateGameID, this.statusColor = Colors.purple});

  List<Widget> getGameList() {
    List<Widget> Glist = [];
    User.getGames().forEach((key, value) {
      Glist.add(ListTile(
        leading: Icon(Icons.games),
        title: Text(value),
        onTap: () {
          updateGameID(key);
        },
      ));
    });
    return Glist;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> gamesWidgetList = getGameList();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Select a Game:",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              gamesWidgetList.isNotEmpty
                  ? Flexible(
                      child: ListView(
                        children: gamesWidgetList,
                      ),
                    )
                  : Text(
                      "You are not part of any games yet. Create a new game or join a game."),
              SizedBox(
                height: 20,
              ),
              CreateGameComp(
                updateGameID: updateGameID,
                statusColor: statusColor,
              ),
              SizedBox(
                height: 20,
              ),
              JoinGameComp(
                updateGameID: updateGameID,
                statusColor: statusColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
