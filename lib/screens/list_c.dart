import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/alarm_model.dart';
import '../utils/database_helper.dart';
import '../utils/local_notifications.dart';
import 'add_alarm.dart';

class ListC extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return AlarmListState();
  }


}

class AlarmListState extends State<ListC> with WidgetsBindingObserver{
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<AlarmModel> alarmModel = [];
  AlarmModel alarmM = AlarmModel("", "", 0);
  int count = 0;

  listenToNotifications() {
    print("Listening to notification");
    LocalNotifications.onClickNotification.stream.listen((event) {
      print(event);
      Navigator.pushNamed(context, '/test', arguments: event);
    });
  }

  @override
  Widget build(BuildContext context) {




    return Column(

      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(0, 100, 0, 10),
          child: ElevatedButton(
            onPressed: () {

              Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) =>AddAlarm(alarmM, "")) //AlarmPage()), //AddAlarm(alarmModel, "")),
              ).then((value) {
                if (value == true) {
                  setState(() {
                    updateListView();
                  });
                }
              });

            },
            child: const Text(
              'Add Alarm',
            ),
          ),
        ),
        Expanded(child: ListView.builder(
            itemCount: count,
            itemBuilder: (context, index) {
              // print('-- $index');

              return Card(
                color: Colors.white,
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.red[400],
                    child: const Icon(
                      Icons.alarm,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(alarmModel[index].level!),
                  subtitle: Text(this.alarmModel[index].time!),
                  trailing: GestureDetector(
                      child: Icon(Icons.delete, color: Colors.grey,),
                      onTap: () {
                        _delete(context, alarmModel[index]);
                      }),
                  onTap: () {
                    print(alarmModel[index].id.toString() + ' pressed ' + count.toString());
                    navigateToDetail(alarmModel[index], "");
                    //count++;
                  },
                ),
              );
            })),


        //
      ],
    );


  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    listenToNotifications();

    updateListView();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.resumed) {
      updateListView();
    }
  }
  void _delete(BuildContext context, AlarmModel alarmModel) async {

    int result = await databaseHelper.deleteAlarm(alarmModel.id);
    if (result != 0) {
      updateListView();
    }
  }

  void navigateToDetail(AlarmModel alarmModel, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddAlarm(alarmModel, title);
    }));

    if (result == true) {
      updateListView();
    }
  }
  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<AlarmModel>> noteListFuture = databaseHelper.getAlarmList();
      noteListFuture.then((alarmList) {

        //if(mounted){
        setState(() {
          this.alarmModel = alarmList;
          this.count = alarmList.length;
        });
        // }
      });
    });
  }


}
