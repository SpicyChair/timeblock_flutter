import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/saved_activity.dart';

class ActivityBase extends ChangeNotifier {
  Map<String, SavedActivity> activities = {};

  int getSize() => activities.length;

  void createNewActivity(String name, Color color) {

    activities.putIfAbsent(name, () => SavedActivity(name: name, color: color));
  }

  String getColorAsString(Color color) {
    return color.value.toString();
  }


}