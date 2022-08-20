import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/saved_day.dart';
import 'package:hive/hive.dart';

class CurrentDayModel extends ChangeNotifier {

  late SavedDay currentSavedDay = SavedDay(key: '');


  var box = Hive.box<SavedDay>('saved_days');

  Future<void> setActivityAtInterval(int interval, String key) async {

    //cache it
    currentSavedDay.addInterval(interval, key);


    //persist it
    final dayKey = currentSavedDay.key;
    await box.put(dayKey, currentSavedDay);
  }

  Future<void> removeActivityAtInterval(int interval) async {
    currentSavedDay.removeInterval(interval);

    //persist it
    final dayKey = currentSavedDay.key;
    await box.put(dayKey, currentSavedDay);
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
      final newDay = SavedDay(key: key);
      await box.put(key, newDay);
    }
  }



  String getActivityKeyAtInterval(int interval) => currentSavedDay.getActivityAt(interval);


  bool hasActivityAtInterval(int interval) => currentSavedDay.containsActivityAt(interval);
}
