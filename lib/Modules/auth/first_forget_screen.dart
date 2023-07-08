import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:regexpattern/regexpattern.dart';
import '../../Helpers/failure.dart';
import '../../Models/forget_pass.dart';
import '../../Util/constants/constants.dart';
import '../../Util/theme/app_colors.dart';
import '../../Widgets/custom_text.dart';
import '../../Widgets/custom_text_field.dart';
import '../../Widgets/gradint_button.dart';
import '../../Widgets/loading_dialog.dart';
import '../../helpers/ui_helper.dart';
import '../../provider/account_provider.dart';

class FirstForgetScreen extends ConsumerStatefulWidget {
  const FirstForgetScreen({super.key});

  @override
  _FirstForgetScreenState createState() => _FirstForgetScreenState();
}

RegExp pass_valid = RegExp(r"(?=.*[a-z])(?=.*[A-Z])");

bool validatePassword(String pass) {
  String _password = pass.trim();
  if (pass_valid.hasMatch(_password) && pass.length > 6) {
    return true;
  } else {
    return false;
  }
}

bool validateConfirmPassword(String pass) {
  String _password = pass.trim();
  if (_confirmPasswordController.text == _passwordController.text) {
    return true;
  } else {
    return false;
  }
}

final TextEditingController _passwordController = TextEditingController();
final TextEditingController _confirmPasswordController =
    TextEditingController();
String? validateConfiremPassword(String? value) {
  if (_passwordController != _confirmPasswordController) {
    return 'يجب ان تكون كلمة السر مطابقة    ';
  }
}

String? validateEmail(String? value) {
  if (!value!.isEmail() && value.isEmpty) {
    return 'لو سمحت ادخل بريدك الالكتروني';
  }
  return value;
}

class _FirstForgetScreenState extends ConsumerState<FirstForgetScreen> {
  var validate = 1;
  final _Key = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final pinController = TextEditingController();

  bool otpVerfied = false;
  User? user;
  String verificationID = "";
  ForgetPasswordDataModel? forgetModel;
  // late Future _fetchedMyRequest;
  late Future _fetchedUpdateRequest;
  var smsId;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    super.initState();
  }

  final defaultPinTheme = PinTheme(
    width: 70.w,
    height: 50.h,
    padding: EdgeInsets.all(5.w),
    margin: EdgeInsets.all(10.w),
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
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.scadryColor,
            body: validate == 1
                ? Visibility(
                    visible: validate == 1
                        ? true
                        : validate == 2
                            ? false
                            : validate == 3
                                ? false
                                : false,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Center(
                                            child: Icon(
                                          Icons.arrow_back_ios_rounded,
                                          color: AppColors.white,
                                        )),
                                      ),
                                    ),
                                    CustomText(
                                      'forget-pass'.tr(),
                                      textAlign: TextAlign.start,
                                      fontSize: 18.sp,
                                      fontFamily: 'DINNEXTLTARABIC',
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.white,
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Center(),
                                    ),
                                  ],
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      'enter-email'.tr(),
                                      fontSize: 18.sp,
                                      fontFamily: 'DINNEXTLTARABIC',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Image.asset(
                                      'assets/images/forget_pass/first_step.png',
                                      fit: BoxFit.fill,
                                      height: 35.h,
                                    ),
                                    SizedBox(
                                      height: 16.h,
                                    ),
                                    RoundedInputField(
                                      hintText: 'email'.tr(),
                                      onChanged: (value) {},
                                      hintColor: AppColors.hint,
                                      color: AppColors.lightgrey,
                                      keyboardType: TextInputType.emailAddress,
                                      circuler: 10.w,
                                      height: 48.h,
                                      icon: Icon(
                                        Icons.email,
                                        color: AppColors.hint,
                                        size: 17.w,
                                      ),
                                      validator: validateEmail,
                                      seen: false,
                                      controller: _emailController,
                                    ),
                                    SizedBox(
                                      height: 16.h,
                                    ),
                                    RaisedGradientButton(
                                      text: 'next'.tr(),
                                      color: AppColors.scadryColor,
                                      height: 48.h,
                                      circular: 10.w,
                                      width: 340.w,
                                      onPressed: () async {
                                        await loadingDialog(context);

                                        await ref
                                            .read(accountProvider)
                                            .forgetPassRequest(
                                                email: _emailController.text)
                                            .then((value) async {
                                          print('xcvb');

                                          if (value != false) {
                                            print('xcvffb');
                                            Navigator.of(context).pop();

                                            print(
                                                'forgetModel?.data?.mobile.toString() ${forgetModel?.data?.mobile.toString()}');
                                            // _getContentData();
                                            var authProvider =
                                                ref.read(accountProvider);

                                            forgetModel = await ref
                                                .watch(accountProvider)
                                                .getForgetPassModel;
                                            if (forgetModel?.data?.mobile !=
                                                "") {
                                              final smsSending =
                                                  await authProvider.SentOtp(
                                                lang: Constants.lang ?? 'ar',
                                                number:
                                                    forgetModel?.data?.mobile ??
                                                        '',
                                                userName: 'mycar',
                                                apiKey:
                                                    '91e86fe240dccf44aeaa51563ed0c03c',
                                                userSender: 'sayyarte|سيارتي',
                                              ).then((value) async {
                                                if (value != Failure) {
                                                  if (value != false) {
                                                    smsId = await authProvider
                                                        .getSmsResultModel?.id;
                                                    // await loginWithPhone(forgetModel
                                                    //     ?.data?.mobile
                                                    //     .toString());

                                                    setState(() {
                                                      validate = 2;
                                                    });
                                                  }
                                                }
                                              });
                                            } else {
                                              // UIHelper.showNotification(
                                              //     'غير موجود');
                                              validate = 1;
                                              Navigator.of(context).pop();
                                            }
                                          } else {
                                            Navigator.of(context).pop();
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  )
                : validate == 2
                    ? Visibility(
                        visible: validate == 1
                            ? false
                            : validate == 2
                                ? true
                                : validate == 3
                                    ? false
                                    : false,
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
                                      'forget-pass'.tr(),
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
                                          offset: const Offset(0,
                                              1), // changes position of shadow
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
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.only(
                                          start: 10.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                start: 10.w),
                                            child: CustomText(
                                              'enter-code'.tr(),
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
                                              keyboardType:
                                                  TextInputType.number,

                                              length: 4,
                                              // pinContentAlignment: Alignment.center,
                                              obscureText: true,
                                              defaultPinTheme: defaultPinTheme,
                                              controller: pinController,
                                              closeKeyboardWhenCompleted: true,
                                              textInputAction:
                                                  TextInputAction.next,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                          RaisedGradientButton(
                                            text: 'next'.tr(),
                                            width: 340.w,
                                            color: AppColors.scadryColor,
                                            height: 48.h,
                                            circular: 10.w,
                                            onPressed: () async {
                                              var authProvider =
                                                  ref.read(accountProvider);

                                              await authProvider.verifySmsOtp(
                                                  lang: Constants.lang ?? 'ar',
                                                  id: smsId,
                                                  userName: 'mycar',
                                                  apiKey:
                                                      '91e86fe240dccf44aeaa51563ed0c03c',
                                                  userSender: 'sayyarte|سيارتي',
                                                  code: pinController.text);
                                              var verifyResult = await ref
                                                  .watch(accountProvider)
                                                  .getotpResultModel;
                                              if (verifyResult?.code != 1) {
                                                UIHelper.showNotification(
                                                    "خطأ");
                                                return;
                                              } else {
                                                setState(() {
                                                  validate = 3;
                                                });
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/signup_screen');
                                            },
                                            child: Center(
                                              child: CustomText(
                                                "dont_sent".tr(),
                                                textAlign: TextAlign.start,
                                                fontSize: 16.sp,
                                                fontFamily: 'DINNEXTLTARABIC',
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.orange,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ))
                    : validate == 3
                        ? Visibility(
                            visible: validate == 1
                                ? false
                                : validate == 2
                                    ? false
                                    : validate == 3
                                        ? true
                                        : false,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(20.h),
                                  child: Container(
                                    alignment: Alignment.topCenter,
                                    height: 80.h,
                                    child: Form(
                                      key: _Key,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            'forget-pass'.tr(),
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
                                ),
                                Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                      255, 47, 47, 47)
                                                  .withOpacity(0.5),
                                              spreadRadius: 4,
                                              blurRadius: 10,
                                              offset: const Offset(0,
                                                  1), // changes position of shadow
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                      start: 10.w),
                                              child: CustomText(
                                                'neew'.tr(),
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
                                              hintText: 'new-pass'.tr(),
                                              onChanged: (value) {},
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              hintColor: AppColors.hint,
                                              color: AppColors.lightgrey,
                                              circuler: 10.w,
                                              height: 48.h,
                                              icon: Icon(
                                                Icons.email,
                                                color: AppColors.hint,
                                                size: 17.w,
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "null verfication"
                                                      .tr();
                                                } else {
                                                  //call function to check password
                                                  bool result =
                                                      validatePassword(value);
                                                  if (result) {
                                                    // create account event
                                                    return null;
                                                  } else {
                                                    return 'password verfication'
                                                        .tr();
                                                  }
                                                }
                                              },
                                              seen: true,
                                              controller: _passwordController,
                                            ),
                                            RoundedInputField(
                                              hintText: 'confirm-new-pass'.tr(),
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              onChanged: (value) {},
                                              hintColor: AppColors.hint,
                                              color: AppColors.lightgrey,
                                              circuler: 10.w,
                                              height: 48.h,
                                              icon: const Icon(
                                                Icons.email,
                                                color: AppColors.hint,
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "null verfication"
                                                      .tr();
                                                } else {
                                                  //call function to check password
                                                  bool result =
                                                      validatePassword(value);
                                                  if (result) {
                                                    // create account event
                                                    return null;
                                                  } else {
                                                    return 'password verfication'
                                                        .tr();
                                                  }
                                                }
                                              },
                                              seen: true,
                                              controller:
                                                  _confirmPasswordController,
                                            ),
                                            SizedBox(
                                              height: 16.h,
                                            ),
                                            RaisedGradientButton(
                                              text: 'next'.tr(),
                                              color: AppColors.scadryColor,
                                              height: 48.h,
                                              circular: 10.w,
                                              width: 340.w,
                                              onPressed: () async {
                                                if (_Key.currentState!
                                                    .validate()) {
                                                  _Key.currentState!.save();
                                                  print(
                                                      '${_emailController.text}');
                                                  var changPassModel = await ref
                                                      .watch(accountProvider);
                                                  await changPassModel
                                                      .updatePass(data: {
                                                    'email':
                                                        _emailController.text,
                                                    'password':
                                                        _passwordController.text
                                                  });
                                                  // changPassModel
                                                  //     .getChangePassModel
                                                  //     ?.message;
                                                  Navigator.popAndPushNamed(
                                                      context, '/final_screen');
//
                                                  validate = 4;
                                                } else {
                                                  // UIHelper.showNotification(
                                                  //     'error');
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          )
                        : validate == 4
                            ? Visibility(
                                visible: validate == 1
                                    ? false
                                    : validate == 2
                                        ? false
                                        : validate == 3
                                            ? false
                                            : true,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(20.h),
                                      child: Container(
                                        alignment: Alignment.topCenter,
                                        height: 80.h,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              'forget-pass'.tr(),
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
                                    Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFF2F2F2F)
                                                    .withOpacity(0.5),
                                                spreadRadius: 4,
                                                blurRadius: 10,
                                                offset: const Offset(0,
                                                    1), // changes position of shadow
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    right: 10.w),
                                                child: CustomText(
                                                  'change-pass-details'.tr(),
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
                                                text: 'login'.tr(),
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
                                  ],
                                ),
                              )
                            : Container()));
  }
}
