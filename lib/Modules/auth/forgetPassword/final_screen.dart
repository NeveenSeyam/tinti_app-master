import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:regexpattern/regexpattern.dart';

import '../../../Util/theme/app_colors.dart';
import '../../../Widgets/custom_text.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/gradint_button.dart';

class FinalForgetScreen extends StatefulWidget {
  const FinalForgetScreen({super.key});

  @override
  State<FinalForgetScreen> createState() => _FinalForgetScreenState();
}

final GlobalKey<FormState> _key = GlobalKey<FormState>();

String? validateEmail(String? value) {
  if (!value!.isEmail() && value.isEmpty) {
    return 'لو سمحت ادخل بريدك الالكتروني';
  }
}

class _FinalForgetScreenState extends State<FinalForgetScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: AppColors.scadryColor,
        body: Form(
          key: _key,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.h),
                child: Container(
                  alignment: Alignment.topCenter,
                  height: 80.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        ' نسيت كلمة السر ',
                        textAlign: TextAlign.start,
                        fontSize: 18.sp,
                        fontFamily: 'DINNEXTLTARABIC',
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 47, 47, 47)
                                .withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                        color: AppColors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.w),
                          topRight: Radius.circular(35.w),
                        )),
                    height: 700.h,
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 10.w),
                            alignment: Alignment.centerRight,
                            child: CustomText(
                              'تم تعيين كلمة المرور بنجاح',
                              textAlign: TextAlign.start,
                              fontSize: 18.sp,
                              fontFamily: 'DINNEXTLTARABIC',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Image.asset(
                            'assets/images/forget_pass/final_step.png',
                            fit: BoxFit.fill,
                            height: 35.h,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Image.asset(
                            'assets/images/forget_pass/done.png',
                            height: 350.h,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            height: 28.h,
                          ),
                          RaisedGradientButton(
                            text: 'تسجيل دخول',
                            color: AppColors.scadryColor,
                            height: 48.h,
                            width: 340.w,
                            circular: 10.w,
                            onPressed: () {
                              Navigator.popAndPushNamed(
                                  context, '/login_screen');
                            },
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
