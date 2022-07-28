import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../model/activity_base.dart';

class NewActivityDialog extends StatefulWidget {
  const NewActivityDialog({Key? key}) : super(key: key);

  @override
  State<NewActivityDialog> createState() => _NewActivityDialogState();
}

class _NewActivityDialogState extends State<NewActivityDialog> {

  Color pickerColor = Colors.blueAccent;
  Color currentColor = Colors.blueAccent;
  String emojiIcon = "";
  String newActivityName = "";

  @override
  Widget build(BuildContext context) {
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
