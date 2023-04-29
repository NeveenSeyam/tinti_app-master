import 'package:flutter/material.dart';

import '../Util/theme/app_colors.dart';

class CustomText extends StatelessWidget {
  final String title;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final double? fontSize;
  final TextOverflow? overflow;
  final Color? color;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final int? maxLines;

  const CustomText(
    this.title, {
    Key? key,
    this.textAlign,
    this.textDirection,
    this.fontSize,
    this.overflow,
    this.fontWeight,
    this.maxLines,
    this.fontFamily,
    this.color = AppColors.black,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      style: Theme.of(context).textTheme.caption!.copyWith(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize ?? 16,
          fontFamily: fontFamily ?? 'SfPro'),
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection,
      overflow: overflow ?? TextOverflow.visible,
    );
  }
}
