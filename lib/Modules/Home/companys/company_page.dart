import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/custom_appbar.dart';
import 'package:tinti_app/Widgets/custom_text_field.dart';

import '../../../Widgets/custom_text.dart';

class CampanyPage extends StatefulWidget {
  const CampanyPage({super.key});

  @override
  State<CampanyPage> createState() => _CampanyPageState();
}

class _CampanyPageState extends State<CampanyPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          'مزودي الخدمة',
          isHome: true,
          isNotification: false,
        ),
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedInputField(
              hintText: 'بحث',
              seen: false,
              hintColor: AppColors.scadryColor,
              onChanged: (val) {},
              icon: const Icon(
                Icons.search,
                color: AppColors.scadryColor,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsetsDirectional.only(
                  start: 18.w, bottom: 12.h, top: 20.h, end: 18.w),
              child: CustomText(
                'الخدمات',
                color: AppColors.scadryColor,
                fontWeight: FontWeight.w400,
                fontFamily: 'DINNextLTArabic',
                fontSize: 18.sp,
              ),
            ),
            SizedBox(
              width: 370.w,
              height: 100.h,
              child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 100.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.w),
                              color: AppColors.orange.withOpacity(0.5)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.w),
                                  child: Image.asset(
                                    'assets/images/sa1.jpeg',
                                    width: 70.w,
                                  ),
                                ),
                              ),
                              CustomText(
                                'نانو سيراميك',
                                color: AppColors.scadryColor,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'DINNextLTArabic',
                                fontSize: 12.sp,
                              ),
                            ],
                          ),
                        ),
                      )),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsetsDirectional.only(
                  start: 18.w, bottom: 12.h, top: 20.h, end: 18.w),
              child: CustomText(
                'الخدمات',
                color: AppColors.scadryColor,
                fontWeight: FontWeight.w400,
                fontFamily: 'DINNextLTArabic',
                fontSize: 18.sp,
              ),
            ),
            SizedBox(
              width: 370.w,
              height: 400.h,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      childAspectRatio: 2 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: 9,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.popAndPushNamed(context, '/company_profile');
                      },
                      child: Stack(
                        children: [
                          Center(
                              child: Image.asset(
                            'assets/images/company_card.png',
                            fit: BoxFit.fill,
                          )),
                          Center(
                            child: Container(
                              width: 100.w,
                              height: 100.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.w),
                                    child: Image.asset(
                                      'assets/images/j_and_j.png',
                                      width: 50.w,
                                    ),
                                  ),
                                  CustomText(
                                    'جونسون اند جونسون ',
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'DINNextLTArabic',
                                    fontSize: 12.sp,
                                  ),
                                  CustomText(
                                    'جدة ',
                                    color: AppColors.orange,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'DINNextLTArabic',
                                    fontSize: 12.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
