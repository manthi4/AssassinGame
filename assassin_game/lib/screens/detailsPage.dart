import 'package:flutter/material.dart';
import '../user.dart';
import '../constants.dart';

class Details extends StatelessWidget {
  final user = User();
  static String route = 'details';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Hero(
                tag: 'face',
                child: getFace(alive: true),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(User.userName(), style: TextStyle(fontSize: 40),),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
