import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnBoardingContentCustom extends StatelessWidget {
  final String image;
  const OnBoardingContentCustom({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/$image.png',
            alignment: Alignment.center,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 47.9.h,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20.w,
            ),
            child: Text(
              'Welcome again!',
              style: TextStyle(
                fontSize: 22,
                fontFamily: 'DINNextLTArabic',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 6.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur\nadipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna\n aliqua. Ut enim ad minim veniam',
              maxLines: 3,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'DINNextLTArabic',
                color: const Color(0xff042D4D),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
