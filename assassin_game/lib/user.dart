import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  bool _alive = true;
  String _target;
  List<String> kills;
  String name = "Cadet";
  final _auth = FirebaseAuth.instance;
  final _base = Firestore.instance;
  var currentUser;

  void getUserData()async{
   currentUser = await _auth.currentUser();

  }

  User(){

  }

  void update(){
    ///TODO: access database to update
    this._target = "enemy";

  }

  bool isAlive(){
    return _alive;
  }

  String getTarget(){
    return _target;
  }

  void eliminateTarget(){
    //TODO: set target to "claimed elimination" in database
    _alive =false;
  }
}