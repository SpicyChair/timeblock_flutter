import 'package:flutter/material.dart';
//import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import '../constants.dart';
import '../model/activity_base.dart';
import '';

class NewActivityDialog extends StatefulWidget {
  const NewActivityDialog({Key? key}) : super(key: key);

  @override
  State<NewActivityDialog> createState() => _NewActivityDialogState();
}

class _NewActivityDialogState extends State<NewActivityDialog> {
  Color pickerColor = Colors.blueAccent;
  String emojiIcon = "";
  String newActivityName = "";

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: kDialogShape,
        title: const Text('New Activity'),
        content: SizedBox(
          height: 140,
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              /*
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

               */
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: kMediumBorderRadius,
                ),
                tileColor: pickerColor,
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
                  .createNewActivity(newActivityName, pickerColor);

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
      color: pickerColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) =>
          setState(() => pickerColor = color),
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

}
