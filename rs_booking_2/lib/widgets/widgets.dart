// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'dart:math' as math show max;

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height + 5);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ColumnBuilder extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final VerticalDirection verticalDirection;
  final int itemCount;
  final IndexedWidgetBuilder? separator;

  const ColumnBuilder({
    required this.itemBuilder,
    required this.itemCount,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    Key? key,
  })  : separator = null,
        super(key: key);

  const ColumnBuilder.separator({
    required this.itemBuilder,
    required this.itemCount,
    required this.separator,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.verticalDirection = VerticalDirection.down,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: crossAxisAlignment,
    mainAxisSize: mainAxisSize,
    mainAxisAlignment: mainAxisAlignment,
    verticalDirection: verticalDirection,
    children: List<Widget>.generate(
      separator != null ? _computeActualChildCount(itemCount) : itemCount,
          (index) {
        final separatorBuilder = separator;
        if (separatorBuilder == null) {
          return itemBuilder(context, index);
        } else {
          final itemIndex = index ~/ 2;
          final widget = index.isEven
              ? itemBuilder(context, itemIndex)
              : separatorBuilder(context, itemIndex);
          return widget;
        }
      },
    ).toList(),
  );
}

// Helper method to compute the actual child count for the
// separated constructor.
int _computeActualChildCount(int itemCount) => math.max(0, itemCount * 2 - 1);

Widget _bottomWave() {
  return Expanded(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: ClipPath(
        clipper: BottomWaveClipper(),
        child: Container(
          color: Colors.white,
          height: 300,
        ),
      ),
    ),
  );
}

Widget _logo() {
  return const Padding(
    padding: EdgeInsets.only(top: 100),
    child: Align(
      child: Text(
        'RS-booking',
        style: TextStyle(
            fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ),
  );
}
