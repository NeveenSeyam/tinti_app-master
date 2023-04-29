import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PageViewIndicatorCustomHome extends StatelessWidget {
  const PageViewIndicatorCustomHome({
    super.key,
    required this.isCurrentPage,
    this.marginEnd = 0,
  });
  final bool isCurrentPage;
  final double marginEnd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 5.w),
      child: Container(
        height: 5.h,
        width: isCurrentPage ? 15.w : 7.w,
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
