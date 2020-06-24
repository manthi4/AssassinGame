import 'package:assassingame/screens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:cross_local_storage/cross_local_storage.dart';

/// There is only one User in the app. So rather than instantiating a User I think it makes more sense to make everything in the class static.

class User {
  String name = "Cadet";
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static Firestore _fstore = Firestore.instance;
  static FirebaseUser currentUser;
  static String _userID;
  static Map _userData;

  ///Will be replaced by streams
  Map selectedGameData;
  Map _playerData;

//  User() {
//    constructor_Stuff_I_cant_put_in_the_contructor_cuz_its_async();
//  }

//  void constructor_Stuff_I_cant_put_in_the_contructor_cuz_its_async() async {
//    await getLoginData();
//    await getUserData();
//    await getGameData(gameID: selectedGameID());
//    await getPlayerData();
//  }

  static Future<void> initialize() async {
//    var waitList = <Future<void>>[];
    await getLoginData();
    await getUserData();
    print("User Initialized");
  }

  static Future<void> getLoginData() async {
    currentUser = await _auth.currentUser();
  }

  /// The getUserData actually doesn't need a stream.
  /// But keep in mind to call it once if the Userdoc is ever updated (which would happen through the app). Like when the User adds themselves to a new game.
  static Future<void> getUserData() async {
    var userEmail = currentUser.email;
    print("userEmail: $userEmail");
    await _fstore
        .collection('Users')
        .where("Email", isEqualTo: "$userEmail")
        .getDocuments()
        .then(
      (thing) {
        if (thing.documents.isNotEmpty) {
          print("got userData");
          _userData = thing.documents.single.data;
          _userID = thing.documents.single.documentID;
          print("UserID = $_userID");
        }else{
          print("userData not found!");
        }
      },
    );
  }

  static String userName() {
    var username = _userData["Username"];
    var wut = true;
    return _userData["Username"];
  }

  static List<String> getGameNames() {
//    var userd = _userData;
//    Map hopefullyGames = _userData["Games"];
//    Iterable hopefullykeys = _userData["Games"].keys;
//    var hopefullyList = hopefullykeys.toList();
    return _userData["Games"].keys.toList();
  }

  static Map getGames(){
    return _userData["Games"];
  }

  static String getGameID({@required gameName}) {
    return _userData["Games"]["$gameName"];
  }

  static String getGameName({@required gameID}) {
    Map<String, dynamic> games = _userData["Games"];
    String result = "";
    games.forEach((key, value) {
      if (value == gameID) {
        result = key;
      }
    });
    return result;
  }

  ///These are the streams. There are two streams set up for each game that a user is in. One stream monitors changes in the game document and the other monitors changes in the player document.

  static Stream<DocumentSnapshot> gameDocStreamCreator({@required gameID}) {
    return _fstore.collection("Games").document(gameID).snapshots();
  }

  static Stream<DocumentSnapshot> playerDocStreamCreator({@required gameID}) {
    return _fstore
        .collection("Games")
        .document(gameID)
        .collection("Players")
        .document(_userID)
        .snapshots();
  }

  static Future<String> getSelectedGameID() async {
    LocalStorageInterface onDevice = await LocalStorage.getInstance();
    String ID = await onDevice.getString("LastActiveG") ?? "";
    List activeGames = _userData["Games"].values.toList();
    if (_userData["Games"].values.toList().contains(ID)) {
      return ID;
    }else {
      return "";
    }
  }

  static Future<String> setSelectedGameID({@required gameID}) async {
    LocalStorageInterface onDevice = await LocalStorage.getInstance();
    onDevice.setString('LastActiveG', gameID);
    return gameID;
  }

  /// Creates a new game doc, then populates a subcollection "Players" with the player document for the creator. Then it also updates the current User document's Games feild to include the new game.
  static Future<String> createNewGame({@required gameName}) async {
    DocumentReference newGameDocRef = await _fstore.collection("Games").add({
      "GameCreator": _userID,
      "GameName": gameName,
      "PlayerStatus": {
        "${_userData["Username"]}": {
          "Alive": true,
          "kills": 0,
        },
      }
    });
    _fstore
        .collection("Games")
        .document(newGameDocRef.documentID)
        .collection("Players")
        .document(_userID)
        .setData({
      "Targetname": "",
      "Username": _userData["Username"],
    });

    _fstore.collection("Users").document(_userID).setData({
      "Games": {"$gameName": newGameDocRef.documentID},
    }, merge: true);

    getUserData();
    return newGameDocRef.documentID;
  }

  static Future<String> joinGame({@required gameName}){

  }

  static void eliminateTarget() {
    //TODO: set target to "claimed elimination" in database
  }
}
