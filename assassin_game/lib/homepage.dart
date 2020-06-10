import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'user.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User user = User();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user.update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: user.isAlive() ? Colors.green : Colors.red,
              width: 8,
            ),
            borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              user.isAlive()
                  ? Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                      size: 60,
                    )
                  : Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                      size: 60,
                    ),
              Text(
                user.isAlive() ? 'Alive' : 'Eliminated',
                style: Theme.of(context).textTheme.display2,
              ),
              user.isAlive()
                  ? RaisedButton(
                      color: Colors.red,
                      disabledColor: Colors.blueGrey[800],
                      child: Text("Target Eliminated"),
                      onPressed: () {
                        setState(() {
                          user.eliminateTarget();
                        });
                      },
                    )
                  : Container(),
              RaisedButton(
                color: Colors.black38,
                disabledColor: Colors.blueGrey[800],
                child: Text("View More Details"),
                onPressed: () {

                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
