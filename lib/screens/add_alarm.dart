
import 'package:alarm_clock/models/alarm_model.dart';
import 'package:alarm_clock/utils/local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../utils/database_helper.dart';

class AddAlarm extends StatefulWidget {
  final AlarmModel alarmModel;
  final String appBarTitle;




  AddAlarm(this.alarmModel, this.appBarTitle){
    print('cons '+alarmModel.toString());
  }
  @override
  _LevelAndAlarmScreenState createState() => _LevelAndAlarmScreenState(alarmModel);
}

class _LevelAndAlarmScreenState extends State<AddAlarm> {
  TextEditingController titleController = TextEditingController();
  _LevelAndAlarmScreenState(this.alarmModel);
  AlarmModel alarmModel;
  DatabaseHelper helper = DatabaseHelper();

  String _level ='';
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    ) as TimeOfDay;
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {



    titleController.text = _level;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Alarm'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Enter Level',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  if(_level.isNotEmpty){

                  }
                  setState(() {
                    _level = titleController.text;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Selected Time: ${_selectedTime.format(context)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('Select Alarm Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {

                // Save level and alarm time here
                print('Level: $_level');
                print('butt '+alarmModel.toString());
                print('Alarm Time: ${_selectedTime.format(context)}');




                DateTime now = DateTime.now();

                String timeString = _selectedTime.format(context);

                print('timeString $timeString');
                DateFormat inputFormat = DateFormat("h:mm a");
                DateTime parsedTime = inputFormat.parse(timeString);

                // Convert to 24-hour format
                DateFormat outputFormat = DateFormat("HH:mm");
                String formattedTime = outputFormat.format(parsedTime);

                // Extract hour and minute
                int hour = int.parse(formattedTime.split(':')[0]);
                int minute = int.parse(formattedTime.split(':')[1]);

                print('hour $hour min $minute');
                // Define the specific time (e.g., 04:34 AM)
                DateTime specificTime = DateTime(now.year, now.month, now.day, hour, minute);

                // Calculate the difference
                Duration difference = specificTime.difference(now);

                // Convert the difference to hours and minutes
                int hours = difference.inHours;
                int minutes = difference.inMinutes.remainder(60);

                print('hours: $hours ----- minutes: $minutes');

                int sec = 0;
                if(minutes == 0) sec = 60;
                if(minutes < 0 || hours < 0) {
                  SnackBar snackBar = const SnackBar(content: Text('Time already passed!'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }else{
                  _save(alarmModel, _selectedTime.format(context), _level);
                  print('----------------------- pp ');
                  var last = helper.getAlarm();
                  last.then((value) => 

                      LocalNotifications.showScheduleNotification( 
                      title: "Schedule Notification",
                      body: "This is a Schedule Notification",
                      payload: "This is schedule data", hours: hours, minutes: minutes, sec: sec, id: value[0].id!)
                  );
                 // print();
                  

                  moveToLastScreen();
                }


    }              ,
              child: Text('Save' ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    print(alarmModel);
    if(alarmModel.time!.isEmpty){
      _level = '';
      _selectedTime = TimeOfDay.now();
    }else{
      _level = alarmModel.level!;

      //DateTime parsedTime = DateFormat.jm().parse();

      DateFormat inputFormat = DateFormat("hh:mm a");
      DateTime parsedTime = inputFormat.parse(alarmModel.time!);

      _selectedTime = TimeOfDay.fromDateTime(parsedTime);

    }
    print("----------------------------------------$_selectedTime");
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);  }

  void _save(AlarmModel alarmModel, String selectedTime, String level) async {

    AlarmModel alarmModelS;
    if(alarmModel.id == null){
       alarmModelS = AlarmModel( level, selectedTime, 0);
    }else{
       alarmModelS = AlarmModel.withId(alarmModel.id, level, selectedTime, 0);
    }


    /*alarmModel.time = selectedTime;
    alarmModel.level = level;
    alarmModel.isAlarmCompelted = false;*/
    int result;
    print(alarmModelS.time.toString() + ' - ' + selectedTime);
    print(alarmModelS.level.toString() + ' - ' + level );
    print(alarmModelS.isAlarmCompelted);
    print('-------- id${alarmModelS.id}');
    if (alarmModel.id != null) {  // Case 1: Update operation
      result = await helper.updateAlarm(alarmModelS);
    } else { // Case 2: Insert Operation
      result = await helper.insertAlarm(alarmModelS);
    }
     SnackBar snackBar;
    if (result != 0) {  // Success
      snackBar = SnackBar(
        content: Text('Alarm set successfully!'),
      );
    } else {  // Failure
      snackBar = SnackBar(
        content: Text('Error!'),
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [TextButton(
        child: const Text('Ok'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )],
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }
}
