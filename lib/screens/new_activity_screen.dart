import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NewActivityScreen extends StatefulWidget {
  NewActivityScreen({Key? key}) : super(key: key);

  @override
  State<NewActivityScreen> createState() => _NewActivityScreenState();
}

class _NewActivityScreenState extends State<NewActivityScreen> {
  Color pickerColor = Colors.blueAccent;
  Color currentColor = Colors.blueAccent;
  String newActivityName = "";
  String emojiIcon = "";

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
              child: const Text('Select'),
            ),
          ],
          insetPadding: EdgeInsets.zero,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: currentColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
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
        ],
      ),
    );
  }
}
