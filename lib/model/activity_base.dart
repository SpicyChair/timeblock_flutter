import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/saved_activity.dart';

class ActivityBase extends ChangeNotifier {
  List<SavedActivity> activities = [
    /*
    SavedActivity(name: "Sleep", color: Colors.blueGrey),
    SavedActivity(name: "Study", color: Colors.orange),
    SavedActivity(name: "Eat", color: Colors.redAccent),
    SavedActivity(name: "Relax", color: Colors.green),

     */
  ];

  bool hasActivityAt(int index) => getSize() > index;

  int getSize() => activities.length;

  void createNewActivity(String name, Color color) {
    activities.add(SavedActivity(name: name, color: color));
  }
}