import 'package:flutter/material.dart';

//class StatusBorder {
//  BoxDecoration getBorder() {
//    return BoxDecoration(
//        border: Border.all(
//          color: Colors.blue,
//          width: 8,
//        ),
//        borderRadius: BorderRadius.circular(10));
//  }
//}

const TextFieldDecor = InputDecoration(
  hintText: 'Password',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
);

const roundyBox = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(20),
  ),
);

BoxDecoration getBorder(Color color) {
  return BoxDecoration(
      border: Border.all(
        color: color,
        width: 8,
      ),
      borderRadius: BorderRadius.circular(10));
}

Color defaultcolor = Colors.purple;

Color statuscolor(bool alive) {
  return alive ? Colors.green : Colors.red;
}

Widget getFace({bool alive, size = 80.0}) {
  return alive
      ? Icon(
          Icons.sentiment_very_satisfied,
          color: statuscolor(alive),
          size: size,
        )
      : Icon(
          Icons.sentiment_very_dissatisfied,
          color: statuscolor(alive),
          size: size,
        );
}

Widget cardListBlock(
    {String title, List<Widget> children, Color color = Colors.black45}) {
  return Card(
    color: color,
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
            children: children,
          ),
        ),
      ],
    ),
  );
}
