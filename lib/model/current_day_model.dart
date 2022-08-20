import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/saved_day.dart';
import 'package:hive/hive.dart';

class CurrentDayModel extends ChangeNotifier {

  SavedDay currentSavedDay = SavedDay();
  DateTime currentDate = DateTime.now();
  var intervals = <int, String>{};

  void setActivityAtInterval(int index, String activityKey) {
    intervals[index] = activityKey;
  }

  void removeActivityAtInterval(int index) {
    if (hasActivityAtInterval(index)) {
      intervals.remove(index);
    }
    //print(intervals.values.length);
  }



  String getActivityKeyAtInterval(int index) => intervals[index] ?? '';


  bool hasActivityAtInterval(int index) => intervals.containsKey(index);
}
