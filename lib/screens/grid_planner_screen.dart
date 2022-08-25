import 'package:calendar_appbar/calendar_appbar.dart';
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
import 'package:hive/hive.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';

import '../constants.dart';
import '../model/gridview_controller.dart';
import '../model/saved_activity.dart';

class GridPlannerScreen extends StatefulWidget {
  const GridPlannerScreen({Key? key}) : super(key: key);

  @override
  State<GridPlannerScreen> createState() => _GridPlannerScreenState();
}

class _GridPlannerScreenState extends State<GridPlannerScreen> {
  var gridviewController = DragSelectGridViewController();
  final panelController = PanelController();

  //get the selected indexes of the gridview
  Set<int> selectedIndexes() => gridviewController.value.selectedIndexes;

  @override
  void initState() {
    super.initState();
    gridviewController.addListener(scheduleRebuild);
    currentFABHeight = initFABHeight;
  }

  @override
  void dispose() {
    gridviewController.removeListener(scheduleRebuild);
    super.dispose();
  }

  // rebuild the grid view

  void scheduleRebuild() => setState(() {});

  // methods for editing the CurrentDayModel

  void setActivityToSelectedIntervals(String activityKey) {
    var currentDayProvider =
        Provider.of<CurrentDayModel>(context, listen: false);
    //print("called setActivity with index $activityKey");
    //print(gridviewController.value.selectedIndexes);

    for (var selected in selectedIndexes()) {
      currentDayProvider.setActivityAtInterval(selected, activityKey);
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

  final double initFABHeight = 95.0;
  double currentFABHeight = 0;
  double panelHeightOpen = 0;
  double panelHeightClosed = 80.0;

  @override
  Widget build(BuildContext context) {
    panelHeightOpen = MediaQuery.of(context).size.height * .55;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: SafeArea(
          child: WeeklyDatePicker(
            selectedDay: Provider.of<CurrentDayModel>(context, listen: true)
                .selectedDate,
            changeDay: (DateTime newDate) async {
              await Provider.of<CurrentDayModel>(context, listen: false)
                  .setSelectedDay(newDate);
            },
            backgroundColor: Theme.of(context).canvasColor,
            weekdayTextColor: Theme.of(context).textTheme.titleMedium!.color!,
            digitsColor: Theme.of(context).textTheme.titleMedium!.color!,
            selectedBackgroundColor: Colors.blueAccent,
            enableWeeknumberText: false,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SlidingUpPanel(
            controller: panelController,
            color: Theme.of(context).bottomAppBarColor,
            maxHeight: panelHeightOpen,
            minHeight: panelHeightClosed,
            panel: SlidingPanel(
              selectedIndexes: selectedIndexes,
              setActivityToSelectedIndexes: setActivityToSelectedIntervals,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            body: buildGridView(),
            header: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 30,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (panelController.isPanelClosed) {
                    //open the panel if closed
                    panelController.animatePanelToPosition(1.0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 200));
                  } else {
                    //close the panel if open
                    panelController.animatePanelToPosition(0.0,
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 200));
                  }
                },
                child: SizedBox(
                  height: 30,
                  width: 70,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(24.0),
                        ),
                      ),
                      height: 5,
                      width: 60,
                    ),
                  ),
                ),
              ),
            ),
            onPanelSlide: (double newPos) => setState(() {
              //update the FAB height as panel slides
              currentFABHeight =
                  newPos * (panelHeightOpen - panelHeightClosed) +
                      initFABHeight;
            }),
          ),
          Visibility(
            visible: selectedIndexes().isNotEmpty,
            child: Positioned(
              right: 20.0,
              bottom: currentFABHeight,
              child: FloatingActionButton.extended(
                onPressed: () {
                  removeActivityFromSelectedIntervals();
                },
                backgroundColor: Colors.redAccent,
                label: const Text(
                  "Clear",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                icon: const Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView buildGridView() {
    return ListView(
      //physics: const BouncingScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, panelHeightClosed),
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
                            "$i:00".padLeft(5, ' '),
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    // 1 item to represent the time on each row, 6 SelectableItems
                    crossAxisCount: 6,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: 144,
                  itemBuilder: (context, index, selected) {
                    //border radius of corners
                    Radius corner = const Radius.circular(15);
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
                      builder: (context, activityBase, currentDayModel, child) {
                        Color color = Colors.grey;

                        //if the interval contains an activity
                        if (currentDayModel.hasActivityAtInterval(index)) {
                          //get the activity key
                          var key =
                              currentDayModel.getActivityKeyAtInterval(index);

                          //check if activity exists
                          if (!activityBase.activityExists(key)) {
                            //if not, remove it from the current day
                            //used if user deletes a previously set activity
                            currentDayModel.removeActivityAtInterval(index);
                          } else {
                            color = activityBase.getActivity(key).getColor();
                          }
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
    );
  }
}
