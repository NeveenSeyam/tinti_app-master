import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'custom_button.dart';

class ServiesImages extends StatelessWidget {
  final String image;

  const ServiesImages({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Center(
                        child: Image.network(
                          image,
                          alignment: Alignment.center,
                          fit: BoxFit.fill,
                          width: 170.w,
                          height: 130.h,
                        ),
                      ),
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
