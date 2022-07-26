import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/current_day_model.dart';
import 'package:grid_planner_test/screens/grid_planner_draggable.dart';
import 'package:provider/provider.dart';
import 'model/activity_base.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CurrentDayModel()),
      ChangeNotifierProvider(create: (context) => ActivityBase()),
    ],
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(
        brightness: Brightness.dark,

      ),
      theme: ThemeData(
        splashFactory: InkRipple.splashFactory,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
      ),
      home: const GridPlannerDrag(),
    );
  }
}
