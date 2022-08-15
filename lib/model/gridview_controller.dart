import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'current_day_model.dart';
import 'package:flutter/material.dart';

class GridPlannerControllerProvider extends ChangeNotifier {
  final controller = DragSelectGridViewController();

  //get the selected indexes of the gridview
  Set<int> selectedIndexes() => controller.value.selectedIndexes;

  void clear() => controller.clear();

  void setActivityToSelectedIntervals(String activityKey, BuildContext context) {
    if (selectedIndexes().isEmpty) {
      return;
    }

    var currentDayProvider =
    Provider.of<CurrentDayModel>(context, listen: false);

    for (var selected in selectedIndexes()) {
      currentDayProvider.setActivityAtInterval(selected, activityKey);
    }

    controller.clear();
  }

  void removeActivityFromSelectedIntervals(BuildContext context) {

    if (selectedIndexes().isEmpty) {
      return;
    }

    var currentDayProvider =
    Provider.of<CurrentDayModel>(context, listen: false);

    for (var selected in selectedIndexes()) {
      currentDayProvider.removeActivityAtInterval(selected);
    }
    controller.clear();
  }
}