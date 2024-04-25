class AlarmModel {
   int? _id;
   String? _level;
   String? _time;
   int? _isAlarmCompelted;

  AlarmModel(this._level, this._time, this._isAlarmCompelted);
  AlarmModel.withId(this._id, this._level, this._time, this._isAlarmCompelted);


   @override
  String toString() {
    return 'AlarmModel{_id: $_id, _level: $_level, _time: $_time, _isAlarmCompelted: $_isAlarmCompelted}';
  }

   String? get level => _level;

  int? get id => _id;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }
    map['level'] = _level;
    map['time'] = _time;
    map['isAlarmCompelted'] = _isAlarmCompelted;

    print(map);
    return map;
  }


  AlarmModel.fromMapObject(Map<String, dynamic> map) {
    _time = map['time'];
    _id = map['id'];
    print('   --- -  '+map['level']);

    _level = map['level'];

    _isAlarmCompelted = map['isAlarmCompelted'];
  }

   String? get time => _time;

   int? get isAlarmCompelted => _isAlarmCompelted;
}
