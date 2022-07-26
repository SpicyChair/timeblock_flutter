import 'package:flutter/material.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:grid_planner_test/components/selectable_item.dart';
import 'package:grid_planner_test/model/activity_base.dart';
import 'package:grid_planner_test/model/current_day_model.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:grid_planner_test/model/time_interval.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../model/saved_activity.dart';

class GridPlannerScreen extends StatefulWidget {
  const GridPlannerScreen({Key? key}) : super(key: key);

  @override
  State<GridPlannerScreen> createState() => _GridPlannerScreenState();
}

class _GridPlannerScreenState extends State<GridPlannerScreen> {
  final gridviewController = DragSelectGridViewController();
  Color pickerColor = Colors.blueAccent;
  Color currentColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();
    gridviewController.addListener(scheduleRebuild);
  }

  @override
  void dispose() {
    gridviewController.removeListener(scheduleRebuild);
    super.dispose();
  }

  // rebuild the grid view

  void scheduleRebuild() => setState(() {});

  // methods for editing the CurrentDayModel

  void setActivityToSelectedIntervals(int activityIndex) {
    var currentDayProvider =
        Provider.of<CurrentDayModel>(context, listen: false);
    //print("called setActivity with index $activityIndex");
    //print(gridviewController.value.selectedIndexes);

    for (var selected in gridviewController.value.selectedIndexes) {
      selected = (selected - (selected ~/ 7)).round() - 1;
      currentDayProvider.setActivityAtInterval(selected, activityIndex);
    }

    gridviewController.clear();
  }

  void removeActivityFromSelectedIntervals() {
    var currentDayProvider =
        Provider.of<CurrentDayModel>(context, listen: false);

    for (var selected in gridviewController.value.selectedIndexes) {
      selected = (selected - (selected ~/ 7)).round() - 1;
      currentDayProvider.removeActivityAtInterval(selected);
    }
    gridviewController.clear();
  }

  // AlertDialogs for setting activities

  Future<void> openColorPicker() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                setState(() {
                  pickerColor = color;
                  currentColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showSavedActivitySelectionDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text('Choose Activity'),
            content: SizedBox(
              height: 300,
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount:
                    Provider.of<ActivityBase>(context, listen: true).getSize(),
                itemBuilder: (context, index) {
                  return Consumer<ActivityBase>(
                      builder: (context, activityBase, child) {
                    return Card(
                      child: ListTile(
                        onTap: () {
                          setActivityToSelectedIntervals(index);
                          Navigator.of(context).pop();
                        },
                        title: Text(activityBase.activities[index].name),
                        leading: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            color: activityBase.activities[index].color,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await showCreateNewActivityDialog();
                  setState(() {});
                },
                child: const Text('Create Activity'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> showCreateNewActivityDialog() async {
    String newActivityName = "";
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text('Create Activity'),
            content: SizedBox(
              height: 300,
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: currentColor,
                    title: const Center(child: Text("Change Color")),
                    onTap: () async {
                      await openColorPicker();
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    onChanged: (newValue) {
                      newActivityName = newValue;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Enter activity name',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Provider.of<ActivityBase>(context, listen: false)
                      .createNewActivity(newActivityName, currentColor);
                  Navigator.of(context).pop();
                },
                child: const Text('Create Activity'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grid Planner"),
        centerTitle: true,
      ),

      //if the controller value is empty, ie no selected tiles, show a container
      //else show a FAB which clears any selected tiles
      body: SlidingUpPanel(
        panel: Center(
          child: Text("Sliding Up Panel"),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        header: Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(24.0),),
            ),
            height: 5,
            width: 50,
          ),
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: DragSelectGridView(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  // 1 item to represent the time on each row, 6 SelectableItems
                  crossAxisCount: 7,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: 168,
                itemBuilder: (context, index, selected) {
                  if (index % 7 == 0) {
                    return AspectRatio(
                      aspectRatio: 1,
                      child: Center(
                        child: Text(
                          "${index ~/ 7}:00".padLeft(5, '0'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  } else {
                    //find the "actual" index of the items
                    //since we have 168 items (24 items represent time)
                    final actualIndex = (index - (index ~/ 7)).round() - 1;
                    //border radius of corners
                    Radius corner = const Radius.circular(10);
                    //default border radius
                    BorderRadius radius = BorderRadius.zero;
                    //round the corners of the 4 items in the corners
                    switch (actualIndex) {
                      case 0:
                        radius = BorderRadius.only(topLeft: corner);
                        break;
                      case 5:
                        radius = BorderRadius.only(topRight: corner);
                        break;
                      case 138:
                        radius = BorderRadius.only(bottomLeft: corner);
                        break;
                      case 143:
                        radius = BorderRadius.only(bottomRight: corner);
                        break;
                    }

                    return Consumer2<ActivityBase, CurrentDayModel>(
                      builder: (context, activityBase, currentDay, child) {
                        Color color = Colors.grey;

                        if (currentDay.hasActivityAtInterval(actualIndex)) {
                          var activityIndex =
                              currentDay.intervals[actualIndex] ?? 0;
                          color = activityBase.activities[activityIndex].color;
                        }

                        return SelectableItem(
                          index: actualIndex,
                          color: color,
                          selected: selected,
                          radius: radius,
                        );
                      },
                    );
                  }
                },
                gridController: gridviewController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
