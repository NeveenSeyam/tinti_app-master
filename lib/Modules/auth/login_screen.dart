import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:tinti_app/Widgets/custom_button.dart';

import '../../Helpers/failure.dart';
import '../../Util/constants/constants.dart';
import '../../Util/constants/keys.dart';
import '../../Widgets/auth_screens.dart';
import '../../Widgets/custom_text.dart';
import '../../Widgets/custom_text_field.dart';
import '../../Widgets/gradint_button.dart';
import '../../Widgets/loading_dialog.dart';
import '../../helpers/ui_helper.dart';
import '../../provider/account_provider.dart';
import 'forgetPassword/first_forget_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

String? validateEmail(String? value) {
  if (!value!.isEmail() && value.isEmpty) {
    return 'email verfication'.tr();
  }
  // return value;
}

String? validatePassword(String? value) {
  if (value!.length < 6) {
    return 'password verfication'.tr();
  }
  // return value;
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _Key = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future _loginFun(BuildContext context, WidgetRef ref) async {
    //context.router.push(const OTPScreenRoute());

    loadingDialog(context);
    //await AuthProvider.loginOut();
    // get fcm tokenhld,gdjv
    //print("token $token");
    var AuthProvider = ref.read(accountProvider);
    final response = await AuthProvider.postLogin(
      email: _emailController.text,
      password: _passwordController.text,
    ).onError((error, stackTrace) {
      Navigator.pop(context);
    }).then((value) async {
      if (value is! Failure) {
        if (value == null) {
          UIHelper.showNotification("error".tr());
          //    Navigator.pop(context);
          return;
        }
        if (value != false) {
          Constants.token = value["data"]["token"];
          Constants.isQuest = false;
          SharedPreferences? _prefs = await SharedPreferences.getInstance();
          _prefs.setString(Keys.hasSaveUserData, value["data"]["token"]);
          _prefs.setString("lang", Constants.lang!);
          await AuthProvider.getUserProfileRequset();

          Navigator.pop(context);
          Navigator.popAndPushNamed(context, '/navegaitor_screen');
        } else {
          Navigator.pop(context); //134092
        }
      } else {
        Navigator.pop(context);
      }
    });
    log("response $response");
  }

  var logo = Constants.logo;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.scadryColor,
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.all(20.h),
            child: Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                logo!,
                height: 100.h,
                width: 300.h,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 47, 47, 47).withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.w),
                    topRight: Radius.circular(35.w),
                  )),
              height: 700.h,
              alignment: Alignment.bottomCenter,
              child: Form(
                key: _Key,
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsetsDirectional.only(start: 15.w),
                          child: CustomText(
                            'login'.tr(),
                            textAlign: TextAlign.start,
                            fontSize: 18.sp,
                            fontFamily: 'DINNEXTLTARABIC',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        RoundedInputField(
                          hintText: 'emailormobile'.tr(),
                          onChanged: (value) {},
                          keyboardType: TextInputType.emailAddress,
                          hintColor: AppColors.hint,
                          color: AppColors.lightgrey,
                          circuler: 10.w,
                          height: 48.h,
                          icon: const Icon(
                            Icons.email,
                            color: AppColors.hint,
                          ),
                          validator: validateEmail,
                          seen: false,
                          controller: _emailController,
                        ),
                        RoundedInputField(
                          hintText: 'password'.tr(),
                          onChanged: (value) {},
                          keyboardType: TextInputType.visiblePassword,
                          isObscured: true,
                          hintColor: AppColors.hint,
                          color: AppColors.lightgrey,
                          circuler: 10.w,
                          height: 48.h,
                          icon: const Icon(
                            Icons.key,
                            color: AppColors.hint,
                          ),
                          seen: true,
                          validator: validatePassword,
                          controller: _passwordController,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FirstForgetScreen()),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 10.w),
                              child: CustomText(
                                'forget-pass'.tr(),
                                textAlign: TextAlign.start,
                                fontSize: 15.sp,
                                color: AppColors.orange,
                                fontFamily: 'DINNEXTLTARABIC',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        RaisedGradientButton(
                          text: 'login'.tr(),
                          color: AppColors.scadryColor,
                          height: 48.h,
                          width: 340.w,
                          circular: 10.w,
                          onPressed: () {
                            if (_Key.currentState!.validate()) {
                              _Key.currentState!.save();
                              FocusScope.of(context).unfocus();
                              _loginFun(context, ref);
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.popAndPushNamed(
                                context, '/signup_screen');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                'dont-have-account'.tr(),
                                textAlign: TextAlign.start,
                                fontSize: 16.sp,
                                fontFamily: 'DINNEXTLTARABIC',
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              CustomText(
                                'signup'.tr(),
                                textAlign: TextAlign.start,
                                fontSize: 16.sp,
                                fontFamily: 'DINNEXTLTARABIC',
                                fontWeight: FontWeight.w400,
                                color: AppColors.orange,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
