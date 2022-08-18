import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/saved_activity.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class ActivityBase extends ChangeNotifier {
  Map<String, SavedActivity> activities = {};
  var box = Hive.box<SavedActivity>('activities');

  int getSize() => activities.length;

  void createNewActivity(String name, Color color) async {
    final key = keyGenerator();
    final newActivity = SavedActivity(name: name, key: key, colorAsString: getColorAsString(color));

    activities.putIfAbsent(key, () => newActivity);
    box.put(key, newActivity);
  }

  void loadActivitiesFromBox()  {
    for (int i = 0; i < box.length; i++) {
      var activity = box.getAt(i);
      activities[activity?.key ?? ''] = activity ?? SavedActivity(key: '', name: '', colorAsString: '');
    }
    notifyListeners();
  }

  String keyGenerator() {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch.toString();
  }

  String getColorAsString(Color color) {
    return color.value.toString();
  }


}