import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/saved_day.dart';
import 'package:hive/hive.dart';

class CurrentDayModel extends ChangeNotifier {

  SavedDay currentSavedDay = SavedDay();
  DateTime currentDate = DateTime.now();
  var intervals = <int, String>{};
  var box = Hive.box<SavedDay>('saved_days');

  void setActivityAtInterval(int index, String activityKey) {
    intervals[index] = activityKey;
  }

  void removeActivityAtInterval(int index) {
    if (hasActivityAtInterval(index)) {
      intervals.remove(index);
    }
    //print(intervals.values.length);
  }

  Future<void> loadCurrentDayFromBox() async {
    final key = generateKey(DateTime.now());
    await loadDayFromBox(key);
  }

  String generateKey(DateTime date) {
    //DDMMYYYY
    return "${date.day}${date.month}${date.year}";
  }

  Future<void> loadDayFromBox(String key) async {
    if (box.containsKey(key)) {
      //get the saved day if it exists
      currentSavedDay =  box.get(key)!;
    } else {
      //else create and save a new one
      final newDay = SavedDay();
      await box.put(key, newDay);
    }
  }



  String getActivityKeyAtInterval(int index) => intervals[index] ?? '';


  bool hasActivityAtInterval(int index) => intervals.containsKey(index);
}
