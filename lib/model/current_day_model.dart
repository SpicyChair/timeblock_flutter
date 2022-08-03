import 'package:grid_planner_test/model/time_interval.dart';
import 'package:flutter/material.dart';

class CurrentDayModel extends ChangeNotifier {
  var intervals = <int, String>{};

  void setActivityAtInterval(int index, String activityKey) {
    intervals[index] = activityKey;
    notifyListeners();
  }

  void removeActivityAtInterval(int index) {
    if (hasActivityAtInterval(index)) {
      intervals.remove(index);
      notifyListeners();
    }

  }

  String? getActivityKeyAtInterval(int index) => hasActivityAtInterval(index) ? intervals[index] : null;


  bool hasActivityAtInterval(int index) => intervals.containsKey(index);
}
