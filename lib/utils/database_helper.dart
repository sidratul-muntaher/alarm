import 'package:alarm_clock/models/alarm_model.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String alarmTable = 'alarm_table';
  String colId = 'id';
  String colLevel = 'level';
  String colTime = 'time';
  String colIsAlarmCompleted = 'isAlarmCompelted';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'alarm.db';

    var alarmsDatabase =
        await openDatabase(path, version: 2, onCreate: _createDb);
    return alarmsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'create table $alarmTable (  $colId integer primary key  autoincrement,'
        ' $colLevel text, $colTime text, $colIsAlarmCompleted integer)');
  }

  Future<List<Map<String, dynamic>>> getAlarmMapList() async {
    Database db = await this.database;

    var result = await db.query(alarmTable, orderBy: '$colId ASC');
    return result;
  }

  Future<int> insertAlarm(AlarmModel alarm) async {
    Database db = await this.database;
    var result = await db.insert(alarmTable, alarm.toMap());
    return result;
  }

  Future<int> updateAlarm(AlarmModel alarm) async {
    var db = await this.database;
    var result = await db.update(alarmTable, alarm.toMap(),
        where: '$colId = ?', whereArgs: [alarm.id]);
    return result;
  }

  Future<int> deleteAlarm(int? id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $alarmTable WHERE $colId = $id');
    return result;
  }

  Future<int?> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $alarmTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Map<String, dynamic>>> getData() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db
        .rawQuery('SELECT * FROM $alarmTable ORDER BY id DESC LIMIT 1 ');
    return x;
  }

  Future<List<AlarmModel>> getAlarmList() async {
    var alarmMapList = await getAlarmMapList();
    int count = alarmMapList.length;

    List<AlarmModel> alarmList = [];
    for (int i = 0; i < count; i++) {
      alarmList.add(AlarmModel.fromMapObject(alarmMapList[i]));
    }

    return alarmList;
  }

  Future<List<AlarmModel>> getAlarm() async {
    var alarmMapList = await getData();
    int count = alarmMapList.length;

    List<AlarmModel> alarmList = [];
    for (int i = 0; i < count; i++) {
      alarmList.add(AlarmModel.fromMapObject(alarmMapList[i]));
    }

    return alarmList;
  }
}
