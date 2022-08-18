import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/current_day_model.dart';
import 'package:grid_planner_test/model/gridview_controller.dart';
import 'package:grid_planner_test/screens/grid_planner_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'model/activity_base.dart';

void main() async {
  //initialise Hive persistence
  await Hive.initFlutter();
  await Hive.openBox('activities');
  //await Hive.openBox('testBox');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CurrentDayModel()),
      ChangeNotifierProvider(create: (context) => ActivityBase()),
      ChangeNotifierProvider(create: (context) => GridPlannerControllerProvider()),
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const GridPlannerScreen(),
    );
  }
}
