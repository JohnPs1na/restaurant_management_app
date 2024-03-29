// ignore: file_names
import 'package:flutter/material.dart';
import 'package:restaurant_management_app/bin/constants.dart' as constants;

import '../entities/table_list.dart';

/// Movable table object
///
class MovableTableWidget extends StatefulWidget {
  final BoxConstraints constraints; //widget constraints received as parameter
  final String imagePath; //the corresponding table's image path
  final int _imageWidth; // width of the displayed image
  final int imageHeight; // height of the displayed image
  final int tableSize;
  final String id;
  final int floor;
  final Offset
      position; // position relative to the top left corner of the container
  MovableTableWidget({
    Key? key,
    required this.constraints,
    required this.tableSize,
    required this.position,
    required this.id,
    required this.floor,
  })  : imagePath = getImagePath(tableSize),
        _imageWidth = getImageSize(tableSize)[0],
        imageHeight = getImageSize(tableSize)[1],
        super(key: key);

  @override
  State<MovableTableWidget> createState() => _MovableTableWidgetState();
}

class _MovableTableWidgetState extends State<MovableTableWidget> {
  late Offset _position;

  @override
  void initState() {
    super.initState();
    _position = widget.position;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: Draggable(
        // image displayed under the mouse while dragging
        feedback: Image(
            image: AssetImage(widget.imagePath + ".png"),
            width: widget._imageWidth.toDouble(),
            height: widget.imageHeight.toDouble()),
        // image displayed normally
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(widget.imagePath + ".png"),
              width: widget._imageWidth.toDouble(),
              height: widget.imageHeight.toDouble(),
            ),
            Text(
              widget.id,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        //image displayed at the table position while moving it
        childWhenDragging: Image(
            image:
                AssetImage(widget.imagePath + constants.feedbackPath + ".png"),
            width: widget._imageWidth.toDouble(),
            height: widget.imageHeight.toDouble()),
        onDragEnd: (DraggableDetails details) {
          setState(() {
            final adjustmenty = MediaQuery.of(context).size.height -
                widget.constraints.maxHeight -
                constants.floorMargin;
            final adjustmentx = MediaQuery.of(context).size.width -
                widget.constraints.maxWidth -
                constants.floorMargin;
            // details.offset is relative to the window instead of the container
            // => without this the item would be placed too low because of the app bar
            // + margin of the container

            //check if the position is inside the container: right, left, top, bottom
            if (details.offset.dx + widget._imageWidth <
                    MediaQuery.of(context).size.width &&
                details.offset.dx > 0 + adjustmentx &&
                details.offset.dy > 0 + adjustmenty &&
                details.offset.dy + widget.imageHeight + constants.floorMargin <
                    MediaQuery.of(context).size.height) {
              double xOffset = details.offset.dx - adjustmentx;
              double yOffset = details.offset.dy - adjustmenty;

              _position = Offset(xOffset, yOffset);

              TableList.editTablePosition(widget.id, xOffset, yOffset);
            }
          });
        },
      ),
    );
  }
}

/// Receives a table size and returns the path to the corresponding image
///
/// @param tableSize: size of the table
/// @note image paths are without extension
String getImagePath(int tableSize) {
  switch (tableSize) {
    case 2:
      return constants.twoTablePath;
    case 3:
      return constants.threeTablePath;
    case 4:
      return constants.fourTablePath;
    case 6:
      return constants.sixTablePath;
    case 8:
      return constants.eightTablePath;
  }

  throw Exception("Invalid table size!");
}

/// Receives a table size and returns a list containing the required dimensions
///
///@param tableSize: the size of the table
///@returns List<int> containing [0] = width and [1] = height
List<int> getImageSize(int tableSize) {
  const List<int> smallTable = [
    constants.smallTableWidth,
    constants.smallTableWidth
  ];
  const List<int> largeTable = [
    constants.largeTableWidth,
    constants.smallTableWidth
  ];

  switch (tableSize) {
    case 2:
      return smallTable;
    case 3:
      return smallTable;
    case 4:
      return smallTable;
    case 6:
      return largeTable;
    case 8:
      return largeTable;
  }

  throw Exception("Invalid table size!");
}
