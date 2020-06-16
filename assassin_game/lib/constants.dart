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

BoxDecoration getBorder(Color color) {
  return BoxDecoration(
      border: Border.all(
        color: color,
        width: 8,
      ),
      borderRadius: BorderRadius.circular(10));
}

Widget getFace({bool alive, size = 60.0}){
  return alive ? Icon(
    Icons.sentiment_very_satisfied,
    color: Colors.green,
    size: size,
  )
      : Icon(
    Icons.sentiment_very_dissatisfied,
    color: Colors.red,
    size: size,
  );
}