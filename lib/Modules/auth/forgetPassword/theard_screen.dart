import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:regexpattern/regexpattern.dart';

import '../../../Util/theme/app_colors.dart';
import '../../../Widgets/custom_text.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/gradint_button.dart';

class TheardForgetScreen extends StatefulWidget {
  const TheardForgetScreen({super.key});

  @override
  State<TheardForgetScreen> createState() => _TheardForgetScreenState();
}

String? validatePassword(String? value) {
  if (value!.length < 6) {
    return 'يجب ان تكون كلمة السر 6 احرف على الاقل ';
  }
}

class _TheardForgetScreenState extends State<TheardForgetScreen> {
  final _key = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? validateConfiremPassword(String? value) {
    if (_passwordController != _confirmPasswordController) {
      return 'يجب ان تكون كلمة السر مطابقة    ';
    }
  }

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
                              ' تعيين كلمة مرور جديدة',
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
                            'assets/images/forget_pass/theard_step.png',
                            fit: BoxFit.fill,
                            height: 35.h,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          RoundedInputField(
                            hintText: 'كلمة مرور جديدة ',
                            onChanged: (value) {},
                            hintColor: AppColors.hint,
                            color: AppColors.lightgrey,
                            circuler: 10.w,
                            height: 48.h,
                            icon: Icon(
                              Icons.email,
                              color: AppColors.hint,
                              size: 17.w,
                            ),
                            validator: validatePassword,
                            seen: true,
                            controller: _passwordController,
                          ),
                          RoundedInputField(
                            hintText: 'تأكيد كلمة المرور  ',
                            onChanged: (value) {},
                            hintColor: AppColors.hint,
                            color: AppColors.lightgrey,
                            circuler: 10.w,
                            height: 48.h,
                            icon: const Icon(
                              Icons.email,
                              color: AppColors.hint,
                            ),
                            validator: validatePassword,
                            seen: true,
                            controller: _confirmPasswordController,
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          RaisedGradientButton(
                            text: 'التالي',
                            color: AppColors.scadryColor,
                            height: 48.h,
                            circular: 10.w,
                            width: 340.w,
                            onPressed: () {
                              if (_key.currentState!.validate()) {
                                _key.currentState!.save();
                                FocusScope.of(context).unfocus();
                              }
                              Navigator.popAndPushNamed(
                                  context, '/final_screen');
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
