import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile(
      {Key? key, required this.title, required this.icon, required this.color, required this.onTap,})
      : super(key: key);

  final String title;
  final String icon;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
        onTap: () {},
        child: GestureDetector(
          onTap: () => onTap(title),
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
        ),
    ),
      );
  }
}
