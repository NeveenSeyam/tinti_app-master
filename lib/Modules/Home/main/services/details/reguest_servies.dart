import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:tinti_app/Widgets/button_widget.dart';
import 'package:tinti_app/Widgets/custom_appbar.dart';
import 'package:tinti_app/Widgets/custom_text_field.dart';

import '../../../../../Widgets/cash_image.dart';
import '../../../../../Widgets/custom_text.dart';
import '../../../../../Widgets/gradint_button.dart';

class RequestServieses extends StatefulWidget {
  const RequestServieses({super.key});

  @override
  State<RequestServieses> createState() => _RequestServiesesState();
}

class _RequestServiesesState extends State<RequestServieses> {
  bool isFav = true;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          'طلب الخدمة',
          isHome: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ListView(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.w),
                    decoration: BoxDecoration(
                        color: AppColors.orange,
                        borderRadius: BorderRadius.circular(10.w)),
                    child: Icon(
                      Icons.add,
                      color: AppColors.white,
                      size: 40.w,
                    ),
                  ),
                  Container(
                    width: 280.w,
                    height: 200.h,
                    child: SizedBox(
                      // width: 350.w,
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        // controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (int currentPage) {
                          // setState(() => _currentPage = currentPage);
                        },
                        children: const [
                          CachImage(
                            image: 'credit-card-1',
                          ),
                          CachImage(
                            image: 'credit-card-2',
                          ),
                          CachImage(
                            image: 'credit-card',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'نانو سيراميك',
                        color: AppColors.scadryColor,
                        fontSize: 18.sp,
                        fontFamily: 'DINNextLTArabic',
                        textAlign: TextAlign.start,
                      ),
                      CustomText(
                        'جونسون اند جونسون ',
                        color: AppColors.orange,
                        fontSize: 14.sp,
                        fontFamily: 'DINNextLTArabic',
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        child: isFav == true
                            ? Icon(
                                Icons.star_rate_rounded,
                                color: AppColors.orange,
                                size: 32.w,
                              )
                            : Icon(
                                Icons.star_rate_rounded,
                                color: AppColors.orange,
                                size: 32.w,
                              ),
                        onTap: () {
                          setState(() {
                            isFav == true ? isFav = false : isFav = true;
                          });
                        },
                      ),
                      CustomText(
                        ' 4.2  ',
                        color: AppColors.scadryColor,
                        fontSize: 18.sp,
                        fontFamily: 'DINNextLTArabic',
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              CustomText(
                fontFamily: 'DINNEXTLTARABIC',
                color: AppColors.scadryColor,
                'تلعب العناية المنتظمة بالسيارة دورا كبيرا في المحافظة على السيارات وهذا هو السبب الذي يجعل بعض السيارات تستمر في العمل بشكل جيد',
                fontSize: 14.sp,
              ),
              RoundedInputField(
                hintText: 'رقم البطاقة',
                hintColor: AppColors.grey.withOpacity(0.5),
                seen: false,
                width: 350.w,
                onChanged: ((value) {}),
                borderColor: AppColors.grey.withOpacity(0.2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RoundedInputField(
                      hintText: 'تاريخ الانتهاء ',
                      width: 170.w,
                      hintColor: AppColors.grey.withOpacity(0.5),
                      seen: false,
                      borderColor: AppColors.grey.withOpacity(0.2),
                      onChanged: ((value) {})),
                  RoundedInputField(
                    hintColor: AppColors.grey.withOpacity(0.5),
                    hintText: 'cvv ',
                    seen: false,
                    borderColor: AppColors.grey.withOpacity(0.2),
                    onChanged: ((value) {}),
                    width: 170.w,
                  ),
                ],
              ),
              RoundedInputField(
                  borderColor: AppColors.grey.withOpacity(0.2),
                  hintColor: AppColors.grey.withOpacity(0.5),
                  hintText: 'الاسم ',
                  width: 350.w,
                  seen: false,
                  onChanged: ((value) {})),
              RoundedInputField(
                  hintText: 'اختر السيارة ',
                  width: 350.w,
                  hintColor: AppColors.grey.withOpacity(0.5),
                  seen: false,
                  borderColor: AppColors.grey.withOpacity(0.2),
                  onChanged: ((value) {})),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RaisedGradientButton(
                    color: AppColors.scadryColor,
                    textColor: AppColors.white,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            // Future.delayed(
                            //     Duration(seconds: 1000), () {
                            //   Navigator.of(context).pop(true);
                            // });
                            return AlertDialog(
                                insetPadding: EdgeInsets.all(8.0),
                                content: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.w)),
                                    width:
                                        MediaQuery.of(context).size.width - 200,
                                    height: 100.h,
                                    child: Center(
                                      child: CustomText(
                                        'تمت العملية بنجاح',
                                        textAlign: TextAlign.center,
                                        fontFamily: 'DINNEXTLTARABIC',
                                        fontSize: 16.sp,
                                        color: AppColors.scadryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )));
                          });
                    },
                    text: 'تنفيذ',
                    circular: 10.w,
                    width: 280.w,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 185, 184, 184)
                              .withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: CustomText(
                      ' 100 \$',
                      color: AppColors.orange,
                      fontSize: 18.sp,
                      fontFamily: 'DINNextLTArabic',
                      textAlign: TextAlign.start,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
