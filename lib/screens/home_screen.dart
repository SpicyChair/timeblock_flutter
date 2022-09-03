import 'package:flutter/material.dart';
import 'package:grid_planner_test/constants.dart';
import 'package:hive/hive.dart';

import 'grid_planner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 60,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.settings_outlined))
                ],
              ),
            ),
            Text(
              "Good Morning",
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
              child: Text(
                "How will you spend your time?",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 250,
              decoration: BoxDecoration(
                //TODO: SHOW SUMMARY OF DAY
                  color: Theme.of(context).cardColor,
                  borderRadius: kHomeScreenTileBorderRadius),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 70,
              child: Material(
                color: Theme.of(context).cardColor,
                borderRadius: kHomeScreenTileBorderRadius,
                child: InkWell(
                  borderRadius: kHomeScreenTileBorderRadius,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GridPlannerScreen()));
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      title: Text(
                        "Plan your day",
                        //textAlign: TextAlign.start,
                      ),
                      trailing: Icon(
                        Icons.navigate_next_outlined,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    ));
  }
}
