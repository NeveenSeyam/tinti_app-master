import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinti_app/Util/theme/app_colors.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:tinti_app/Widgets/custom_button.dart';
import 'package:tinti_app/provider/account_provider.dart';

import '../../Helpers/failure.dart';
import '../../Models/auth/user_model.dart';
import '../../Util/constants/constants.dart';
import '../../Util/constants/keys.dart';
import '../../Widgets/auth_screens.dart';
import '../../Widgets/custom_text.dart';
import '../../Widgets/custom_text_field.dart';
import '../../Widgets/gradint_button.dart';
import '../../Widgets/loading_dialog.dart';
import '../../helpers/ui_helper.dart';
import '../Home/a.dart';
import 'TRY/home.dart';
import 'login_screen.dart';

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
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  final TextEditingController _confiremPasswordController =
      TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVerfied = false;
  User? user;

  String? validateConfiremPassword(String? value) {
    if (_confiremPasswordController == _passwordController) {
      return ' كلمة مطابقة    ';
    } else {
      return 'يجب ان تكون كلمة السر مطابقة    ';
    }
  }

  Future _activeFun(BuildContext context, WidgetRef ref) async {
    var ActivateProvider = ref.read(accountProvider);
    final response = await ActivateProvider.activateUserRequset();
    return response;
  }

  Future _loginFun(BuildContext context, WidgetRef ref) async {
    //context.router.push(const OTPScreenRoute());

    loadingDialog(context);
    //await AuthProvider.loginOut();
    // get fcm tokenhld,gdjv
    //print("token $token");
    var AuthProvider = ref.read(accountProvider);
    final response = await AuthProvider.postRegisterUser(
      fName: _fNameController.text,
      confirmPassword: _confiremPasswordController.text,
      email: _emailController.text,
      password: _passwordController.text,
      phoneNumber: _mobileController.text,
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

        // Navigator.pushNamed(context, '/navegaitor_screen');
        if (_Key.currentState!.validate()) {
          _Key.currentState!.save();

          FocusScope.of(context).unfocus();
          // ignore: use_build_context_synchronously
          showDialog(
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
                                verifyOTP();
                                otpVerfied == true
                                    ? ref
                                        .read(accountProvider)
                                        .activateUserRequset()
                                    : null;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHomePage(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, '/navegaitor_screen');
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
        // final userProv = ref.read(userProvider);
        // userProv.setUser(LoginModel.fromJson(response));
        // prefs.setString(Keys.hasSaveUserData,
        log("value $value");
        //  var user = UserLogin.fromJson(value);
        // if (isRememberMe) {
        //   var userData =
        //       json.encoder.convert(UserLogin.fromJson(user.toJson()));
        //   SharedPreferences? prefs = await SharedPreferences.getInstance();
        //   prefs.setString(Keys.hasSaveUserData, userData);
        // }

        //    Constants.userTokent = user.data?.token ?? "";
      } else {
        Navigator.pop(context);
      }
    });
    log("response $response");
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
                        Row(
                          children: [
                            RoundedInputField(
                              width: 50.w,
                              hintText: '+ ',
                              onChanged: (value) {},
                              hintColor: AppColors.hint,
                              color: AppColors.lightgrey,
                              circuler: 10.w,
                              height: 48.h,
                              validator: validateCountryNumber,
                              seen: false,
                              controller: _countryController,
                            ),
                            RoundedInputField(
                              hintText: 'رقم الهاتف',
                              width: 300.w,
                              onChanged: (value) {},
                              hintColor: AppColors.hint,
                              color: AppColors.lightgrey,
                              circuler: 10.w,
                              height: 48.h,
                              icon: Icon(
                                Icons.mobile_screen_share_sharp,
                                color: AppColors.hint,
                                size: 17.w,
                              ),
                              validator: validateMobileNumber,
                              seen: false,
                              controller: _mobileController,
                            ),
                          ],
                        ),
                        RoundedInputField(
                          hintText: 'كلمة المرور',
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
                          validator: validatePassword,
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
                          // validator: validateConfiremPassword,
                          controller: _confiremPasswordController,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Consumer(
                          builder: (context, ref, _) {
                            return GestureDetector(
                                onTap: () {
                                  _loginFun(context, ref);
                                },
                                child: RaisedGradientButton(
                                  text: 'تسجيل ',
                                  color: AppColors.scadryColor,
                                  width: 340.w,
                                  height: 48.h,
                                  circular: 10.w,
                                  onPressed: () {
                                    _loginFun(context, ref);

                                    loginWithPhone();
                                  },
                                ));
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
    auth.verifyPhoneNumber(
      phoneNumber: _countryController.text + _mobileController.text,
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

  verifyOTP() async {
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
            msg: "You are logged in successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          otpVerfied = true;
        } else {
          Fluttertoast.showToast(
            msg: "your login is failed",
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
