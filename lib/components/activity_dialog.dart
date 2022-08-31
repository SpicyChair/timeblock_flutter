import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/saved_activity.dart';
//import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import '../constants.dart';
import '../model/activity_base.dart';
import '';

class ActivityDialog extends StatefulWidget {
  bool edit;
  String _activityKey = "";
  SavedActivity? activity;

  Color _pickerColor = Colors.blueAccent;
  String _newActivityName = "";

  ActivityDialog({Key? key, this.edit = false, this.activity})
      : super(key: key) {
    if (edit && activity != null) {
      _pickerColor = activity?.getColor() ?? Colors.blueAccent;
      _newActivityName = activity?.name ?? "";
      _activityKey = activity?.key ?? "";
    }
  }

  @override
  State<ActivityDialog> createState() => _ActivityDialogState();
}

class _ActivityDialogState extends State<ActivityDialog> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: kDialogShape,
        title: widget.edit
            ? const Text('Edit Activity')
            : const Text('New Activity'),
        content: SizedBox(
          height: 140,
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: kMediumBorderRadius,
                ),
                tileColor: widget._pickerColor,
                title: const Center(child: Text("Change Color")),
                onTap: () async {
                  await colorPickerDialog();
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: TextEditingController()
                  ..text = widget._newActivityName,
                onChanged: (newValue) {
                  widget._newActivityName = newValue;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.0),
                    borderRadius: kMediumBorderRadius,
                  ),
                  labelText: 'Enter activity name',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[

          Visibility(
            visible: widget.edit,
            child: TextButton(
              style: TextButton.styleFrom(
                primary: Colors.redAccent,
              ),
              onPressed: () async {
                final navigator = Navigator.of(context);
                await showConfirmDeletionDialog(widget._activityKey);
                navigator.pop();
              },
              child: const Text('Delete Activity'),
            ),
          ),

          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),

          widget.edit
              ? ElevatedButton(
                  onPressed: () {
                    Provider.of<ActivityBase>(context, listen: false)
                        .editActivity(widget._activityKey, widget._pickerColor,
                            widget._newActivityName);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'))
              : ElevatedButton(
                  onPressed: () {
                    Provider.of<ActivityBase>(context, listen: false)
                        .createNewActivity(
                            widget._newActivityName, widget._pickerColor);

                    Navigator.of(context).pop();
                  },
                  child: const Text('Create Activity'),
                ),
        ],
      );
    });
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      // Use the dialogPickerColor as start color.
      color: widget._pickerColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) =>
          setState(() => widget._pickerColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.caption,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: false,
      },
    ).showPickerDialog(
      context,
      shape: kDialogShape,
      constraints:
          const BoxConstraints(minHeight: 400, minWidth: 300, maxWidth: 320),
    );
  }

  Future<void> showConfirmDeletionDialog(String keyToDelete) async {
    await showDialog(
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
