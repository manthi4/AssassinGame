import 'package:flutter/material.dart';
import 'package:assassingame/user.dart';
import 'CreateGameComponent.dart';

class SelectGamePagelet extends StatelessWidget {
  final updateGameID;
  final statusColor;
  SelectGamePagelet({@required this.updateGameID, this.statusColor = Colors.purple});

  List<Widget> getGameList() {
    return User.getGameNames().map((e){
      return ListTile(
        leading: Icon(Icons.games),
        title: Text(e),
        onTap: (){
          updateGameID(User.getGameID(gameName: e));
        },
      );
    }).toList();
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
              Text("Select a Game:", style: TextStyle(fontSize: 20),),
              SizedBox(height: 20,),
              gamesWidgetList.isNotEmpty
                  ? Flexible(
                child: ListView(
                  children: gamesWidgetList,
                ),
              )
                  : Text("You are not part of any games yet"),
              CreateGameComp(updateGameID: updateGameID, statusColor: statusColor,),
            ],
          ),
        ),
      ),
    );
  }
}



