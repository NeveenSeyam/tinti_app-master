import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Util/theme/app_colors.dart';

class authScreens extends StatelessWidget {
  Widget child;
  Widget header;
  authScreens({
    required this.child,
    required this.header,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.orange,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.h),
            child: Container(alignment: Alignment.topCenter, child: header),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 47, 47, 47).withOpacity(0.5),
                    spreadRadius: 4,
                    blurRadius: 10,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35.w),
                  topRight: Radius.circular(35.w),
                )),
            height: 690.h,
            alignment: Alignment.bottomCenter,
            child: child,
          ),
        ],
      ),
    ));
  }
}
