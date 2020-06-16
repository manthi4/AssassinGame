import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final String buttonText;
  final onClick;
  final Color color;

  BigButton(
      {this.buttonText, this.onClick, this.color = Colors.deepPurpleAccent});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onClick,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonText, style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
