import 'dart:ui';

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  double? height,width;
  Color color;
  Widget child;
  VoidCallback onTap;

   CustomButton({super.key, required this.onTap, this.height,  this.width, required this.child, required this.color });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4)
        ),
        child: child,
      ),
    );
  }
}
