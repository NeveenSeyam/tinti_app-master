import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:pinput/pinput.dart';

import '../../../Util/theme/app_colors.dart';
import '../../../Widgets/custom_text.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/gradint_button.dart';

class SecoundForgetScreen extends StatefulWidget {
  const SecoundForgetScreen({super.key});

  @override
  State<SecoundForgetScreen> createState() => _SecoundForgetScreenState();
}

String? validateEmail(String? value) {
  if (!value!.isEmail() && value.isEmpty) {
    return 'لو سمحت ادخل بريدك الالكتروني';
  }
}

class _SecoundForgetScreenState extends State<SecoundForgetScreen> {
  final _key = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final pinController = TextEditingController();
  final defaultPinTheme = PinTheme(
    width: 50.w,
    height: 50.h,
    padding: EdgeInsets.all(10.w),
    margin: EdgeInsets.all(15.w),
    textStyle: const TextStyle(
      fontSize: 32,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightgrey),
        color: AppColors.lightgrey),
  );

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
                              'ادخل كود التفعيل',
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
                            'assets/images/forget_pass/secound_step.png',
                            fit: BoxFit.fill,
                            height: 35.h,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Container(
                            width: 335.w,
                            child: Pinput(
                              length: 4,
                              // pinContentAlignment: Alignment.center,
                              obscureText: true,
                              defaultPinTheme: defaultPinTheme,

                              closeKeyboardWhenCompleted: true,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          RaisedGradientButton(
                            text: 'التالي',
                            width: 340.w,
                            color: AppColors.scadryColor,
                            height: 48.h,
                            circular: 10.w,
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                _key.currentState!.save();
                                FocusScope.of(context).unfocus();

                                Navigator.popAndPushNamed(
                                    context, '/theard_screen');
                              }
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/signup_screen');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  'لم تصلك رسالة حتى الان ؟',
                                  textAlign: TextAlign.start,
                                  fontSize: 16.sp,
                                  fontFamily: 'DINNEXTLTARABIC',
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.orange,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                CustomText(
                                  'اعادة الارسال ',
                                  textAlign: TextAlign.start,
                                  fontSize: 16.sp,
                                  fontFamily: 'DINNEXTLTARABIC',
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          )
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
