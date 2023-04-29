import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Util/theme/app_colors.dart';
import 'custom_button.dart';

class CachImage extends StatelessWidget {
  final String image;

  const CachImage({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/$image.png',
                      alignment: Alignment.center,
                      fit: BoxFit.fill,
                      width: 250.w,
                      height: 160.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
