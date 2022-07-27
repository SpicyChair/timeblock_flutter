import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../model/activity_base.dart';

class NewActivityDialog extends StatefulWidget {
  const NewActivityDialog({Key? key}) : super(key: key);

  @override
  State<NewActivityDialog> createState() => _NewActivityDialogState();
}

class _NewActivityDialogState extends State<NewActivityDialog> {
  Color pickerColor = Colors.blueAccent;
  Color currentColor = Colors.blueAccent;
  String newActivityName = "";
  String emojiIcon = "";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "New Activity",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextField(
                  onChanged: (newValue) {
                    setState(() {
                      newActivityName = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    hintText: 'Enter activity name',
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel")),
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Provider.of<ActivityBase>(context, listen: false)
                              .createNewActivity(newActivityName, currentColor);

                          Navigator.of(context).pop();
                        },
                        child: const Text('Create Activity'),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: -100,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: currentColor,
              ),
              child: Center(
                child: Text(
                  emojiIcon,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openColorPicker() async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlockPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (Color color) {
                    setState(() {
                      pickerColor = color;
                      currentColor = color;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() => currentColor = pickerColor);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Select'),
                ),
              ],
            ));
      },
    );
  }
}
