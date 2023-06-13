import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Modules/Home/companys/company-profile.dart';
import 'custom_button.dart';

class OnBoardingContentHome extends StatelessWidget {
  final String image;
  final String text;
  final String about;
  final int id;

  const OnBoardingContentHome({
    super.key,
    required this.image,
    required this.text,
    required this.about,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: 'DINNextLTArabic',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Container(
                    width: 180.w,
                    child: Text(
                      about,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontFamily: 'DINNextLTArabic',
                        color: const Color(0xff042D4D),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    width: 120.w,
                    height: 30.h,
                    child: CustomButton(
                      onpressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CompanyProfile(
                                  id: id,
                                  name: text,
                                  about: about,
                                  img: image,
                                )));
                      },
                      backgroundColor: const Color(0xffF57A38),
                      childWidget: Text(
                        'more'.tr(),
                        style: GoogleFonts.cairo(
                          color: const Color(0xffFFFFFF),
                          fontSize: 11.sp,
                        ),
                      ),
                      width: 135.w,
                      height: 15.h,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    image,
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                    width: 130.h,
                    height: 130.h,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
