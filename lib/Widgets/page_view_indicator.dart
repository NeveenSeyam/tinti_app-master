import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageViewIndicatorCustom extends StatelessWidget {
  const PageViewIndicatorCustom({
    super.key,
    required this.isCurrentPage,
    this.marginEnd = 0,
  });
  final bool isCurrentPage;
  final double marginEnd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 20.w),
      child: Container(
        height: 5.h,
        width: isCurrentPage ? 33.w : 18.w,
        margin: EdgeInsetsDirectional.only(end: marginEnd),
        decoration: BoxDecoration(
          color:
              isCurrentPage ? const Color(0xffF57A38) : const Color(0xffCCCCCC),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
