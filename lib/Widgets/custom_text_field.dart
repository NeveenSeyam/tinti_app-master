import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Widgets/text_field_container.dart';

import '../Util/theme/app_colors.dart';

// ignore: must_be_immutable
class RoundedInputField extends StatefulWidget {
  final String hintText;
  double? height;
  double? width;
  Color? color;
  Color? borderColor;
  double? circuler;
  bool? isObscured;
  Color? hintColor;
  Icon? icon;
  int? linght;
  String? Function(String?)? validator;
  TextEditingController? controller;
  final ValueChanged<String> onChanged;
  bool? seen;
  RoundedInputField(
      {required this.hintText,
      this.hintColor,
      required this.seen,
      required this.onChanged,
      this.height,
      this.validator,
      this.controller,
      this.isObscured = false,
      this.width,
      this.color,
      this.borderColor,
      this.circuler,
      this.icon,
      this.linght});

  @override
  State<RoundedInputField> createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  bool _isObscure = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFieldContainer(
        height: widget.height,
        width: widget.width,
        color: widget.color,
        borderColor: widget.borderColor,
        circuler: 10.w,
        child: TextFormField(
          obscureText: _isObscure,
          controller: widget.controller,
          maxLines: widget.linght ?? 1,
          validator: widget.validator ??
              (value) {
                return null;
              },
          cursorColor: AppColors.primaryColor,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            suffixIcon: widget.seen == true
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.hint,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    })
                : null,
            icon: widget.icon ?? null,
            hintText: widget.hintText,
            // alignLabelWithHint: true,
            hintStyle: TextStyle(
              fontFamily: 'DINNEXTLTARABIC',
              color:
                  widget.hintColor ?? AppColors.primaryColor.withOpacity(0.6),
              fontSize: 14.sp,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
