import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';

import 'custom_text.dart';

class RaisedGradientButton extends StatelessWidget {
  final String text;
  final Gradient? gradient;
  final double? width;
  final double? height;
  final VoidCallback onPressed;
  final double? border;
  final double? circular;
  final Color? color;
  final Color? textColor;

  const RaisedGradientButton({
    Key? key,
    this.color,
    required this.text,
    this.gradient,
    this.border,
    this.circular,
    this.width,
    this.height,
    this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width ?? 280.w,
        height: height ?? 48.h,
        decoration: BoxDecoration(
          color: color, // color: const Color(0xff7c94b6),
          border: Border.all(width: border ?? 0, color: AppColors.white),
          borderRadius: BorderRadius.circular(circular ?? 0),
        ),
        child: Center(
            child: InkWell(
          child: CustomText(
            text,
            color: textColor ?? AppColors.white,
            fontFamily: 'DINNEXTLTARABIC',
            fontSize: 14.sp,
          ),
          // textColor: color,
        )),
      ),
    );
  }
}
