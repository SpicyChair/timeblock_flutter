import 'package:flutter/material.dart';
import 'package:grid_planner_test/components/new_activity_dialog.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../model/activity_base.dart';
import '../model/saved_activity.dart';
import 'activity_tile.dart';

class SlidingPanel extends StatefulWidget {
  const SlidingPanel({Key? key, required this.selectedIndexes}) : super(key: key);

  final Function selectedIndexes;

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
          createSlideUpIndicator(),
          const SizedBox(
            height: 30,
          ),
          createSelectedTitle(),
          createSelectActivityPanel(),
          const SizedBox(
            height: 20,
          ),
          createActivityPanelActionButtons(),
        ],
      ),
    );


  }

  Widget createSlideUpIndicator() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: const BorderRadius.all(
            Radius.circular(24.0),
          ),
        ),
        height: 5,
        width: 50,
      ),
    );
  }

  Widget createSelectedTitle() {
    if (widget.selectedIndexes().isEmpty) {
      return const Text("Current Activity: ");
    }
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        children: <TextSpan>[
          const TextSpan(text: 'Selected: '),
          TextSpan(
              text: '${widget.selectedIndexes().length}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
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
        height: 275,
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
                  SavedActivity activity = activityBase.activities[index];
                  return ActivityTile(
                    title: activity.name,
                    icon: "",
                    color: activity.color,
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
                await showDialog(context: context, builder: (context) {
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
}
