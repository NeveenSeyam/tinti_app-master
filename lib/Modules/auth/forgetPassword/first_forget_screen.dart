import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:regexpattern/regexpattern.dart';
import '../../../Helpers/failure.dart';
import '../../../Util/theme/app_colors.dart';
import '../../../Widgets/custom_text.dart';
import '../../../Widgets/custom_text_field.dart';
import '../../../Widgets/gradint_button.dart';
import '../../../Widgets/loader_widget.dart';
import '../../../Widgets/loading_dialog.dart';
import '../../../Widgets/text_widget.dart';
import '../../../provider/account_provider.dart';
import '../../Home/main/services/saels_page.dart';

class FirstForgetScreen extends ConsumerStatefulWidget {
  const FirstForgetScreen({super.key});

  @override
  _FirstForgetScreenState createState() => _FirstForgetScreenState();
}

String? validatePassword(String? value) {
  if (value!.length < 6) {
    return 'يجب ان تكون كلمة السر 6 احرف على الاقل ';
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

  final TextEditingController _emailController = TextEditingController();
  Future _getContentData() async {
    final prov = ref.read(accountProvider);

    return await prov.forgetPassRequest(email: _emailController.text);
  }

  final pinController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVerfied = false;
  User? user;
  String verificationID = "";

  late Future _fetchedMyRequest;
  late Future _fetchedUpdateRequest;

  // Future _getUpdateData() async {
  //   final prov = ref.read(accountProvider);

  //   return await prov.;
  // }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _fetchedMyRequest = _getContentData();

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
      body: Consumer(
        builder: (context, ref, child) => FutureBuilder(
          future: _fetchedMyRequest,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 70.h,
                child: const Center(
                  child: LoaderWidget(),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data is Failure) {
                return Center(child: TextWidget(snapshot.data.toString()));
              }
              //
              //  print("snapshot data is ${snapshot.data}");

              // var getModel =
              // var forgetModel = ref.watch(accountProvider).getForgetPassModel;
              var changPassModel = ref.watch(accountProvider);
              return validate == 1
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                                                  email: _emailController.text);

                                          var forgetModel = ref
                                              .watch(accountProvider)
                                              .getForgetPassModel;
                                          print(
                                              'forgetModel?.data?.mobile.toString() ${forgetModel?.data?.mobile.toString()}');
                                          // _getContentData();
                                          await loginWithPhone(forgetModel
                                              ?.data?.mobile
                                              .toString());
                                          Navigator.of(context).pop();

                                          validate = 2;

                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           SecoundForgetScreen(
                                          //               verificationID:
                                          //                   verificationID,
                                          //               otpVerfied:
                                          //                   otpVerfied)),
                                          // );

                                          // Navigator.popAndPushNamed(
                                          // context, '/secound_screen');
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
                                            color:
                                                Color.fromARGB(255, 47, 47, 47)
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
                                              padding:
                                                  EdgeInsetsDirectional.only(
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

                                                length: 6,
                                                // pinContentAlignment: Alignment.center,
                                                obscureText: true,
                                                defaultPinTheme:
                                                    defaultPinTheme,
                                                controller: pinController,
                                                closeKeyboardWhenCompleted:
                                                    true,
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
                                                await verifyOTP();
                                                validate = 3;
                                                // if (_key.currentState!.validate()) {
                                                //   _key.currentState!.save();
                                                //   FocusScope.of(context).unfocus();

                                                // }
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
                                                keyboardType: TextInputType
                                                    .visiblePassword,
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
                                                hintText:
                                                    'confirm-new-pass'.tr(),
                                                keyboardType: TextInputType
                                                    .visiblePassword,
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
                                                  print(
                                                      '${_emailController.text}');

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
                                                    fontFamily:
                                                        'DINNEXTLTARABIC',
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
                                                        context,
                                                        '/login_screen');
                                                  },
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                )
                              : Container();
            }
            return Container();
          },
        ),
      ),
    ));
  }

  Future<void> loginWithPhone(val) async {
    auth.verifyPhoneNumber(
      phoneNumber: val,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
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
        verificationId: verificationID, smsCode: pinController.text);
    await auth.signInWithCredential(credential).then(
      (value) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
      },
    ).whenComplete(
      () {
        if (user != null) {
          // Fluttertoast.showToast(
          //   msg: "You are logged in successfully",
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 1,
          //   backgroundColor: Colors.red,
          //   textColor: Colors.white,
          //   fontSize: 16.0,
          // );
          otpVerfied = true;
        } else {
          // Fluttertoast.showToast(
          //   msg: "your login is failed",
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 1,
          //   backgroundColor: Colors.red,
          //   textColor: Colors.white,
          //   fontSize: 16.0,
          // );
          otpVerfied = false;
        }
      },
    );
  }
}
