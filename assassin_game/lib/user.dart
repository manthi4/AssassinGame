
class User{
  bool _alive = true;
  String _target;
  List<String> kills;
  String name = "Cadet";


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