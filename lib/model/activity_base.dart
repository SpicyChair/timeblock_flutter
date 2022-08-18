import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/saved_activity.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class ActivityBase extends ChangeNotifier {
  Map<String, SavedActivity> activities = {};
  var box = Hive.box('activities');

  int getSize() => activities.length;

  void createNewActivity(String name, Color color) {
    final key = keyGenerator();
    activities.putIfAbsent(key, () => SavedActivity(name: name, key: key, color: color));
  }

  String keyGenerator() {
    final now = DateTime.now();
    return now.millisecondsSinceEpoch.toString();
  }

  String getColorAsString(Color color) {
    return color.value.toString();
  }


}