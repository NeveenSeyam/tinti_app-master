import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Util/theme/app_colors.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  double? height;
  double? width;
  Color? color;
  Color? borderColor;
  double? circuler;
  TextFieldContainer(
      {required this.child,
      this.height,
      this.width,
      this.color,
      this.circuler,
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      width: width ?? 340.w,
      decoration: BoxDecoration(
          color: color ?? AppColors.white,
          borderRadius: BorderRadius.circular(circuler ?? 5),
          border: Border.all(color: borderColor ?? Colors.white)),
      child: child,
    );
  }
}
