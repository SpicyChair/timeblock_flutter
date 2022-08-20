
import 'package:grid_planner_test/model/saved_activity.dart';
import 'package:hive/hive.dart';

part 'saved_day.g.dart';

@HiveType(typeId: 2)
class SavedDay {

  @HiveField(0)
  var intervals = <int, String>{};
}