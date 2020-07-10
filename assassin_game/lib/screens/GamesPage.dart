import 'package:assassingame/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GamesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text("Somethn"),
          ),
          Card(
            margin: EdgeInsets.all(20),
            shape: roundyBox,
            child: ListView(
              shrinkWrap: true,


              children: <Widget>[
                Material(
                  elevation: 5.0,
                  color: Colors.brown,
                  child: MaterialButton(

                    child: Text("hi", style: TextStyle(color: Colors.white),),
                    height: 42.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
