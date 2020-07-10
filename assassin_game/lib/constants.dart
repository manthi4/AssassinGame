import 'package:flutter/material.dart';
import 'user.dart';

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
ShapeBorder roundyBox = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)));

BoxDecoration getBorder(Color color) {
  return BoxDecoration(
      border: Border.all(
        color: color,
        width: 8,
      ),
      borderRadius: BorderRadius.circular(10));
}
Color defaultcolor = Colors.purple;
Color statuscolor(bool alive){
  return alive? Colors.green:Colors.red;
}

Widget getFace({bool alive, size = 60.0}){
  return alive ? Icon(
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