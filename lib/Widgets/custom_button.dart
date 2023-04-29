import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  Function() onpressed;
  final double width;
  final double height;
  OutlinedBorder shape;
  final Color backgroundColor;
  final Widget childWidget;
  CustomButton({
    super.key,
    required this.onpressed,
    required this.width,
    required this.height,
    required this.childWidget,
    required this.shape,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
          shape: shape,
          elevation: 0.0,
          backgroundColor: backgroundColor,
          minimumSize: Size(width.w, height.h)),
      child: childWidget,
    );
  }
}
