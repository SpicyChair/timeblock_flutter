import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/activity_base.dart';

class TimeInterval {

  int activityIndex; //acts as a key to ActivityBase
  ActivityBase base = ActivityBase();

  TimeInterval({required this.activityIndex});

  Color getColor() {
    return base.activities[activityIndex].color;
}
}