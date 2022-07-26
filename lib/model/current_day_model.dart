import 'package:grid_planner_test/model/time_interval.dart';
import 'package:flutter/material.dart';

class CurrentDayModel extends ChangeNotifier {
  var intervals = <int, int>{};

  void setActivityAtInterval(index, activityKey) {
    intervals[index] = activityKey;
    notifyListeners();
  }

  void removeActivityAtInterval(index) {
    if (hasActivityAtInterval(index)) {
      intervals.remove(index);
      notifyListeners();
    }

  }

  int? getActivityAtInterval(index) => hasActivityAtInterval(index) ? intervals[index] : null;


  bool hasActivityAtInterval(index) => intervals.containsKey(index);
}
