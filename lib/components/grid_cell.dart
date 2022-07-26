import 'package:flutter/material.dart';

class GridCell extends StatefulWidget {
  const GridCell({Key? key, required this.cellColor, required this.activated}) : super(key: key);

  final Color cellColor;
  final bool activated;

  @override
  State<GridCell> createState() => _GridCellState();

}
class _GridCellState extends State<GridCell> {

  final double borderRadiusValue = 5;


  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: widget.activated ? widget.cellColor : Colors.grey,
        borderRadius: BorderRadius.circular(borderRadiusValue),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          splashColor: Colors.white.withOpacity(0.5),
          onTap: () {
            //activated = !activated;
            //setState((){});
          },
          child: Container(
            decoration: const BoxDecoration(),
          ),
        ),
      ),
    );
  }
}