import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/saved_activity.dart';

class ActivityTile extends StatelessWidget {




  const ActivityTile(
      {Key? key, required this.activity, required this.onTap, required this.onDeleteActivity, required this.onEditActivity, required this.context})
      : super(key: key);

  final BuildContext context;
  final SavedActivity activity;
  final Function onTap;
  final Function onEditActivity;
  final Function onDeleteActivity;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: activity.getColor().withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
        onTap: () async => onTap(activity.key),
        onLongPress: () => onDeleteActivity(activity.key),
        child: IgnorePointer(
          ignoring: true,
          child: Center(
            child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  color: activity.getColor(),
                  borderRadius: BorderRadius.circular(100), //circle
                ),
                height: 25,
                width: 25,
              ),
              title: Text(
                activity.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
    ),
      );
  }

}
