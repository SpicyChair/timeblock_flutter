import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/activity_base.dart';

class TimeInterval {

  String activityKey; //acts as a key to ActivityBase
  ActivityBase base = ActivityBase();

  TimeInterval({required this.activityKey});

  Color getColor() {
    return base.activities[activityKey]?.color ?? Colors.grey;
}
}