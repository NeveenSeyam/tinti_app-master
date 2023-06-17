import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:tinti_app/apis/sms_verify.dart';
import 'package:tinti_app/provider/account_provider.dart';
import '../../Helpers/failure.dart';
import '../../Util/constants/constants.dart';
import '../../Util/constants/keys.dart';
import '../../Widgets/custom_text.dart';
import '../../Widgets/custom_text_field.dart';
import '../../Widgets/gradint_button.dart';
import '../../Widgets/loader_widget.dart';
import '../../Widgets/loading_dialog.dart';
import '../../Widgets/text_widget.dart';
import '../../helpers/ui_helper.dart';
import '../../provider/app_data_provider.dart';
import '../Home/a.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

String? validateEmail(String? value) {
  if (!value!.isEmail() && value.isEmpty) {
    return 'email verfication'.tr();
  }
}

String? validateFirstName(String? value) {
  if (!value!.isNotEmpty || value.length > 20) {
    return 'name verfication'.tr();
  }
}

String? validateLastName(String? value) {
  if (!value!.isNotEmpty || value.length > 20) {
    return 'name verfication'.tr();
  }
}

String? validateMobileNumber(String? value) {
  if (value!.length < 7 || value.length > 14) {
    return 'mobile verfication'.tr();
  }
}

String? validateCountryNumber(String? value) {
  if (value!.length < 2 || value.length > 4) {
    return 'contry verfication'.tr();
  }
}

String? validatePassword(String? value) {
  if (value!.length < 6) {
    return 'password verfication'.tr();
  }
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _Key = GlobalKey<FormState>();

  String verificationID = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  var mob = '';
  TextEditingController otpController = TextEditingController();

  bool otpVerfied = false;

  String? validateConfiremPassword(String? value) {
    if (_cpasswordController.text == _passwordController.text) {
      return ' كلمة مطابقة    ';
    } else {
      return 'يجب ان تكون كلمة السر مطابقة    ';
    }
  }

  Future _getIntrosData() async {
    final prov = ref.read(appDataProvider);

    return await prov.getAppDataRequset();
  }

  late Future _fetchedIntroRequest;

  Future _activeFun(BuildContext context, WidgetRef ref) async {
    var ActivateProvider = ref.read(accountProvider);
    final response = await ActivateProvider.activateUserRequset();
    return response;
  }

  @override
  void initState() {
    super.initState();
    _fetchedIntroRequest = _getIntrosData();
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
    if (_cpasswordController.text == _passwordController.text) {
      return true;
    } else {
      return false;
    }
  }

  Future _loginFun(BuildContext context, WidgetRef ref) async {
    //context.router.push(const OTPScreenRoute());

    if (_Key.currentState!.validate()) {
      _Key.currentState!.save();
      loadingDialog(context);
      //await AuthProvider.loginOut();
      // get fcm tokenhld,gdjv
      //print("token $token");
      var AuthProvider = ref.read(accountProvider);
      final response = await AuthProvider.postRegisterUser(
        fName: _fNameController.text,
        confirmPassword: _cpasswordController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phoneNumber: mob,
        lName: _lNameController.text,
      ).onError((error, stackTrace) {
        Navigator.pop(context);
      }).then((value) async {
        if (value is! Failure) {
          if (value == null) {
            UIHelper.showNotification("حصل خطأ ما");
            //    Navigator.pop(context);
            return;
          }

          Constants.token = value["data"]["token"];
          SharedPreferences? _prefs = await SharedPreferences.getInstance();
          _prefs.setString(Keys.hasSaveUserData, value["data"]["token"]);
          await AuthProvider.getUserProfileRequset();
          Navigator.pop(context); //134092
        } else {
          Navigator.pop(context);
        }
      });
      log("response $response");

      FocusScope.of(context).unfocus();
      // ignore: use_build_context_synchronously
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            // Future.delayed(
            //     Duration(seconds: 1000), () {
            //   Navigator.of(context).pop(true);
            // });
            return AlertDialog(
                insetPadding: EdgeInsets.all(8.0),
                title: CustomText(
                  "تفعيل الحساب",
                  fontSize: 24.sp,
                  textAlign: TextAlign.center,
                  fontFamily: 'DINNEXTLTARABIC',
                  color: AppColors.scadryColor,
                ),
                content: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.w)),
                    width: MediaQuery.of(context).size.width - 100,
                    height: 300.h,
                    child: Column(
                      children: [
                        CustomText(
                          'تم ارسال كود التفعيل الى رقم الجوال المدرج سابقاً الرجاء ادخال الكود المرسل في الحقل أدناه',
                          textAlign: TextAlign.center,
                          fontFamily: 'DINNEXTLTARABIC',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w300,
                        ),
                        SizedBox(
                          height: 22.h,
                        ),
                        SizedBox(
                          width: 335.w,
                          child: Pinput(
                            length: 4,
                            // pinContentAlignment: Alignment.center,
                            obscureText: true,
                            defaultPinTheme: defaultPinTheme,

                            closeKeyboardWhenCompleted: true,
                            textInputAction: TextInputAction.next,
                            controller: otpController,
                          ),
                        ),
                        SizedBox(
                          height: 22.h,
                        ),
                        RaisedGradientButton(
                          text: 'التالي',
                          width: 340.w,
                          color: AppColors.scadryColor,
                          height: 48.h,
                          circular: 10.w,
                          onPressed: () async {},
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/navegaitor_screen');
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
                              GestureDetector(
                                onTap: () {},
                                child: CustomText(
                                  'اعادة الارسال ',
                                  textAlign: TextAlign.start,
                                  fontSize: 16.sp,
                                  fontFamily: 'DINNEXTLTARABIC',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )));
          });
    }
  }

  final defaultPinTheme = PinTheme(
    width: 70.w,
    height: 50.h,
    padding: EdgeInsets.all(5.w),
    margin: EdgeInsets.all(5.w),
    textStyle: const TextStyle(
      fontSize: 32,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightgrey),
        color: AppColors.lightgrey),
  );

  var logo = Constants.logo;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColors.scadryColor,
      body: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.all(20.h),
            child: Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                logo!,
                height: 100.h,
                width: 300.w,
              ),
            ),
          ), // const Spacer(),
          Container(
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
            height: 720.h,
            alignment: Alignment.bottomCenter,
            child: Form(
              key: _Key,
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 10.w),
                        child: CustomText(
                          'new_signup'.tr(),
                          fontSize: 18.sp,
                          fontFamily: 'DINNEXTLTARABIC',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      RoundedInputField(
                        hintText: 'fname'.tr(),
                        onChanged: (value) {},
                        hintColor: AppColors.hint,
                        keyboardType: TextInputType.name,
                        color: AppColors.lightgrey,
                        circuler: 10.w,
                        height: 48.h,
                        icon: const Icon(
                          Icons.person,
                          color: AppColors.hint,
                        ),
                        validator: validateFirstName,
                        seen: false,
                        controller: _fNameController,
                      ),
                      RoundedInputField(
                        hintText: 'lname'.tr(),
                        onChanged: (value) {},
                        hintColor: AppColors.hint,
                        color: AppColors.lightgrey,
                        keyboardType: TextInputType.name,
                        circuler: 10.w,
                        height: 48.h,
                        icon: Icon(
                          Icons.person,
                          color: AppColors.hint,
                          size: 17.w,
                        ),
                        validator: validateLastName,
                        seen: false,
                        controller: _lNameController,
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
                      Container(
                        width: 350.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 3.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.w),
                            color: AppColors.grey.withOpacity(0.3)),
                        child: SizedBox(
                          width: 200.w,
                          child: InternationalPhoneNumberInput(
                            textStyle: TextStyle(fontFamily: 'DINNEXTLTARABIC'),
                            // textAlign: TextAlign.end,
                            textFieldController: _mobileController,
                            // ignoreBlank: true,
                            inputDecoration: InputDecoration(
                              hintText: 'mobile'.tr(),
                              hintStyle:
                                  TextStyle(fontFamily: 'DINNEXTLTARABIC'),
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.number,
                            onInputChanged: (PhoneNumber number) {
                              print(number.phoneNumber);
                              mob = number.phoneNumber.toString();
                              print('mob  ${mob}');
                            },
                            onInputValidated: (bool value) {}, maxLength: 11,
                            errorMessage: 'mobile verfication'.tr(),
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.DIALOG,
                            ),
                          ),
                        ),
                      ),
                      RoundedInputField(
                        hintText: 'password'.tr(),
                        onChanged: (value) {},
                        isObscured: false,
                        hintColor: AppColors.hint,
                        color: AppColors.lightgrey,
                        circuler: 10.w,
                        keyboardType: TextInputType.visiblePassword,
                        height: 48.h,
                        icon: Icon(
                          Icons.key,
                          color: AppColors.hint,
                          size: 17.w,
                        ),
                        seen: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "null verfication".tr();
                          } else {
                            //call function to check password
                            bool result = validatePassword(value);
                            if (result) {
                              // create account event
                              return null;
                            } else {
                              return 'password verfication'.tr();
                            }
                          }
                        },
                        controller: _passwordController,
                      ),
                      RoundedInputField(
                        hintText: 'cpassword'.tr(),
                        onChanged: (value) {},
                        isObscured: true,
                        hintColor: AppColors.hint,
                        keyboardType: TextInputType.visiblePassword,
                        color: AppColors.lightgrey,
                        circuler: 10.w,
                        height: 48.h,
                        icon: Icon(
                          Icons.key,
                          color: AppColors.hint,
                          size: 17.w,
                        ),
                        seen: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "null verfication".tr();
                          } else {
                            //call function to check password
                            bool result = validateConfirmPassword(value);
                            if (result) {
                              // create account event
                              return null;
                            } else {
                              return "confirm password verfication".tr();
                            }
                          }
                        },
                        controller: _cpasswordController,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Consumer(
                        builder: (context, ref, _) {
                          var userModel = ref.read(accountProvider);
                          return RaisedGradientButton(
                            text: 'signup'.tr(),
                            color: AppColors.scadryColor,
                            width: 340.w,
                            height: 48.h,
                            circular: 10.w,
                            onPressed: () async {
                              // _loginFun(context, ref);

                              if (_Key.currentState!.validate()) {
                                _Key.currentState!.save();
                                loadingDialog(context);
                                //await AuthProvider.loginOut();
                                // get fcm tokenhld,gdjv
                                //print("token $token");
                                var AuthProvider = ref.read(accountProvider);
                                final response =
                                    await AuthProvider.postRegisterUser(
                                  fName: _fNameController.text,
                                  confirmPassword: _cpasswordController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  phoneNumber: mob,
                                  lName: _lNameController.text,
                                ).onError((error, stackTrace) {
                                  Navigator.pop(context);
                                }).then((value) async {
                                  if (value is! Failure) {
                                    if (value == null) {
                                      UIHelper.showNotification(
                                          'reqister error'.tr());
                                      //    Navigator.pop(context);
                                      return;
                                    }
                                    final smsSending =
                                        await AuthProvider.SentOtp(
                                      lang: Constants.lang ?? 'ar',
                                      number: _mobileController.text,
                                      userName: 'mycar',
                                      apiKey:
                                          '91e86fe240dccf44aeaa51563ed0c03c',
                                      userSender: 'sayyarte|سيارتي',
                                    ).onError((error, stackTrace) {
                                      Navigator.pop(context);
                                    }).then((value) async {
                                      if (value is! Failure) {
                                        if (value == null) {
                                          UIHelper.showNotification(
                                              'reqister error'.tr());
                                          //    Navigator.pop(context);
                                          return;
                                        }
                                        Navigator.pop(context);

                                        // Constants.token =
                                        //     value["data"]["token"];
                                        // SharedPreferences? _prefs =
                                        //     await SharedPreferences
                                        //         .getInstance();
                                        // _prefs.setString(Keys.hasSaveUserData,
                                        //     value["data"]["token"]);
                                        // await AuthProvider
                                        //     .getUserProfileRequset();
                                        var smsId = await AuthProvider
                                            .getSmsResultModel?.id;
                                        print('smsId $smsId');
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                  insetPadding:
                                                      EdgeInsets.all(8.0),
                                                  title: CustomText(
                                                    'active'.tr(),
                                                    fontSize: 24.sp,
                                                    textAlign: TextAlign.center,
                                                    fontFamily:
                                                        'DINNEXTLTARABIC',
                                                    color:
                                                        AppColors.scadryColor,
                                                  ),
                                                  content: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.w)),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              100,
                                                      height: 300.h,
                                                      child: Column(
                                                        children: [
                                                          CustomText(
                                                            'activate msg'.tr(),
                                                            textAlign: TextAlign
                                                                .center,
                                                            fontFamily:
                                                                'DINNEXTLTARABIC',
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                          SizedBox(
                                                            height: 22.h,
                                                          ),
                                                          SizedBox(
                                                            width: 335.w,
                                                            child: Pinput(
                                                              length: 4,
                                                              // pinContentAlignment: Alignment.center,
                                                              obscureText: true,
                                                              defaultPinTheme:
                                                                  defaultPinTheme,

                                                              closeKeyboardWhenCompleted:
                                                                  true,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .next,
                                                              controller:
                                                                  otpController,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 22.h,
                                                          ),
                                                          RaisedGradientButton(
                                                            text: 'next'.tr(),
                                                            width: 340.w,
                                                            color: AppColors
                                                                .scadryColor,
                                                            height: 48.h,
                                                            circular: 10.w,
                                                            onPressed:
                                                                () async {
                                                              final verifySmsOtp = await ref
                                                                  .read(
                                                                      accountProvider)
                                                                  .verifySmsOtp(
                                                                      lang: Constants
                                                                              .lang ??
                                                                          'ar',
                                                                      id: smsId,
                                                                      userName:
                                                                          'mycar',
                                                                      apiKey:
                                                                          '91e86fe240dccf44aeaa51563ed0c03c',
                                                                      userSender:
                                                                          'sayyarte|سيارتي',
                                                                      code: otpController
                                                                          .text)
                                                                  .then(
                                                                      (value) {
                                                                print(
                                                                    'lang ${Constants.lang},id ${smsId},code ${otpController.text} ');
                                                                if (value
                                                                    is! Failure) {
                                                                  if (value ==
                                                                      null) {
                                                                    // UIHelper.showNotification(
                                                                    //     'reqister error'
                                                                    //         .tr());
                                                                    //    Navigator.pop(context);
                                                                    return;
                                                                  }
                                                                  if (value !=
                                                                      false) {
                                                                    _activeFun(
                                                                        context,
                                                                        ref);
                                                                    Navigator.pushNamed(
                                                                        context,
                                                                        '/navegaitor_screen');
                                                                  } else {
                                                                    UIHelper.showNotification(
                                                                        'هناك خطأ ما');
                                                                  }
                                                                }
                                                              });
                                                            },
                                                          ),
                                                          SizedBox(
                                                            height: 16.h,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              // Navigator.pushNamed(
                                                              //     context,
                                                              //     '/navegaitor_screen');
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                CustomText(
                                                                  'not confirm'
                                                                      .tr(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontFamily:
                                                                      'DINNEXTLTARABIC',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: AppColors
                                                                      .orange,
                                                                ),
                                                                SizedBox(
                                                                  width: 5.w,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {},
                                                                  child:
                                                                      CustomText(
                                                                    'resent'
                                                                        .tr(),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontFamily:
                                                                        'DINNEXTLTARABIC',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      )));
                                            });
                                        //134092
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    });
                                  } else {
                                    Navigator.pop(context);
                                  }
                                });
                                log("response $response");
                                var otpMsg = await ref
                                    .watch(accountProvider)
                                    .getSmsResultModel;

/////////////////////smsSending
                                ///
                                ///
                                ///
                                ///

                                FocusScope.of(context).unfocus();
                                // ignore: use_build_context_synchronously
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Consumer(builder: (context, ref, _) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/login_screen');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                "have-an-account".tr(),
                                textAlign: TextAlign.start,
                                fontSize: 16.sp,
                                fontFamily: 'DINNEXTLTARABIC',
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              CustomText(
                                'login'.tr(),
                                textAlign: TextAlign.start,
                                fontSize: 16.sp,
                                fontFamily: 'DINNEXTLTARABIC',
                                fontWeight: FontWeight.w400,
                                color: AppColors.orange,
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(
                        height: 40.h,
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          insetPadding: EdgeInsets.all(8.0),
                                          title: CustomText(
                                            'privacy-policy'.tr(),
                                            fontSize: 14.sp,
                                            textAlign: TextAlign.center,
                                            fontFamily: 'DINNEXTLTARABIC',
                                            color: AppColors.scadryColor,
                                          ),
                                          content: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.w)),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            height: 700.h,
                                            child: Consumer(
                                              builder: (context, ref, child) =>
                                                  FutureBuilder(
                                                future: _fetchedIntroRequest,
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return SizedBox(
                                                      height: 70.h,
                                                      child: const Center(
                                                        child: LoaderWidget(),
                                                      ),
                                                    );
                                                  }
                                                  if (snapshot.hasError) {
                                                    return Center(
                                                      child: Text(
                                                          'Error: ${snapshot.error}'),
                                                    );
                                                  }
                                                  if (snapshot.hasData) {
                                                    if (snapshot.data
                                                        is Failure) {
                                                      return Center(
                                                          child: TextWidget(
                                                              snapshot.data
                                                                  .toString()));
                                                    }
                                                    //
                                                    //  print("snapshot data is ${snapshot.data}");

                                                    var appDataModel = ref
                                                        .watch(appDataProvider)
                                                        .getDataList;

                                                    return Padding(
                                                      padding:
                                                          EdgeInsets.all(20.w),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 650.h,
                                                            child: ListView(
                                                              children: [
                                                                CustomText(
                                                                  appDataModel
                                                                          ?.intros?[
                                                                              1]
                                                                          .description ??
                                                                      'aboutus'
                                                                          .tr(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  fontFamily:
                                                                      'DINNEXTLTARABIC',
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                  return Container();
                                                },
                                              ),
                                            ),
                                          ));
                                    });
                              },
                              child: CustomText(
                                'privacy-policy'.tr(),
                                textAlign: TextAlign.center,
                                fontSize: 16.sp,
                                fontFamily: 'DINNEXTLTARABIC',
                                fontWeight: FontWeight.w400,
                                color: AppColors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
