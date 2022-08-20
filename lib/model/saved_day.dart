
import 'package:grid_planner_test/model/saved_activity.dart';
import 'package:hive/hive.dart';

part 'saved_day.g.dart';

@HiveType(typeId: 2)
class SavedDay {

  @HiveField(0)
  var intervals = <int, String>{};

  @HiveField(1)
  String key;

  SavedDay({required this.key});

  void removeInterval(int interval) {
    intervals.remove(interval);
  }

  void addInterval(int interval, String key) {
    intervals[interval] = key;
  }

  bool containsActivityAt(int interval) {
    return intervals.containsKey(interval);
  }

  String getActivityAt(int interval) {
    return intervals[interval] ?? '';
  }


}