import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/saved_activity.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class ActivityBase extends ChangeNotifier {
  Map<String, SavedActivity> activities = {};
  var box = Hive.box<SavedActivity>('activities');


  int getSize() => activities.length;

  SavedActivity getActivity(String key) {
    return activities[key] ?? SavedActivity(name: '', key: '', colorAsString: '');
  }

  bool activityExists(String key) => activities.containsKey(key);

  void createNewActivity(String name, Color color) async {
    final key = keyGenerator();
    final newActivity = SavedActivity(
        name: name, key: key, colorAsString: getColorAsString(color));

    //cache
    activities.putIfAbsent(key, () => newActivity);

    //persist
    await box.put(key, newActivity);

    notifyListeners();
  }

  Future<void> deleteActivity(String key) async {
    //delete from cache
    activities.remove(key);
    //delete from box
    await box.delete(key);

    notifyListeners();
  }



  String keyGenerator() {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch.toString();
  }

  String getColorAsString(Color color) {
    return color.value.toString();
  }

  void loadActivitiesFromBox() {
    for (var activity in box.values) {
      activities[activity.key] = activity;
    }
  }
}
