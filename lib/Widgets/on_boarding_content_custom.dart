import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingContentCustom extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  const OnBoardingContentCustom({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            width: double.infinity,
            child: Image.network(
              image,
              height: 360.h,
              width: 300,
              fit: BoxFit.fill,
              // placeholder: (context, url) => new CircularProgressIndicator(),
              // errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
          SizedBox(
            height: 47.9.h,
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 16.w,
            ),
            child: Text(
              title ?? ' أهلاً بك',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 22.sp,
                fontFamily: 'DINNextLTArabic',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 6.h,
          ),
          Padding(
            padding: EdgeInsets.only(right: 18.w, left: 16.w),
            child: Text(
              description ??
                  'تلعب العناية المنتظمة بالسيارة دورا كبيرا في المحافظة على السيارات وهذا هو السبب الذي يجعل بعض السيارات تستمر في العمل بشكل جيد',
              maxLines: 3,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'DINNextLTArabic',
                color: const Color(0xff042D4D),
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
