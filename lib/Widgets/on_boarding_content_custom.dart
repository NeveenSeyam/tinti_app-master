import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_svg_image/cached_svg_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

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
            child: SvgPicture.network(
              image,
              height: 360.h,
              width: 300,
              fit: BoxFit.fill,
              placeholderBuilder: (context) {
                return Container(
                    height: 360.h,
                    width: 300,
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                      strokeWidth: 1,
                    ));
              },
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
              maxLines: 5,
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
