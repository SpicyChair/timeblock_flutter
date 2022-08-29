import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/saved_day.dart';
import 'package:hive/hive.dart';

class CurrentDayModel extends ChangeNotifier {

  SavedDay selectedDay = SavedDay(key: '');

  DateTime selectedDate = DateTime.now();

  var box = Hive.box<SavedDay>('saved_days');

  Future<void> setSelectedDay(DateTime newDate) async {
    selectedDate = newDate;
    await loadDayFromBox(generateKey(newDate));
    notifyListeners();
  }



  Future<void> setActivityAtInterval(int interval, String key) async {

    //cache it
    selectedDay.addInterval(interval, key);


    //persist it
    final dayKey = selectedDay.key;
    await box.put(dayKey, selectedDay);
  }

  Future<void> removeActivityAtInterval(int interval) async {
    selectedDay.removeInterval(interval);

    //persist it
    final dayKey = selectedDay.key;
    await box.put(dayKey, selectedDay);
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
      selectedDay =  box.get(key)!;
    } else {
      //else create and save a new one
      final newDay = SavedDay(key: key);
      await box.put(key, newDay);
    }
  }



  String getActivityKeyAtInterval(int interval) => selectedDay.getActivityAt(interval);

  bool hasActivityAtInterval(int interval) => selectedDay.containsActivityAt(interval);
}
