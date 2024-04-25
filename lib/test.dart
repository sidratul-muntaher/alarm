import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current time
    DateTime now = DateTime.now();



    String timeString = "4:59 AM";
    DateFormat inputFormat = DateFormat("h:mm a");
    DateTime parsedTime = inputFormat.parse(timeString);

    // Convert to 24-hour format
    DateFormat outputFormat = DateFormat("HH:mm");
    String formattedTime = outputFormat.format(parsedTime);

    // Extract hour and minute
    int hour = int.parse(formattedTime.split(':')[0]);
    int minute = int.parse(formattedTime.split(':')[1]);

    // Define the specific time (e.g., 04:34 AM)
    DateTime specificTime = DateTime(now.year, now.month, now.day, hour, minute);

    // Calculate the difference
    Duration difference = specificTime.difference(now);

    // Convert the difference to hours and minutes
    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Time Difference Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hours: $hours',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Minutes: $minutes',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}