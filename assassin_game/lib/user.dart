import 'package:assassingame/screens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:cross_local_storage/cross_local_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart';

/// There is only one User in the app. So rather than instantiating a User I think it makes more sense to make everything in the class static.

class User {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static Firestore _fstore = Firestore.instance;
//  static CloudFunctions _clFunctons = CloudFunctions.instance;
  static FirebaseUser currentUser;
  static String _userID;
  static Map _userData;
  static final HttpsCallable Kill =
      CloudFunctions.instance.getHttpsCallable(functionName: 'Eliminate');
//  static final

  static Future<void> initialize() async {
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

        ///TODO: we dont need it to search by email anymore since we already have the ID
        .getDocuments()
        .then(
      (thing) {
        if (thing.documents.isNotEmpty) {
          print("got userData");
          _userData = thing.documents.single.data;
          _userID = thing.documents.single.documentID;
          print("UserID = $_userID");
        } else {
          print("userData not found!");
        }
      },
    );
  }

  static String userName() {
    return _userData["Username"];
  }
  static String userID(){
    return _userID;
  }

  static List<String> getGameNames() {
    List<String> names = [];
    Map<String, dynamic> Games = Map<String, dynamic>.from(_userData["Games"]);
    Games.forEach((key, value) {
      names.add(value["GameName"]);
    });

    return names;
  }

  static Map<String, dynamic> getGames() {
    return Map<String, dynamic>.from(_userData["Games"]);
  }

  static String getGameID({@required gameName}) {
    Map<String, dynamic> games = Map<String, dynamic>.from(_userData["Games"]);
    String result = "";
    games.forEach((key, value) {
      if (value["GameName"] == gameName) {
        result = key;
      }
    });
    return result;
  }

  static String getGameName({@required gameID}) {
    return _userData["Games"][gameID]["GameName"];
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
    List activeGames = _userData["Games"].keys.toList();
    if (_userData["Games"].keys.toList().contains(ID)) {
      return ID;
    } else {
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
    ///Creates new game
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

    /// Creates Players sub collection and adds the player
    _fstore
        .collection("Games")
        .document(newGameDocRef.documentID)
        .collection("Players")
        .document(_userID)
        .setData({
      "Targetname": "",
      "Username": _userData["Username"],
    });

    /// Adds the game to the Users list of games
    await _fstore.collection("Users").document(_userID).setData({
      "Games": {
        newGameDocRef.documentID.toString()
            : {
          "GameName": "$gameName",
          "Active": true,
          "Alive": true,
          "Owner": true,
        },
      },
    }, merge: true);

    /// updates the local user data.
    await getUserData();
    return newGameDocRef.documentID;
  }

  static Future<String> joinGame({@required gameID}) async {
    String newGameName = "";
    DocumentSnapshot GdocRef =
        await _fstore.collection("Games").document(gameID).get();

    if (!GdocRef.exists) {
      print("That game ID does not extis");
      return "";
    }

    ///TODO: Need yo check if the user is already in the game. If so then don't add them again. Instead show a notification about it.
//    if(_userData["Games"])

    ///Adds the user as a player to the specified game's "players" database
    await _fstore
        .collection("Games")
        .document(gameID)
        .collection("Players")
        .document(_userID)
        .setData({
      "Targetname": "",
      "Username": _userData["Username"],
    }).catchError((e) {
      print("there was an error");
      print(e);
    });

    ///Adds the user to the list of players in the gamedoc
    await _fstore.collection("Games").document(gameID).setData({
      "PlayerStatus": {
        "${_userData["Username"]}": {
          "Alive": true,
          "kills": 0,
        },
      }
    }, merge: true);

    ///Get the game's name then adds the game to the Users list of games.
    await _fstore.collection("Games").document(gameID).get().then((value) {
      newGameName = value.data["GameName"];
      _fstore.collection("Users").document(_userID).setData({
        "Games": {
          gameID.toString()
              : {
            "GameName": value.data["GameName"],
            "Active": true,
            "Alive": true, ///TODO: need to update the kill cloud function to set this to false in the Target's user doc
            "Owner": false,
          },
        },
      }, merge: true);
    });

    ///Update Local User Data
    await getUserData();
    print("Added to Game");

    ///TODO: Handle error for when user is unable to join a game.

    return newGameName;
  }

  static Future<void> eliminateTarget({@required gameID}) async { ///TODO: set the value of Alive to false in the Target's User Doc
    ///TODO: Make a cloud function that checks if there is anyone still alive, if not then mark the game as inactive in everyone's user doc
    //TODO: set target to "claimed elimination" in database

    print("Trying to test");
    var data = {"gameID": gameID};
    HttpsCallableResult result = await Kill.call(data);
    print(result.toString());
    print(result.data.toString());
  }

  static Future<void> startGame({@required gameID}) async {
    var url = "https://us-central1-assassingame-c59a6.cloudfunctions.net/setTargets?gameid=${gameID}";
    var response = await post(url);
    print("response was: ${response.body.toString()}");
  }
}
