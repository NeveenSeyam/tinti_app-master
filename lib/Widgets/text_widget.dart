import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextWidget extends StatelessWidget {
  final String title;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final double? fontSize;
  final TextOverflow? overflow;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final int? maxLines;

  const TextWidget(
    this.title, {
    Key? key,
    this.textAlign,
    this.textDirection,
    this.fontSize,
    this.overflow,
    this.fontWeight,
    this.maxLines,
    this.fontFamily,
    this.color = Colors.black,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.caption!.copyWith(
          color: color,
          fontWeight: fontWeight,
          fontSize: 10.sp,
          fontFamily: fontFamily ?? 'Cairo'),
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection,
      overflow: overflow ?? TextOverflow.visible,
    );
  }
}
