import 'dart:developer';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:tinti_app/provider/account_provider.dart';
import '../../Helpers/failure.dart';
import '../../Util/constants/constants.dart';
import '../../Util/constants/keys.dart';
import '../../Widgets/custom_text.dart';
import '../../Widgets/custom_text_field.dart';
import '../../Widgets/gradint_button.dart';
import '../../Widgets/loading_dialog.dart';
import '../../helpers/ui_helper.dart';
import '../Home/a.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

String? validateEmail(String? value) {
  if (!value!.isEmail() && value.isEmpty) {
    return 'لو سمحت ادخل بريدك الالكتروني';
  }
}

String? validateFirstName(String? value) {
  if (!value!.isNotEmpty || value.length > 20) {
    return 'لو سمحت ادخل اسم متاح';
  }
}

String? validateLastName(String? value) {
  if (!value!.isNotEmpty || value.length > 20) {
    return 'لو سمحت ادخل اسم متاح';
  }
}

String? validateMobileNumber(String? value) {
  if (value!.length < 7 || value.length > 14) {
    return 'رقم الهاتف غير متاح';
  }
}

String? validateCountryNumber(String? value) {
  if (value!.length < 2 || value.length > 4) {
    return 'رقم الهاتف غير متاح';
  }
}

String? validatePassword(String? value) {
  if (value!.length < 6) {
    return 'يجب ان تكون كلمة السر 6 احرف على الاقل ';
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
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

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVerfied = false;
  User? user;

  String? validateConfiremPassword(String? value) {
    if (_cpasswordController.text == _passwordController.text) {
      return ' كلمة مطابقة    ';
    } else {
      return 'يجب ان تكون كلمة السر مطابقة    ';
    }
  }

  // activateFun() async {
  //   await
  //     otpVerfied == true
  //         ?
  //             userModel.activateUserRequset()
  //             .then((value) => otpVerfied == true
  //                 ? Navigator.pushReplacement(
  //                     context,
  //                     MaterialPageRoute(
  //                       builder: (context) => MyHomePage(),
  //                     ),
  //                   )
  //                 : null)
  //         : null;

  //     return Container();

  // }

  Future _activeFun(BuildContext context, WidgetRef ref) async {
    var ActivateProvider = ref.read(accountProvider);
    final response = await ActivateProvider.activateUserRequset();
    return response;
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
      loginWithPhone();
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
                            length: 6,
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
                          onPressed: () async {
                            verifyOTP(ref);
                          },
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
                                onTap: () {
                                  loginWithPhone();
                                },
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
  Future _verficationFun(BuildContext context, WidgetRef ref) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: _mobileController.text,
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        String smsCode = 'xxxx';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
      verificationFailed: (FirebaseAuthException error) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
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
                  'assets/images/sayartearabic.png',
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
              height: 700.h,
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
                          alignment: Alignment.centerRight,
                          child: CustomText(
                            'تسجيل جديد',
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
                          hintText: 'الاسم الأول',
                          onChanged: (value) {},
                          hintColor: AppColors.hint,
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
                          hintText: 'الاسم الأخير',
                          onChanged: (value) {},
                          hintColor: AppColors.hint,
                          color: AppColors.lightgrey,
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
                          hintText: 'البريد الالكتروني',
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
                          validator: validateEmail,
                          seen: false,
                          controller: _emailController,
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Container(
                            width: 350.w,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 3.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.w),
                                color: AppColors.grey.withOpacity(0.3)),
                            child: SizedBox(
                              width: 200.w,
                              child: InternationalPhoneNumberInput(
                                // textAlign: TextAlign.end,
                                textFieldController: _mobileController,
                                // ignoreBlank: true,
                                inputDecoration: InputDecoration(
                                  hintText: 'رقم الهاتف',
                                  border: InputBorder.none,
                                ),
                                onInputChanged: (PhoneNumber number) {
                                  print(number.phoneNumber);
                                  mob = number.phoneNumber.toString();
                                  print('mob  ${mob}');
                                },
                                onInputValidated: (bool value) {},
                                errorMessage: 'رقم هاتف خاطئ',
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                ),
                              ),
                            ),
                          ),
                        ),
                        RoundedInputField(
                          hintText: 'كلمة المرور',
                          onChanged: (value) {},
                          isObscured: false,
                          hintColor: AppColors.hint,
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
                              return "Please enter password";
                            } else {
                              //call function to check password
                              bool result = validatePassword(value);
                              if (result) {
                                // create account event
                                return null;
                              } else {
                                return " يجب ان تحتوي كلمة المرور على حروف كبيرة وحروف صغيرة وعلامات مميزة وارقام";
                              }
                            }
                          },
                          controller: _passwordController,
                        ),
                        RoundedInputField(
                          hintText: 'تأكيد كلمة المرور',
                          onChanged: (value) {},
                          isObscured: true,
                          hintColor: AppColors.hint,
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
                              return "Please enter password";
                            } else {
                              //call function to check password
                              bool result = validateConfirmPassword(value);
                              if (result) {
                                // create account event
                                return null;
                              } else {
                                return "كلمة المرور غير متطابقة ";
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
                              text: 'تسجيل ',
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
                                            "البريد الالكتروني او رقم الهاتف مستخدم ");
                                        //    Navigator.pop(context);
                                        return;
                                      }
                                      loginWithPhone();

                                      Constants.token = value["data"]["token"];
                                      SharedPreferences? _prefs =
                                          await SharedPreferences.getInstance();
                                      _prefs.setString(Keys.hasSaveUserData,
                                          value["data"]["token"]);
                                      await AuthProvider
                                          .getUserProfileRequset();
                                      Navigator.pop(context);
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            // Future.delayed(
                                            //     Duration(seconds: 1000), () {
                                            //   Navigator.of(context).pop(true);
                                            // });
                                            return AlertDialog(
                                                insetPadding:
                                                    EdgeInsets.all(8.0),
                                                title: CustomText(
                                                  "تفعيل الحساب",
                                                  fontSize: 24.sp,
                                                  textAlign: TextAlign.center,
                                                  fontFamily: 'DINNEXTLTARABIC',
                                                  color: AppColors.scadryColor,
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
                                                          'تم ارسال كود التفعيل الى رقم الجوال المدرج سابقاً الرجاء ادخال الكود المرسل في الحقل أدناه',
                                                          textAlign:
                                                              TextAlign.center,
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
                                                            length: 6,
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
                                                          text: 'التالي',
                                                          width: 340.w,
                                                          color: AppColors
                                                              .scadryColor,
                                                          height: 48.h,
                                                          circular: 10.w,
                                                          onPressed: () async {
                                                            await verifyOTP(
                                                                ref);
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
                                                                'لم تصلك رسالة حتى الان ؟',
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                fontSize: 16.sp,
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
                                                                onTap: () {
                                                                  loginWithPhone();
                                                                },
                                                                child:
                                                                    CustomText(
                                                                  'اعادة الارسال ',
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
                                  log("response $response");

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
                                  ' لديك حساب بالفعل ؟',
                                  textAlign: TextAlign.start,
                                  fontSize: 16.sp,
                                  fontFamily: 'DINNEXTLTARABIC',
                                  fontWeight: FontWeight.w400,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                CustomText(
                                  'تسجيل دخول',
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
                              CustomText(
                                'عند تسجيلك تقر وتوافق على',
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
                                ' سياسة الخصوصية وشروط الاستخدام',
                                textAlign: TextAlign.start,
                                fontSize: 16.sp,
                                fontFamily: 'DINNEXTLTARABIC',
                                fontWeight: FontWeight.w400,
                              ),
                              SizedBox(
                                height: 10.h,
                              )
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
      )),
    );
  }

  void loginWithPhone() async {
    print('aaaaa,${mob.replaceAll('-', '')}');
    auth.verifyPhoneNumber(
      phoneNumber: mob.replaceAll('-', ''),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
          Navigator.popAndPushNamed(context, '/navegaitor_screen');
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVerfied = true;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  verifyOTP(WidgetRef ref) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);
    await auth.signInWithCredential(credential).then(
      (value) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
      },
    ).whenComplete(
      () {
        if (user != null) {
          Fluttertoast.showToast(
            msg: "تم تسجيل الدخول بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          otpVerfied = true;
          // ref.read(accountProvider).getActivateModel;
          _activeFun(context, ref);

          Navigator.popAndPushNamed(context, '/navegaitor_screen');
          // activateFun();
        } else {
          Fluttertoast.showToast(
            msg: "لم يتم تسجيل الدخول",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          otpVerfied = false;
        }
      },
    );
  }
}
