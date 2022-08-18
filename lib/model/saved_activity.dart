import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'saved_activity.g.dart';

@HiveType(typeId: 1)
class SavedActivity {

  SavedActivity({required this.name, required this.key, required this.color});
  @HiveField(0)
  String name;

  @HiveField(1)
  String key;

  @HiveField(2)
  Color color;

}