import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:grid_planner_test/components/activity_tile.dart';
import 'package:grid_planner_test/components/selectable_item.dart';
import 'package:grid_planner_test/components/sliding_panel.dart';
import 'package:grid_planner_test/model/activity_base.dart';
import 'package:grid_planner_test/model/current_day_model.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


import '../constants.dart';
import '../model/saved_activity.dart';

class GridPlannerScreen extends StatefulWidget {
  const GridPlannerScreen({Key? key}) : super(key: key);

  @override
  State<GridPlannerScreen> createState() => _GridPlannerScreenState();
}

class _GridPlannerScreenState extends State<GridPlannerScreen> {
  final gridviewController = DragSelectGridViewController();

  //get the selected indexes of the gridview
  Set<int> selectedIndexes() => gridviewController.value.selectedIndexes;

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

    for (var selected in selectedIndexes()) {
      currentDayProvider.setActivityAtInterval(selected, activityIndex);
    }

    gridviewController.clear();
  }

  void removeActivityFromSelectedIntervals() {
    var currentDayProvider =
        Provider.of<CurrentDayModel>(context, listen: false);

    for (var selected in selectedIndexes()) {
      currentDayProvider.removeActivityAtInterval(selected);
    }
    gridviewController.clear();
  }

  // AlertDialogs for setting activities

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        maxHeight: 420,
        panel: SlidingPanel(
          selectedIndexes: selectedIndexes,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        body: ListView(
          //physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding:
                  EdgeInsets.zero, //const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 24; i++)
                          AspectRatio(
                            aspectRatio: 1,
                            child: Center(
                              child: Text(
                                "$i:00".padLeft(5, '0'),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: DragSelectGridView(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        // 1 item to represent the time on each row, 6 SelectableItems
                        crossAxisCount: 6,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                      ),
                      itemCount: 144,
                      itemBuilder: (context, index, selected) {
                        //border radius of corners
                        Radius corner = const Radius.circular(10);
                        //default border radius
                        BorderRadius radius = BorderRadius.zero;
                        //round the corners of the 4 items in the corners
                        switch (index) {
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

                            if (currentDay.hasActivityAtInterval(index)) {
                              var activityIndex =
                                  currentDay.intervals[index] ?? 0;
                              color =
                                  activityBase.activities[activityIndex].color;
                            }

                            return SelectableItem(
                              index: index,
                              color: color,
                              selected: selected,
                              radius: radius,
                            );
                          },
                        );
                      },
                      gridController: gridviewController,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Color pickerColor = Colors.blueAccent;
  Color currentColor = Colors.blueAccent;
  String emojiIcon = "";

  Future<void> showCreateNewActivityDialog() async {
    String newActivityName = "";
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            title: const Text('New Activity'),
            content: SizedBox(
              height: 250,
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: kMediumBorderRadius,
                      side: BorderSide(width: 2, color: Colors.grey.shade300),
                    ),
                    title: const Center(child: Text("Change Icon")),
                    onTap: () async {
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: kMediumBorderRadius,
                    ),
                    tileColor: currentColor,
                    title: const Center(child: Text("Change Color")),
                    onTap: () async {
                      await showColorPickerDialog();
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
                        borderRadius: kMediumBorderRadius,
                      ),
                      hintText: 'Enter activity name',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
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

  Future<void> showColorPickerDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        content: SingleChildScrollView(
          child: MaterialPicker(
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
            child: const Text('Select'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"))
        ],
      ),
    );
  }
}
