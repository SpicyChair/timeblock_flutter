import 'package:flutter/material.dart';
import 'package:grid_planner_test/components/activity_and_color_dialogs.dart';
import 'package:grid_planner_test/services/time_helper.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../model/activity_base.dart';
import '../model/saved_activity.dart';
import 'activity_tile.dart';

class SlidingPanel extends StatefulWidget {
  const SlidingPanel(
      {Key? key,
      required this.selectedIndexes,
      required this.setActivityToSelectedIndexes})
      : super(key: key);

  final Function selectedIndexes;
  final Function setActivityToSelectedIndexes;

  @override
  State<SlidingPanel> createState() => _SlidingPanelState();
}

class _SlidingPanelState extends State<SlidingPanel> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          createSelectedTitle(),
          const SizedBox(
            height: 20,
          ),
          createSelectActivityPanel(),
          const SizedBox(
            height: 20,
          ),
          createActivityPanelActionButtons(),
        ],
      ),
    );
  }

  Widget createSelectedTitle() {
    if (widget.selectedIndexes().isEmpty) {
      return Text(
        "Select Activity",
        style: Theme.of(context).textTheme.titleMedium,
      );
    }
    return Flexible(
      child: Row(

        children: [
          Flexible(
            child: Text(convertSelectedIndexesIntoReadable(widget.selectedIndexes()),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis,),
          ),
          Text(
            " | ${getSelectedIndexesAsLength(widget.selectedIndexes())} minutes",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget createSelectActivityPanel() {
    int itemCount = Provider.of<ActivityBase>(context, listen: true).getSize();
    ScrollController controller = ScrollController();
    return ClipRRect(
      borderRadius: kMediumBorderRadius,
      child: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.31,
        child: Scrollbar(
          controller: controller,
          child: itemCount == 0
              ? const Center(
                  child: Text(
                    "Add a new activity below!",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    return Consumer<ActivityBase>(
                      builder: (context, activityBase, child) {
                        SavedActivity activity =
                            activityBase.activities.values.toList()[index];
                        return ActivityTile(
                          activity: activity,
                          onTap: widget.setActivityToSelectedIndexes,
                          onLongPress: showConfirmDeletionDialog,
                        );
                      },
                    );
                  },
                  controller: controller,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    // 1 item to represent the time on each row, 6 SelectableItems
                    crossAxisCount: 2,
                    crossAxisSpacing: 7.0,
                    mainAxisSpacing: 7.0,
                    childAspectRatio: 2.5,
                  ),
                ),
        ),
      ),
    );
  }

  Widget createActivityPanelActionButtons() {
    return SizedBox(
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                  side: BorderSide(width: 1, color: Colors.grey.shade300)),
              child: const Text("Edit"),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return const NewActivityDialog();
                    });
                setState(() {});
              },
              child: const Text("New Activity"),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showConfirmDeletionDialog(String keyToDelete) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: kDialogShape,
        title: const Text("Delete Activity?"),
        content:
            const Text("This will also delete any entries of this activity."),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.redAccent,
              onPrimary: Colors.white,
            ),
            onPressed: () async {
              await Provider.of<ActivityBase>(context, listen: false)
                  .deleteActivity(keyToDelete)
                  .then((value) => Navigator.of(context).pop());
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
