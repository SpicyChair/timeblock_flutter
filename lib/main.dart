import 'package:flutter/material.dart';
import 'package:grid_planner_test/model/current_day_model.dart';
import 'package:grid_planner_test/model/gridview_controller.dart';
import 'package:grid_planner_test/model/saved_activity.dart';
import 'package:grid_planner_test/screens/grid_planner_screen.dart';
import 'package:grid_planner_test/screens/loading_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'model/activity_base.dart';

void main() async {
  //initialise Hive persistence
  await Hive.initFlutter();
  Hive.registerAdapter(SavedActivityAdapter());
  Hive.registerAdapter(SavedDayAdapter());
  await Hive.openBox<SavedActivity>('activities');
  await Hive.openBox<Map<int, String>>("saved_days");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrentDayModel()),
        ChangeNotifierProvider(create: (context) => ActivityBase()),
        ChangeNotifierProvider(
            create: (context) => GridPlannerControllerProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
        useMaterial3: true, colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(secondary: Colors.blueAccent),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(brightness: Brightness.light).copyWith(secondary: Colors.blueAccent),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoadingScreen(),
    );
  }
}
