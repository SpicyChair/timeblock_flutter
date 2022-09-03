import 'package:flutter/material.dart';
import 'package:grid_planner_test/screens/home_screen.dart';
import 'package:grid_planner_test/screens/todo_list_screen.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({Key? key}) : super(key: key);

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt_rounded),
            label: 'Tasks',
          ),
        ],
      ),

      body: <Widget>[
        const HomeScreen(),
        const TodoListScreen(),
      ][currentPageIndex],

    );
  }
}
