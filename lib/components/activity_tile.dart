import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile(
      {Key? key, required this.title, required this.icon, required this.color,})
      : super(key: key);

  final String title;
  final String icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(100), //circle
            ),
            height: 25,
            width: 25,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
