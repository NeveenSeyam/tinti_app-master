import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter/material.dart';

import '../Util/constants/constants.dart';
import '../Util/theme/app_colors.dart';
import 'custom_text.dart';

class ButtonWidget extends StatelessWidget {
  final String? title;
  final VoidCallback? onPressed;
  final Color? textColor, borderColor, disabledColor;
  final Color backgroundColor;
  final double shapeRadius;
  final double elevation;
  final double? fontSize;
  final double verticalTextPadding;
  final double horizontalTextPadding;
  final TextDirection? textDirection;
  final FontWeight? fontWeight;
  final Widget? widget;
  final double? width;
  final double? height;

  const ButtonWidget(
      {Key? key,
      this.title,
      required this.onPressed,
      this.textColor,
      this.borderColor,
      this.backgroundColor = AppColors.primaryColor,
      this.elevation = 0,
      this.fontSize,
      this.verticalTextPadding = Constants.padding / 2,
      this.horizontalTextPadding = Constants.padding / 2,
      this.shapeRadius = 8,
      this.disabledColor,
      this.widget,
      this.fontWeight,
      this.textDirection,
      this.width,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(elevation),
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(
            horizontal: horizontalTextPadding, vertical: verticalTextPadding)),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return backgroundColor.withOpacity(0.9);
            } else if (states.contains(MaterialState.disabled)) {
              return AppColors.white;
            }
            return backgroundColor;
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                side: BorderSide(color: borderColor ?? Colors.transparent),
                borderRadius: BorderRadius.circular(shapeRadius))),
      ),
      onPressed: onPressed,
      child: widget ??
          Container(
            width: width ?? double.infinity,
            height: height ?? 40.h,
            padding: EdgeInsets.symmetric(
                horizontal: horizontalTextPadding,
                vertical: verticalTextPadding),
            child: Center(
              child: CustomText(
                title!,
                textDirection: textDirection,
                color: textColor ?? AppColors.black,
                fontSize: fontSize ?? 16,
                fontWeight: fontWeight ?? FontWeight.normal,
              ),
            ),
          ),
    );
  }
}
